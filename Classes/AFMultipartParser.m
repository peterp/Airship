//
//  AFMultipartParser.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AFMultipartParser.h"


@implementation AFMultipartParser



@synthesize crlf;
@synthesize postDataChunk;
@synthesize	nextBoundary;
@synthesize	lastBoundary;
@synthesize parts;
@synthesize fileHandler;
			

/**
 * The boundary is obtained from the headers of the HTTP request. This method 
 * creates the next/ last part boundaries.
 **/
- (id)initWithBoundary:(NSString *)boundary {

	if ([super init]) {
	
		// Create the next and last part boundaries as bytes, it's easier to 
		// match against the postDataChunk bytes.
		self.nextBoundary = [[NSString stringWithFormat:@"--%@", boundary] 
			dataUsingEncoding:NSUTF8StringEncoding];
		self.lastBoundary = [[NSString stringWithFormat:@"--%@--", boundary] 
			dataUsingEncoding:NSUTF8StringEncoding];
			
		// These index are used to mark the start of data that we are going to 
		// slice.
		lineStartIndex = 0;
		bodyStartIndex = -1;
		
		// this dictionary will hold all the information about the various parts.
		self.parts = [NSMutableDictionary dictionary];
		
		// when parsing headers we'll be searching them line-by-line, we create
		// the \r\n here instead of having to tear it up and break it down on
		// each loop.
		UInt16 crlfBytes = 0x0A0D;
		self.crlf = [[NSData alloc] initWithBytes:&crlfBytes length:2];
	}
	return self;
	
}

- (void) dealloc
{
	self.nextBoundary  = nil;
	self.lastBoundary  = nil;
	self.postDataChunk = nil;
	
	self.parts = nil;
	self.crlf = nil;
	self.fileHandler = nil;

	[super dealloc];
}


/**
 * This method searches the postDataChunk's byte-for-byte... Skipping over some
 * sections when it can.
 * The run down of how the class operates is as such:
 * - search for boundary
 * - search for headers/ parse headers
 * - search for end of headers/ mark location of data start
 * - search for boundary (save data)
 *
 * Because it's dealing with chunked data it needs to make provision for saving
 * data and state over many calls.
 */
