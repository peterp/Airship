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

#import "AFMultipartParser.h";

@implementation StorageHTTPConnection





- (void)prepareForBodyWithSize:(UInt64)contentLength
{
	NSLog(@"prepareForBodyWithSize:%d",contentLength);
	// Override me to allocate buffers, file handles, etc.
}




- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)uri;
{
	NSLog(@"httpResponseForMethod");
	NSURL *url = [NSURL URLWithString:uri];
	
	NSLog(@"%@", url.path);
	
	if ([method isEqualToString:@"GET"]) { // GET requests
		
		if ([url.path hasPrefix:@"/__/Storage"]) {
			
			NSLog(@"trying to get files");
			
			// strip __;
			NSData *JSON = [[self getDirectoryItems:[url.path substringFromIndex:3]] dataUsingEncoding:NSUTF8StringEncoding];
			return [[[HTTPDataResponse alloc] initWithData:JSON] autorelease];
			
		} else { // default response
			
			NSString *itemPath = [self getRelativePath:url.path];
			if ([[NSFileManager defaultManager] fileExistsAtPath:itemPath]) {
				return [[[HTTPFileResponse alloc] initWithFilePath:itemPath] autorelease];
			}
			
		}
		
	} else if ([method isEqualToString:@"POST"]) { // POST requests
		
		// create a new folder
		if ([url.path isEqualToString:@"/__/item/create"]) {
			
			// get query variables...
			NSMutableDictionary *vars = [self getQueryVariables:nil escapePercentages:YES];
			// check to see if this folder already exists.
			NSString *itemPath = [self getRelativePath:[NSString stringWithFormat:@"%@%@", [vars objectForKey:@"path"], [vars objectForKey:@"name"]]];
			if ([[NSFileManager defaultManager] fileExistsAtPath:itemPath]) {
				return [self responseWithString:@"0"];
			} else {
				if ([[NSFileManager defaultManager] createDirectoryAtPath:itemPath attributes:nil]) {
					return [self responseWithString:@"1"];
				} else {
					return [self responseWithString:@"-1"];
				}
			}
		} else if (requestIsMultipart) {
			// clean up file upload
			requestIsMultipart = NO;
			
			[multipartParser release];
		}
	}
	
	// 404
	return nil;
}









