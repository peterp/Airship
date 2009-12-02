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
	

	NSLog(@"response: %@ (%@)", URL.path, method);
	
	// Normal Response
	if ([method isEqualToString:@"GET"]) {
	
		NSString *URLpath = URL.path;
	
		if ([URLpath isEqualToString:@"/"]) {
			URLpath = @"index.html";
		} else if ([URLpath isEqualToString:@"/upload"]) {
			URLpath = @"upload.html";
		}
		return [[[HTTPFileResponse alloc] initWithFilePath:[[server.documentRoot.path stringByAppendingPathComponent:@"wwwroot"] stringByAppendingPathComponent:URLpath]] autorelease];
	
	} else if ([method isEqualToString:@"POST"]) {
		
		
		
		
		
		if ([URL.path isEqualToString:@"/__/directory/list"]) {
			
			NSDictionary *args = [self getPOSTRequestArguments];
			return [[[HTTPDataResponse alloc] initWithData:[self JSONForDirectoryContentsAtPath:[args valueForKey:@"relativePath"]]] autorelease];
			
			
		} else if ([URL.path isEqualToString:@"/__/directory/create"]) {
		
			NSDictionary *args = [self getPOSTRequestArguments];
			return [[[HTTPDataResponse alloc] initWithData:[[self createDirectory:[args valueForKey:@"name"] atPath:[args valueForKey:@"path"]] dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
			
		 
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


			// Notification
			//[[NSNotificationCenter defaultCenter] postNotificationName:@"newItem" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:relativePath, @"relativePath",filename, @"name", nil]];

			// Cleanup...
			[multipartParser release];
			requestIsMultipart = NO;
			
			return [[[HTTPDataResponse alloc] initWithData:[@"true" dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
		}
	}
	
	return nil; // 404






	// We need to seperate action responses from server responses...
	
	
//	if ([method isEqualToString:@"GET"]) {
//		// GET METHODS
//		
//		
//		
//		
//			
//
//
//			NSString *path = url.path;
//			if ([url.path isEqualToString:@"/"]) {
//				path = @"index.html";
//			}
//			path = [[server.documentRoot.path stringByAppendingPathComponent:@"wwwroot"] stringByAppendingPathComponent:path];
//			return [[[HTTPFileResponse alloc] initWithFilePath:path] autorelease];
//		
//		
//		
//	} else if ([method isEqualToString:@"POST"]) {
//		// POST METHODS
//		
//		if ([url.path isEqualToString:@"/__/directory/create"]) {
//
//			// Create a directory
//			NSDictionary *vars = [self variablesForPostRequest];
//			return [[[HTTPDataResponse alloc] initWithData:[[self createDirectory:[vars valueForKey:@"directoryName"] atPath:[vars valueForKey:@"relativePath"]] dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
//
//		} else if ([url.path isEqualToString:@"/__/directory/open"]) {
//
//			// Open a directory
//			NSDictionary *vars = [self variablesForPostRequest];
//			return [[[HTTPDataResponse alloc] initWithData:[self JSONForDirectoryContentsAtPath:[vars valueForKey:@"relativePath"]]] autorelease];
//			
//		} else if (requestIsMultipart) {
//		
//			// check to see if the fileupload was correctly done?
//			if ([[[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"filename"] length] <= 0) {
//				// Bad upload, cleanup.
//				[multipartParser release];
//				requestIsMultipart = NO;
//				return [[[HTTPDataResponse alloc] initWithData:[@"0" dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
//			}
//			// File upload is complete, move the file to it's proper directory and release all used resources.
//			[self fileUploadComplete];
//			return [[[HTTPDataResponse alloc] initWithData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
//		}
//		
//	}
//	
//	return nil;
}












# pragma mark -
# pragma mark Utility classes


- (NSMutableDictionary *)getPOSTRequestArguments;
{
	CFDataRef postData = CFHTTPMessageCopyBody(request);
	NSString *postBody = [[NSString alloc] initWithData:(NSData *)postData encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *variables= [NSMutableDictionary dictionary];
	for (NSString *postBodyPart in [postBody componentsSeparatedByString:@"&"]) {
		NSArray *keyValue = [postBodyPart componentsSeparatedByString:@"="];
		[variables setValue:[[[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "] forKey:[keyValue objectAtIndex:0]];
	}

	CFRelease(postData);
	[postBody release];
	
	return variables;
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
	
	// Folder does exist?
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











- (void)fileUploadComplete
{

}





@end


