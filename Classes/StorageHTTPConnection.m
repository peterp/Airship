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

#import "time.h"


@implementation StorageHTTPConnection



- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {

	// Searching for multipart/form-data
	NSString *contentType = NSMakeCollectable(CFHTTPMessageCopyHeaderFieldValue(request, CFSTR("Content-Type")));
	if ([contentType hasPrefix:@"multipart/form-data;"]) {
	
		
		
		requestIsMultipart = YES;
		NSString *boundary = [contentType substringFromIndex:[contentType rangeOfString:@"boundary="].location + [@"boundary=" length]];
		
		NSLog(@"boundary: %@", boundary);
		
		start = clock();
		
		multipartParser = [[AFMultipartParser alloc] initWithBoundary:boundary];
	}
	[contentType release];
	
	return YES;
}


- (void)processDataChunk:(NSData *)postDataChunk {
	if (requestIsMultipart) {
		// This is a file upload, move the file to the location
		// specified...
		[multipartParser parseMultipartChunk:postDataChunk];
	}
}


- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)uri {

	// NSURL is a bit easier to extract information out of than a string.
	NSURL *url = [NSURL URLWithString:uri];
	
	
	if ([method isEqualToString:@"GET"]) {
		
		if ([[url query] isEqualToString:@"format=json"]) {

			// requesting a JSON response of the contents of this path...
			return [[[HTTPDataResponse alloc] 
				initWithData:[self dataForContentsOfDirectory:url.path]] 
				autorelease];
		}
		
		// Default response, return file at request path
		return [[[HTTPFileResponse alloc] initWithFilePath:[self absolutePathForURL:url.path]] autorelease];
			
			
			
		
		
	} else if ([method isEqualToString:@"POST"]) {
		
		if (requestIsMultipart) {
			
			NSString *tmpFilePath = [[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"tmpFilePath"];
			NSString *filename = [[multipartParser.parts valueForKey:@"Filedata"] valueForKey:@"filename"];
			NSString *relativePath = [[multipartParser.parts valueForKey:@"relativePath"] valueForKey:@"value"];
			
			NSString *path = [[self absolutePathForURL:relativePath] stringByAppendingPathComponent:filename];
			NSError *error;
			[[NSFileManager defaultManager] moveItemAtPath:tmpFilePath toPath:path error:&error];
			
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"newFileUploaded" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
				relativePath, @"relativePath",
				path, @"absolutePath",
				filename, @"name",
				nil
				]];

			[multipartParser release];
			
			int time_taken_millis = (int)((clock()-start)*1E3/CLOCKS_PER_SEC);
			NSLog(@"~~~~~  %i", time_taken_millis);
		}
	}
	
	// 404 response
	return nil;
}








/** 
 * This method returns JSON encoded bytes of all the contents of a directory, 
 * The JSON object includes filename, date, size, type, etc...
 */
- (NSData *)dataForContentsOfDirectory:(NSString *)path {

	path = [self absolutePathForURL:path];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *contents = [fileManager subpathsAtPath:path];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyyy, HH:mm"];
	
	NSMutableArray *items = [NSMutableArray array];
	for (NSString *name in contents) {
		// Grab the attributes for this file
		NSDictionary *attrs = [fileManager 
			fileAttributesAtPath:[path stringByAppendingPathComponent:name] 
			traverseLink:NO];
		
			[items addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
				name, @"name",
				[dateFormat stringFromDate:
					[attrs objectForKey:NSFileModificationDate]], @"date",
				[NSString stringWithFormat:@"%1.0f", 
					[[attrs objectForKey:NSFileSize] floatValue] / 1024], @"size",
				[[attrs objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"] ? 
					@"folder" : @"file", @"type",
				nil
				]
			];
	}
	
	[dateFormat release];
	return [[[CJSONSerializer serializer] serializeObject:items] 
		dataUsingEncoding:NSUTF8StringEncoding];
}


/***
 * Converts a URL path to an absolute filesystem path.
 */
- (NSString *)absolutePathForURL:(NSString *)url 
{
	// DirectoryIndex is index.html.
	if ([url isEqualToString:@"/"]) {
		url = @"index.html";
	}
	
	return [[server.documentRoot.path stringByAppendingPathComponent:@"wwwroot"] stringByAppendingPathComponent:url];
}









//
//
//- (NSMutableDictionary *)getQueryVariables:(NSString *)query escapePercentages:(BOOL)escape
//{
//	NSString *body = [[NSString alloc] initWithData:[(NSData *)CFHTTPMessageCopyBody(request) autorelease] encoding:NSUTF8StringEncoding];
//	NSArray *bodyComponents = [body componentsSeparatedByString:@"&"];
//	[body release];
//	
//	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:1];
//	for (NSString *variable in bodyComponents) {
//		
//		NSArray *variableComponents = [variable componentsSeparatedByString:@"="];
//
//		NSString *key = [variableComponents objectAtIndex:0];
//		NSString *val = [[variableComponents objectAtIndex:1] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
//		if (escape) {
//			key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//			val = [val stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//		}
//		
//		[variables setObject:val forKey:key];
//	}
//	return variables;
//}
//
//- (NSObject *)responseWithString:(NSString *)responseString
//{
//	return [[[HTTPDataResponse alloc] initWithData:[[NSString stringWithString:responseString] dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
//}






@end


