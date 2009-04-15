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


@implementation StorageHTTPConnection


- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path;
{
	if ([method isEqualToString:@"POST"]) {
		NSString *contentType = NSMakeCollectable(CFHTTPMessageCopyHeaderFieldValue(request, CFSTR("Content-Type")));
		if ([contentType hasPrefix:@"multipart/form-data;"]) {
			
			fileUpload = YES;
			fileUploadHeader = NO;
			fileUploadDataStartIndex = 0;
			multipartData = [[NSMutableArray alloc] init];
			
		} else {
			fileUpload = NO;
		}
		[contentType release];
	}
	
	return YES;
}


- (void)processDataChunk:(NSData *)postDataChunk
{
	
	if (fileUpload) {
		// user is uploading a file, get the "header" of the post which contains the filename
		if (!fileUploadHeader) {
			// 0x0A0D == CR LF;
			UInt16 separatorBytes = 0x0A0D;
			NSData *separatorData = [NSData dataWithBytes:&separatorBytes length:2];
			int l = [separatorData length];
			
			// search postDataChunk for a CR LF.
			for (int i = 0; i < [postDataChunk length] - l; i++) 
			{
				NSRange searchRange = {i, l};
				if ([[postDataChunk subdataWithRange:searchRange] isEqualToData:separatorData])
				{
					// An entire line from postDataChunk
					NSRange newDataRange = {fileUploadDataStartIndex, i - fileUploadDataStartIndex};
					fileUploadDataStartIndex = i + l;
					i += l - 1;
					NSData *newData = [postDataChunk subdataWithRange:newDataRange];
					// the files actual bytes start after an empty line
					if ([newData length]) {
						[multipartData addObject:newData];
					} else {
						// we come here once, now that we have the header we can create a new file
						// the first condition will evaluate to true from now...
						fileUploadHeader = YES;
						
						// 0 = ---------boundary
						// 1 = Content-Disposition: form-data; name="new_file"; filename="uploaded_file.pdf"
						NSString *postInformation = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
						NSArray *postBits = [postInformation componentsSeparatedByString:@"; filename="];
						postBits = [[postBits lastObject] componentsSeparatedByString:@"\""];
						postBits = [[postBits objectAtIndex:1] componentsSeparatedByString:@"\\"];
						
						// create "storage" folder
						NSString *filePath = [[[server documentRoot] path] stringByAppendingPathComponent:@"storage"];
						[[NSFileManager defaultManager] createDirectoryAtPath:filePath attributes:nil];
						
						// create filename with range.
						filePath = [filePath stringByAppendingPathComponent:[postBits lastObject]];
						NSRange fileRange = {fileUploadDataStartIndex, [postDataChunk length] - fileUploadDataStartIndex};
						
						// create the file
						[[NSFileManager defaultManager] createFileAtPath:filePath contents:[postDataChunk subdataWithRange:fileRange] attributes:nil];
						// do we really need to reatin this?
						//NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:filePath] retain];
						NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
						
						if (file)
						{
							[file seekToEndOfFile];
							[multipartData addObject:file];
						}
						[postInformation release];
						break;
					}
				}
			}
		} else {
			// save the rest of the contents of the file.
			[(NSFileHandle*)[multipartData lastObject] writeData:postDataChunk];
		}
		
	} else {
		BOOL appendSuccess = CFHTTPMessageAppendBytes(request, [postDataChunk bytes], [postDataChunk length]);
		if (!appendSuccess) { 
			NSLog(@"Could not append data chunk to request's body.");
		}
	}
}







- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)uri;
{
	NSURL *url = [NSURL URLWithString:uri];
	
	if ([method isEqualToString:@"GET"]) { // GET requests
		
		if ([url.path hasPrefix:@"/storage"]) {
			
			NSData *JSON = [[self getDirectoryItems:url.path] dataUsingEncoding:NSUTF8StringEncoding];
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
			NSMutableDictionary *vars = [self getQueryVariables:nil escapePercentages:NO];
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
		} else if (fileUpload) {
			// clean up file upload
			fileUpload = NO;
			fileUploadHeader = NO;
			fileUploadDataStartIndex = 0;
			[multipartData release];
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











@end
