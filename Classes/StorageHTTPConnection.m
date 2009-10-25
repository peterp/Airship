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

#import "StorageItem.h"



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
			
			
		} else if (requestIsMultipart) {

			NSString *filename = [[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"filename"];
			NSString *relativePath = [[multipartParser.parts valueForKey:@"relativePath"] valueForKey:@"value"];
			NSError *error;
			[[NSFileManager defaultManager] moveItemAtPath:[[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"tmpFilePath"] toPath:[[server.documentRoot.path stringByAppendingPathComponent:relativePath] stringByAppendingPathComponent:filename] error:&error];
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
# pragma mark Requestions actions with response objects


- (NSString *)createDirectory:(NSString *)name atPath:(NSString *)path
{
	NSString *absPath = [server.documentRoot.path stringByAppendingPathComponent:path];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir;
	
	
	// don't allow empty file names
	if (name.length <= 0) {
		return @"0;You have to give your folder a name.";
	}
	
	// does the parent directory still exist?
	if ([fileManager fileExistsAtPath:absPath isDirectory:&isDir] == NO && isDir == NO) {
		return	[NSString stringWithFormat:@"0;\"%@\" could not be created, because its parent folder doesn't exist. (Anymore?)", name];
	}
	
	// cannot create hidden folders.
	if ([name hasPrefix:@"."]) {
		return @"0;You cannot use a name that begins with a \".,\" because those names are reserved for the system.";
	}

	// Does a folder of this name already exist?
	absPath = [absPath stringByAppendingPathComponent:name];
	if ([fileManager fileExistsAtPath:absPath]) {
		return [NSString stringWithFormat:@"-3;The name \"%@\" is already taken. Please choose a different name.", name];
	}
	
	// Create the directory
	if ([fileManager createDirectoryAtPath:absPath attributes:nil]) {
	
		[[NSNotificationCenter defaultCenter] postNotificationName:@"newItem" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:path, @"relativePath", name, @"name", nil]];
		return [NSString stringWithFormat:@"1;%@", name];
	} else {
		return [NSString stringWithFormat:@"0;The folder \"%@\" could not be created."];
	}
	
	// return a data response that the webserver can use directly.
	return @"0;";
}


- (NSData *)JSONForDirectoryContentsAtPath:(NSString *)path;
{
	// DataSource
	NSArray *directoryContents = [[[NSFileManager defaultManager] directoryContentsAtPath:[server.documentRoot.path stringByAppendingPathComponent:path]] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSMutableArray *storageItemList = [NSMutableArray arrayWithCapacity:[directoryContents count]];
	for (NSString *itemName in directoryContents) {
		StorageItem *storageItem = [[StorageItem alloc] initWithName:itemName atAbsolutePath:[server.documentRoot.path stringByAppendingPathComponent:path]];
		[storageItemList addObject:[NSDictionary dictionaryWithObjectsAndKeys:storageItem.name, @"name", storageItem.kind, @"kind", storageItem.date, @"date", storageItem.size, @"size", nil]];
		
		[storageItem release];
	}
	directoryContents = nil;
	return [[[CJSONSerializer serializer] serializeObject:storageItemList] dataUsingEncoding:NSUTF8StringEncoding];
}











- (void)fileUploadComplete
{

}





@end


