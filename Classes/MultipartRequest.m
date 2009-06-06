//
//  MultipartRequest.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MultipartRequest.h"


@implementation MultipartRequest

@synthesize nextPartBoundary;
@synthesize lastPartBoundary;

@synthesize boundary;
@synthesize rawPartHeaders;
@synthesize parts;

- (id)initWithDefaults {

	if(self = [super init])
	{

		// end of line.
		UInt16 CRLFBytes = 0x0A0D;
		CRLF = [[NSData alloc] initWithBytes:&CRLFBytes length:2];
		CRLFLen = [CRLF length];
		
		
		
		
		// start index of each new line.
		lineStartIndex = 0;
		
		self.rawPartHeaders = [NSMutableArray array];
		self.parts = [NSMutableArray array];
		
		currentPartHasHeader = FALSE;
		// currentPartHasBody
		
	}
	return self;
}



- (void) dealloc {
	
//	NSLog(@"%@", self.rawPartHeaders);
//	NSLog(@"%@", self.parts);
	

	[self.boundary release];
	
	[self.nextPartBoundary release];
	[self.lastPartBoundary release];
	
	[self.rawPartHeaders release];
	[self.parts release];
	
	
	[CRLF release];
	[super dealloc];
}

- (void)parseMultipartChunk:(NSData *)postDataChunk {

	NSLog(@"-------- new chunk --------");

	// loop over the contents of postDataChunk byte-for-byte
	for (int i = 0; i < [postDataChunk length] - CRLFLen; i++) {
	
		if (currentPartHasHeader == FALSE) {
			// search for end-of-line bytes, and save the header
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, CRLFLen)] isEqualToData:CRLF]) {
			
				// a line of bytes
				NSData *line = [postDataChunk 
					subdataWithRange:NSMakeRange(lineStartIndex, i - lineStartIndex)];
					
				// the first line will be always be the boundary
				if (lineStartIndex == 0) {
					self.nextPartBoundary = [NSData dataWithData:line];
					NSString *b = [self dataToString:line];
					self.lastPartBoundary = [[NSString stringWithFormat:@"%@--", b] dataUsingEncoding:NSUTF8StringEncoding];
					[b release];
					
					
					NSLog(@"-> part header start");
					// an array to store raw headers for this part
					[self.rawPartHeaders addObject:[NSMutableArray array]];
					
				} else {
					
					if ([line length] == 0) {
						// an empty line indicates the stop of the header and the
						// start of the data

						NSLog(@"-> part header stop");
						
						currentPartHasHeader = TRUE;
						currentPartDataStartIndex = i;
						currentPartDataStopIndex = -1;
						
						NSLog(@"-> part body start");
						
					} else {
						// save the raw headers
						NSLog(@"->-> save raw header");
						
						NSMutableArray *partHeaders = [self.rawPartHeaders lastObject];
						NSString *h = [self dataToString:line];
						NSLog(@"->->-> %@", h);
						[partHeaders addObject:h];
						
						// if this is the first line of the headers, extract some
						// information from it.
						if ([h rangeOfString:@"Content-Disposition: form-data;"].location != NSNotFound) {
						
						}
						[h release];
					}
				}
				
				lineStartIndex = i + CRLFLen;
				i += CRLFLen - 1;
			}
		} else {
		
			if ([postDataChunk length] >= i + [self.nextPartBoundary length]) {
				if ([[postDataChunk subdataWithRange:NSMakeRange(i, [self.nextPartBoundary length])] isEqualToData:self.nextPartBoundary]) {
					NSLog(@"-> found next part boundary");
					currentPartDataStopIndex = i;
				}
			}
		
			if ([postDataChunk length] >= i + [self.lastPartBoundary length]) {
				if ([[postDataChunk subdataWithRange:NSMakeRange(i, [self.lastPartBoundary length])] isEqualToData:self.lastPartBoundary]) {
					NSLog(@"-> found last part boundary");
					currentPartDataStopIndex = i;
				}
			}
			
			
			if (currentPartDataStopIndex > 0) {
			
				NSLog(@"->-> save data");
			
				NSRange r = {currentPartDataStartIndex, currentPartDataStopIndex - currentPartDataStartIndex};
				NSData *tmp = [postDataChunk subdataWithRange:r];
				
				NSString *s = [self dataToString:tmp];
				
				//NSLog(@"\n~%@~\n", s);
				[s release];
				
				currentPartHasHeader = FALSE;
				currentPartDataStartIndex = -1;
				//currentPartDataStopIndex = -1;
			}
		}
	}
	
	if (currentPartHasHeader && currentPartDataStopIndex < 0) {
		NSLog(@"-- suspect chunked --");
		// save the data that we... and continue when the new chunk comes down...
	}
	
	
	
}



- (NSString *)dataToString:(NSData *)data {
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
}




@end