- (NSMutableDictionary *)getQueryVariables:(NSString *)query escapePercentages:(BOOL)escape
{
	NSString *body = [[NSString alloc] initWithData:[(NSData *)CFHTTPMessageCopyBody(request) autorelease] encoding:NSUTF8StringEncoding];
	NSArray *bodyComponents = [body componentsSeparatedByString:@"&"];
	[body release];
	
	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:1];
	for (NSString *variable in bodyComponents) {
		
		NSArray *variableComponents = [variable componentsSeparatedByString:@"="];

		NSString *key = [variableComponents objectAtIndex:0];
		NSString *val = [[variableComponents objectAtIndex:1] stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
		if (escape) {
			key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			val = [val stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}
		
		[variables setObject:val forKey:key];
	}
	return variables;
}

- (NSObject *)responseWithString:(NSString *)responseString
{
	return [[[HTTPDataResponse alloc] initWithData:[[NSString stringWithString:responseString] dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
}






- (NSString *)getRelativePath:(NSString *)path 
{
	if ([path isEqualToString:@"/"]) {
		path = @"/index.html";
	}
	return [NSString stringWithFormat:@"%@%@", [[server documentRoot] path], path];
}

- (NSString *)getDirectoryItems:(NSString *)path
{
	
	NSLog(@"%@", path);
	path = [self getRelativePath:path];
	NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:path];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyyy, HH:mm"];
	
	NSMutableArray *items = [NSMutableArray array];
	for (NSString *name in directoryContents) {
		NSDictionary *attr = [[NSFileManager defaultManager] fileAttributesAtPath:[path stringByAppendingPathComponent:name] traverseLink:NO];
		
		[items addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
															  name, 
															  [dateFormat stringFromDate:[attr objectForKey:NSFileModificationDate]],
															  [NSString stringWithFormat:@"%1.0f", [[attr objectForKey:NSFileSize] floatValue] / 1024],
															  [[attr objectForKey:NSFileType] isEqualToString: @"NSFileTypeDirectory"] ? @"folder" : @"file",
															  nil] 
													 forKeys:[NSArray arrayWithObjects:@"name", @"date", @"size", @"type", nil]]];
	}
	[dateFormat release];
	return [[CJSONSerializer serializer] serializeObject:items];
}







//- (void)processDataChunk:(NSData *)postDataChunk
//{
//	NSLog(@"processDataChunk");
//	
//	if (fileUpload) {
//		// user is uploading a file, get the "header" of the post which contains the filename
//		if (!fileUploadHeader) {
//			// 0x0A0D == CR LF;
//			UInt16 separatorBytes = 0x0A0D;
//			NSData *separatorData = [NSData dataWithBytes:&separatorBytes length:2];
//			int l = [separatorData length];
//			
//			// search postDataChunk for a CR LF.
//			for (int i = 0; i < [postDataChunk length] - l; i++) 
//			{
//				NSRange searchRange = {i, l};
//				if ([[postDataChunk subdataWithRange:searchRange] isEqualToData:separatorData])
//				{
//					// An entire line from postDataChunk
//					NSRange newDataRange = {fileUploadDataStartIndex, i - fileUploadDataStartIndex};
//					fileUploadDataStartIndex = i + l;
//					i += l - 1;
//					NSData *newData = [postDataChunk subdataWithRange:newDataRange];
//					// the files actual bytes start after an empty line
//					if ([newData length]) {
//						[multipartData addObject:newData];
//					} else {
//						// we come here once, now that we have the header we can create a new file
//						// the first condition will evaluate to true from now...
//						fileUploadHeader = YES;
//						
//						// 0 = ---------boundary
//						// 1 = Content-Disposition: form-data; name="new_file"; filename="uploaded_file.pdf"
//						NSString *postInformation = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
//						NSArray *postBits = [postInformation componentsSeparatedByString:@"; filename="];
//						postBits = [[postBits lastObject] componentsSeparatedByString:@"\""];
//						postBits = [[postBits objectAtIndex:1] componentsSeparatedByString:@"\\"];
//						
//						// create "storage" folder
//						NSString *filePath = [[[server documentRoot] path] stringByAppendingPathComponent:@"Storage"];
//						[[NSFileManager defaultManager] createDirectoryAtPath:filePath attributes:nil];
//						
//						// create filename with range.
//						filePath = [filePath stringByAppendingPathComponent:[postBits lastObject]];
//						NSRange fileRange = {fileUploadDataStartIndex, [postDataChunk length] - fileUploadDataStartIndex};
//						
//						// create the file
//						[[NSFileManager defaultManager] createFileAtPath:filePath contents:[postDataChunk subdataWithRange:fileRange] attributes:nil];
//						// do we really need to reatin this?
//						//NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:filePath] retain];
//						NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
//						
//						if (file)
//						{
//							[file seekToEndOfFile];
//							[multipartData addObject:file];
//						}
//						[postInformation release];
//						break;
//					}
//				}
//			}
//		} else {
//			// save the rest of the contents of the file.
//			[(NSFileHandle*)[multipartData lastObject] writeData:postDataChunk];
//		}
//		
//	} else {
//		BOOL appendSuccess = CFHTTPMessageAppendBytes(request, [postDataChunk bytes], [postDataChunk length]);
//		if (!appendSuccess) { 
//			NSLog(@"Could not append data chunk to request's body.");
//		}
//	}
//}








- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
	/*
	By default we support every method. The only reason why we've implemented this 
	function is so that we can reset some default when uploading a file.
	
	There doesn't appear to be a better place to put it.
	*/
	
	
	
	//Eg.: multipart/form-data; boundary=---------------------------178448449274243042114807987
	NSString *contentType = NSMakeCollectable(CFHTTPMessageCopyHeaderFieldValue(request, CFSTR("Content-Type")));
	if ([contentType hasPrefix:@"multipart/form-data;"]) {
	
		requestIsMultipart = TRUE;
		// find the range of the boundary= string
		NSString *boundary = [contentType substringFromIndex:
			[contentType rangeOfString:@"boundary="].location + [@"boundary=" length]];
			
		
		multipartParser = [[AFMultipartParser alloc] initWithBoundary:boundary];
	}
	[contentType release];
	
	
	
	return YES;
}









- (void)processDataChunk:(NSData *)postDataChunk {
	/*
	This method processes 32 kilobytes (32768 bytes), or less, of "chunked 
	data" at a time.
	
	We need to decode the multipart/mime-data. In order to do that we need to 
	understand the format of multipart data.
	*/

	if (requestIsMultipart) {
		[multipartParser parseMultipartChunk:postDataChunk];

//		[multipartRequest parseChunk:postDataChunk];
	}
}
@end