- (void)parseMultipartChunk:(NSData *)data {

	/**
	The "data" needs to be an instance variable because we're going to be 
	slicing bits out of it with other methods.
	**/

	// I'm not actually sure if setting it to nil is neccessary.
	self.postDataChunk = nil;
	self.postDataChunk = data;
	
	NSLog(@"---------- new chunk ----------");
	
	// Start looping through the bytes of data.
	for (int i = 0; i < postDataChunk.length; i++) {
	
		// Enough bytes left to match the lastBoundary?
		if (postDataChunk.length >= i + lastBoundary.length) {
			if ([[postDataChunk subdataWithRange:
				NSMakeRange(i, lastBoundary.length)] isEqualToData:lastBoundary]) {

				// Since this is the last boundary that pretty much means that
				// we're done.
				[self bodyForPostDataChunkWithRange:
					NSMakeRange(bodyStartIndex, (i - bodyStartIndex)) 
					forPart:[parts lastObject]];
				NSLog(@". part END (last)");
				
				// Reset the slice range to defaults.
				bodyStartIndex = -1;
				break;
			}
		}
	
	
		// Enough bytes left to match the nextBoundary?
		if (postDataChunk.length >= i + nextBoundary.length) {
			if ([[postDataChunk subdataWithRange:
				NSMakeRange(i, nextBoundary.length)] isEqualToData:nextBoundary]) {
				
				
				// If bodyStartIndex >= 0 it means that we're tracking a part, so
				// save it.
				if (bodyStartIndex >= 0) {
					NSLog(@"... data SAVE (next)");
					
					[self bodyForPostDataChunkWithRange:
						NSMakeRange(bodyStartIndex, (i - bodyStartIndex))
						forPart:[parts lastObject]];
					
					NSLog(@". part END (next)");
				}
				
				NSLog(@". part START (next)");
				NSLog(@".. header START");
				
				// Reset the slice range, we're looking for headers now.
				bodyStartIndex = -1;

				// Shift the index and line slice range ahead to skip this
				// boundary.
				i += nextBoundary.length + crlf.length;
				lineStartIndex = i;
			}
		}
		
		/**
		 * If we're not searching for any part's slice range then we're looking
		 * for headers. The end of headers indicate the start of a parts body.
		 */
		if (bodyStartIndex < 0 && postDataChunk.length >= i + crlf.length) {
		
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, crlf.length)] isEqualToData:crlf]) {
				
				// Extract a single line of bytes.
				NSData *lineData = [postDataChunk subdataWithRange:
					NSMakeRange(lineStartIndex, i - lineStartIndex)];
				
				// Shift hte index and line slice range ahead so that we don't 
				// search over the bytes we've just cut.
				lineStartIndex = i + crlf.length;
				i += (crlf.length - 1); 
				
				
				// If this line is empty it indicates the end of the header
				// and the start of the new body.
				if (lineData.length == 0) {
					NSLog(@".. header STOP");
					bodyStartIndex = lineStartIndex;
				} else {
				
					NSLog(@"... header PARSE");
					
					// Header bytes into header string!
					NSString *line = [self stringFromData:lineData];
					
					// The very first line of the header contains the field's name
					// as well as the filename.
					if ([line rangeOfString:@"Content-Disposition: form-data;"].location != NSNotFound) {
						
						// Extract the juicy information and create a new mutable
						// array... 
						NSArray *bits = [line componentsSeparatedByString:@"\""];
						
						// Is this a file upload part?
						if ([bits count] == 5) {
							[parts setValue:[NSMutableDictionary 
									dictionaryWithObject:[bits objectAtIndex:3] 
									forKey:@"filename"] 
								forKey:[bits objectAtIndex:1]];
								
							NSLog(@"%@", [parts ]);
						} else {
							[parts setValue:[NSMutableDictionary dictionary] 
								forKey:[bits objectAtIndex:1]];
						}
					}
					
					[line release];
				}
			}
		}
	}
	
	/**
	 * Oh no! We haven't found the end of this parts body. It probably means
	 * that this is spanning over many chunked bytes.
	 */
	if (bodyStartIndex >= 0) {
	
		NSLog(@"... data SAVE (chunk)");
		[self bodyForPostDataChunkWithRange:
			NSMakeRange(bodyStartIndex, (postDataChunk.length - bodyStartIndex))
				forPart:[parts lastObject]];
				
		
		// Since we're still searching for the rest of this parts body set the
		// slice range to the very first byte of the next chunk.
		bodyStartIndex = 0;
	}
}




- (NSString *)stringFromData:(NSData *)data {
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
}


/**
 * This method saves the data/ chunked or not for a part. It's always the last
 * part, so I don't know why I really bother passing it through. Anyway.
 */
- (void)bodyForPostDataChunkWithRange:(NSRange)range forPart:(NSMutableDictionary *)part {


	NSString *filename = [part valueForKey:@"filename"];
	if (filename) {
	
		// Check to see if we've created a temporary file to store this damn
		// thing.
		
		NSString *tmpFilePath = [part valueForKey:@"tmpFilePath"];
		if (!tmpFilePath) {
			// Create a temporary file for this part.
			tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
				[NSString stringWithFormat:@"%.0f_%@", [NSDate timeIntervalSinceReferenceDate] * 100, filename]];
			[part setObject:tmpFilePath forKey:@"tmpFilePath"];
			
			[[NSFileManager defaultManager] createFileAtPath:tmpFilePath 
				contents:nil attributes:nil];
				
			// create a file handle as welll.
			self.fileHandler = nil;
			self.fileHandler = [NSFileHandle fileHandleForWritingAtPath:tmpFilePath];
		}
		NSLog(@"..... path: %@", tmpFilePath);
		
		
		[fileHandler seekToEndOfFile];
		[fileHandler writeData:[postDataChunk subdataWithRange:range]];
	} else {
		// extract and place this value in to the "part" dictionary.

		NSString *value = [self stringFromData:[postDataChunk subdataWithRange:range]];
		[part setValue:value forKey:@"value"];
		[value release];
	}
};



@end
