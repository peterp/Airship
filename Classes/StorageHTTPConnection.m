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
			
			// Grab variables, check that we've received input.
			NSDictionary *vars = [self variablesForPostRequest];
			return [[[HTTPDataResponse alloc] initWithData:[self createDirectory:[vars valueForKey:@"directoryName"] atPath:[vars valueForKey:@"relativePath"]]] autorelease];

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
					filename, @"name",
					nil
				]
			];
			
			[multipartParser release];
			requestIsMultipart = NO;
		}
	}
	
	return nil;
}












# pragma mark -
# pragma mark Utility classes


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
# pragma mark Requestions actions with response objects


- (NSData *)createDirectory:(NSString *)name atPath:(NSString *)path
{
	NSString *response = @"0;";
	NSString *absPath = [server.documentRoot.path stringByAppendingPathComponent:path];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir;

	if ([fileManager fileExistsAtPath:absPath isDirectory:&isDir] && isDir) {
		if ([name hasPrefix:@"."]) {
			response = @"-2;You cannot use a name that begins with a \".,\" because those names are reserved for the system.";
		} else {
			absPath = [absPath stringByAppendingPathComponent:name];
			if ([fileManager fileExistsAtPath:absPath]) {
				response = [NSString stringWithFormat:@"-3;The name \"%@\" is already taken. Please choose a different name.", name];
			} else {
				if ([fileManager createDirectoryAtPath:absPath attributes:nil]) {
					response = @"1;";
					[[NSNotificationCenter defaultCenter] postNotificationName:@"newItem" object:nil userInfo:
						[NSDictionary dictionaryWithObjectsAndKeys:
							path, @"relativePath",
							name, @"name",
							nil
						]
					];
				} else {
					// I have no idea why it would fail here?
					response = [NSString stringWithFormat:@"-3;\"%@\" could not be created."];
				}
			}
		}
	} else {
		// base path does not exist, return an error
		response = [NSString stringWithFormat:@"-1;\"%@\" could not be created, because it's parent directory doesn't exist. (Anymore?)", name];
	}
	
	// return a data response that the webserver can use directly.
	return [response dataUsingEncoding:NSUTF8StringEncoding];
}


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
		}
	}

	return [[[CJSONSerializer serializer] serializeObject:directoryItems] dataUsingEncoding:NSUTF8StringEncoding];
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


