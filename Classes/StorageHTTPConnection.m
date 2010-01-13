//
//  StorageHTTPConnection.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright 2009 appfactory. All rights reserved.
//


#import "StorageHTTPConnection.h"
#import "HTTPServer.h"
#import "HTTPResponse.h"
#import "CJSONSerializer.h"

#import "AFMultipartParser.h"
#import "File.h"



@implementation StorageHTTPConnection



- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path;
{
	
	NSString *contentType = NSMakeCollectable(CFHTTPMessageCopyHeaderFieldValue(request, CFSTR("Content-Type")));

	if ([contentType hasPrefix:@"multipart/form-data;"]) {
		
		requestIsMultipart = YES;
		NSString *boundary = [contentType substringFromIndex:[contentType rangeOfString:@"boundary="].location + [@"boundary=" length]];
		multipartParser = [[AFMultipartParser alloc] initWithBoundary:boundary];
		
	} else {
	
		requestIsMultipart = NO;
	}
	[contentType release];

	// We support all methods
	return YES;
}


- (void)processDataChunk:(NSData *)postDataChunk;
{
	if (requestIsMultipart) {
	
		[multipartParser parseMultipartChunk:postDataChunk];
	} else {
	
		// Append post body to request object.
		CFHTTPMessageAppendBytes(request, [postDataChunk bytes], [postDataChunk length]);
	}
}




- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)URI;
{

	NSURL *URL = [NSURL URLWithString:URI];
	
	// Normal Response
	if ([method isEqualToString:@"GET"]) {
	
		NSString *URLpath = URL.path;
		
		// File download
		if ([URLpath hasPrefix:@"/Files"]) {
		
			return [[[HTTPFileResponse alloc] initWithFilePath:[server.documentRoot.path stringByAppendingPathComponent:URLpath]] autorelease];
		
		} else	if ([URLpath isEqualToString:@"/"]) {
		
			URLpath = @"index.html";
		}
		
		
		return [[[HTTPFileResponse alloc] initWithFilePath:[[server.documentRoot.path stringByAppendingPathComponent:@"wwwroot"] stringByAppendingPathComponent:URLpath]] autorelease];
	
	} else if ([method isEqualToString:@"POST"]) {
		
		
		if ([URL.path isEqualToString:@"/__/directory/list"]) {
			
			NSDictionary *args = [self getPOSTRequestArguments];
			return [[[HTTPDataResponse alloc] initWithData:[self JSONForDirectoryContentsAtPath:[args valueForKey:@"relativePath"]]] autorelease];
			
			
		} else if ([URL.path isEqualToString:@"/__/directory/create"]) {
		
			NSDictionary *args = [self getPOSTRequestArguments];
			return [[[HTTPDataResponse alloc] initWithData:[[self createDirectory:[args valueForKey:@"name"] atPath:[args valueForKey:@"path"]] dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
			
		 
		} else if ([URL.path isEqualToString:@"/__/item/delete"]) {
		
			NSDictionary *args = [self getPOSTRequestArguments];
			return [[[HTTPDataResponse alloc] initWithData:[self deleteFiles:[args objectForKey:@"files"]]] autorelease];
			
			
			
		} else if ([URL.path isEqualToString:@"/__/file/exists/"]) {
			
			NSLog(@"margle");

		} else if (requestIsMultipart) {

			NSString *filename = [[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"filename"];
			NSString *relativePath = [[multipartParser.parts valueForKey:@"relativePath"] valueForKey:@"value"];
			NSError *error;
			[[NSFileManager defaultManager] moveItemAtPath:[[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"tmpFilePath"] toPath:[[server.documentRoot.path stringByAppendingPathComponent:relativePath] stringByAppendingPathComponent:filename] error:&error];
			
			
			// Create file.
			File *file = [[File alloc] initWithName:filename atPath:[server.documentRoot.path stringByAppendingPathComponent:relativePath]]; 
			// Post notification.
			[[NSNotificationCenter defaultCenter] postNotificationName:@"addedFileNotification" object:self userInfo:
			[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:file], @"addedFiles", nil]];
			[file release];

			// Cleanup...
			[multipartParser release];
			requestIsMultipart = NO;
			
			return [[[HTTPDataResponse alloc] initWithData:[@"true" dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
		}
	}
	
	return nil; // 404
}












# pragma mark -
# pragma mark Utility classes


- (NSMutableDictionary *)getPOSTRequestArguments;
{
	CFDataRef postData = CFHTTPMessageCopyBody(request);
	NSString *postBody = [[NSString alloc] initWithData:(NSData *)postData encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *args= [NSMutableDictionary dictionary];

	for (NSString *postBodyPart in [postBody componentsSeparatedByString:@"&"]) {
	
		NSArray *keyValuePair = [postBodyPart componentsSeparatedByString:@"="];
		NSString *key = [[[keyValuePair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
		NSString *value = [[[keyValuePair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
		
		// check to see if the key is an array, check the suffix for []
		if ([key hasSuffix:@"[]"]) {
			// it's an array... fetch or create the array from the dictionary.
			key = [key stringByReplacingOccurrencesOfString:@"[]" withString:@""];
			
			NSMutableArray *argArray;
			// does this key exist in the array?
			if ([args objectForKey:key] == nil) {
			
				argArray = [NSMutableArray arrayWithObject:value];
				[args setObject:argArray forKey:key];
			} else {
			
				argArray = [args objectForKey:key];
				[argArray addObject:value];
			}
		} else {
			[args setValue:value forKey:key];
		}
	}

	CFRelease(postData);
	[postBody release];
	
	return args;
}







# pragma mark -
# pragma mark Actions with response objects


- (NSString *)createDirectory:(NSString *)name atPath:(NSString *)path;
{

	// File name needs a length
	if (name.length <= 0) {
		return @"-1";
	}
	// No hidden files.
	if ([name hasPrefix:@"."]) {
		return @"-2";
	}
	

	// Parent path exists?
	BOOL isDirectory;
	path = [server.documentRoot.path stringByAppendingPathComponent:path];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] == NO && isDirectory == NO) {
		return @"-10";
	}
	
	// Folder already exists?
	if ([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:name]]) {
		return @"-11";
	}
	
	

	// Create
	if ([[NSFileManager defaultManager] createDirectoryAtPath:[path stringByAppendingPathComponent:name] attributes:nil]) {
		// Notify.
		
		
		File *newFile = [[File alloc] initWithName:name atPath:path];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"addedFileNotification" object:self userInfo:
			[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:newFile], @"addedFiles", nil]];
			
		[newFile release];
		
		return @"1";
	} else {
		// Unknown error.
		return @"0";
	}
}


- (NSData *)JSONForDirectoryContentsAtPath:(NSString *)path;
{
	// DataSource
	NSArray *directoryContents = [[[NSFileManager defaultManager] directoryContentsAtPath:[server.documentRoot.path stringByAppendingPathComponent:path]] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSMutableArray *storageItemList = [NSMutableArray arrayWithCapacity:[directoryContents count]];
	for (NSString *itemName in directoryContents) {
		File *storageItem = [[File alloc] initWithName:itemName atPath:[server.documentRoot.path stringByAppendingPathComponent:path]];
		[storageItemList addObject:[NSDictionary dictionaryWithObjectsAndKeys:storageItem.name, @"name", [storageItem kindDescription], @"kind", storageItem.date, @"date", storageItem.size, @"size", nil]];
		
		[storageItem release];
	}
	directoryContents = nil;
	return [[[CJSONSerializer serializer] serializeObject:storageItemList] dataUsingEncoding:NSUTF8StringEncoding];
}


- (NSData *)deleteFiles:(NSMutableArray *)files;
{
	NSLog(@"%@", files);
	
	NSMutableArray *removedFiles = [NSMutableArray arrayWithCapacity:[files count]];
	for (NSString *filepath in files) {
	
		File *file = [[File alloc] initWithName:[filepath lastPathComponent] atPath:[server.documentRoot.path stringByAppendingPathComponent:[filepath stringByDeletingLastPathComponent]]];
		if (![file delete]) {
			// return 0?
			NSLog(@"error whilst trying to delete file, http connection.");
		};
		[removedFiles addObject:file];
		[file release];
	}
	// Post notification.

	[[NSNotificationCenter defaultCenter] postNotificationName:@"removedFileNotification" object:self userInfo:
		[NSDictionary dictionaryWithObjectsAndKeys:removedFiles, @"removedFiles", nil]];
	
	return [@"1" dataUsingEncoding:NSUTF8StringEncoding];
}









@end


