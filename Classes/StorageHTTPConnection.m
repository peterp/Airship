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

#import "DirectoryItem.h"

#import "time.h"


@implementation StorageHTTPConnection



- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)uri 
{
	
	NSURL *url = [NSURL URLWithString:uri];
	
	if ([method isEqualToString:@"GET"]) {
		// GET METHODS
	
		if ([[url query] isEqualToString:@"format=json"]) {
			// JSON 
			return [[[HTTPDataResponse alloc] initWithData:[self directoryContentsAtURL:url.path]] autorelease];
			
			
		} else {
			// Default Response
			NSString *path = url.path;
			if ([url.path isEqualToString:@"/"]) {
				path = @"index.html";
			}
			path = [[server.documentRoot.path stringByAppendingPathComponent:@"wwwroot"] stringByAppendingPathComponent:path];
			return [[[HTTPFileResponse alloc] initWithFilePath:path] autorelease];
		}
		
		
		
	} else if ([method isEqualToString:@"POST"]) {
		// POST METHODS
		
		if ([url.path isEqualToString:@"/__/directory/create"]) {
		
			// Use the data within to createa a directory! Margle!s
			NSDictionary *variables = [self variablesForPostRequest];
			
			NSLog(@"%@", variables);
		
		
		} else if (requestIsMultipart) {
			
			
		
			NSString *fromPath = [[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"tmpFilePath"];
			NSString *filename = [[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"filename"];
			NSString *relativePath = [[multipartParser.parts valueForKey:@"relativePath"] valueForKey:@"value"];
			NSString *destPath = [[server.documentRoot.path stringByAppendingPathComponent:relativePath] stringByAppendingPathComponent:filename];
			
			NSError *error;
			[[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:destPath error:&error];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"newItem" object:nil userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					relativePath, @"relativePath",
					destPath, @"absolutePath",
					filename, @"name",
					nil
				]
			];

			[multipartParser release];
		}
	}
	
	return nil;
}












# pragma mark -
# pragma mark Utility classes

- (NSData *)directoryContentsAtURL:(NSString *)url
{

	NSString *path = [server.documentRoot.path stringByAppendingPathComponent:url];
	
	NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:path];
	NSMutableArray *directoryItems = [NSMutableArray array];
	for (NSString *name in [directoryContents sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
		if (![name isEqualToString:@".DS_Store"]) {

			// Create DirectoryItem
			DirectoryItem *item = [DirectoryItem initWithName:name atPath:path];
			[directoryItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", item.type, @"type", item.date, @"date", nil]];
			[item release];
		}
	}

	return [[[CJSONSerializer serializer] serializeObject:directoryItems] dataUsingEncoding:NSUTF8StringEncoding];
}


- (NSMutableDictionary *)variablesForPostRequest
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
# pragma mark Multipart/form-data POST requests

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path 
{
	// Looking for multipart uploads
	NSString *contentType = NSMakeCollectable(CFHTTPMessageCopyHeaderFieldValue(request, CFSTR("Content-Type")));
	if ([contentType hasPrefix:@"multipart/form-data;"]) {
	
		requestIsMultipart = YES;
		NSString *boundary = [contentType substringFromIndex:[contentType rangeOfString:@"boundary="].location + [@"boundary=" length]];
		multipartParser = [[AFMultipartParser alloc] initWithBoundary:boundary];
	
		//start = clock();
	}
	[contentType release];

	return YES;
}


- (void)processDataChunk:(NSData *)postDataChunk 
{
	if (requestIsMultipart) {
		[multipartParser parseMultipartChunk:postDataChunk];
	} else {
		// Append post body to request object.
		CFHTTPMessageAppendBytes(request, [postDataChunk bytes], [postDataChunk length]);
	}
}
@end


