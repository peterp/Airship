//
//  AFMultipartParser.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AFMultipartParser.h"


@implementation AFMultipartParser

@synthesize postDataChunk,
			nextBoundary,
			lastBoundary;

@synthesize headers,
			parts;

- (id)initWithBoundary:(NSString *)boundary {

	if ([super init]) {
		/* 
		Create the next/ last part boundaries from the original boundary 
		found in the header.
		*/
		self.nextBoundary = [[NSString stringWithFormat:@"--%@", boundary] 
			dataUsingEncoding:NSUTF8StringEncoding];
		self.lastBoundary = [[NSString stringWithFormat:@"--%@--", boundary] 
			dataUsingEncoding:NSUTF8StringEncoding];
		
		// This index is used to mark the start of the data we want to slice.
		lineStartIndex = 0;
		bodyStartIndex = -1;
		
		
		self.headers = [NSMutableArray array];
		self.parts = [NSMutableArray array];
		

		UInt16 CRLFBytes = 0x0A0D;
		CRLF = [[NSData alloc] initWithBytes:&CRLFBytes length:2];
	}
	return self;
	
}

- (void) dealloc
{
	self.nextBoundary  = nil;
	self.lastBoundary  = nil;
	self.postDataChunk = nil;

	
	[headers release];
	[parts release];
	
	[CRLF release];

	[super dealloc];
}




- (void)parseMultipartChunk:(NSData *)data {

	/**
	The "data" needs to be an instance variable because we're going to be 
	slicing bits out of it with other methods.
	**/
	self.postDataChunk = data;
	
	NSLog(@"---------- new chunk ----------");
	
	for (int i = 0; i < postDataChunk.length; i++) {
	
		// matching the last boundary.
		if (postDataChunk.length >= i + lastBoundary.length) {
		
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, lastBoundary.length)] isEqualToData:lastBoundary]) {
			
				int dataEndIndex = i;
				NSLog(@"->->-> data save");
			
				NSLog(@"-> part end (last boundary)");
				
				break;
			}
			
		
		}
	
	
		// matching "next" boundary
		if (postDataChunk.length >= i + nextBoundary.length) {
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, nextBoundary.length)] isEqualToData:nextBoundary]) {
			
				/**
				If you find a new boundary and bodyStartIndex has a positive
				value. This marks the "end" of a part, and because this is a
				"nextBoundary" the start of another part.
				*/
				
				
				if (bodyStartIndex > 0) {
					NSLog(@"->->-> data SAVE");
					
					[self subPostDataChunkWithRange:
						NSMakeRange(bodyStartIndex, (i - bodyStartIndex) - CRLF.length)
						forPart:[parts lastObject]];
					
					NSLog(@"-> part END");
				}
				
				
				// reset for next part...
				NSLog(@"-> part start");
				NSLog(@"->-> header start");
				
				

				// add object to deal with raw headers
				[headers addObject:[NSMutableArray array]];
				
				bodyStartIndex = -1;
								
				i += nextBoundary.length + CRLF.length;
				lineStartIndex = i;
			}
		}
		
		if (bodyStartIndex < 0 && postDataChunk.length >= i + CRLF.length) {
		
			// searching for newlines.
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, CRLF.length)] isEqualToData:CRLF]) {
				
				NSData *line = [postDataChunk subdataWithRange:NSMakeRange(lineStartIndex, i - lineStartIndex)];
				
				lineStartIndex = i + CRLF.length;
				i += (CRLF.length - 1); 

				
				
				// indicates the end of header
				if (line.length == 0) {
					NSLog(@"->-> header stop");
					bodyStartIndex = lineStartIndex;
				} else {
					NSLog(@"->->-> header save");
					
					NSMutableArray *header = [headers lastObject];
					NSString *lineText  = [self dataToString:line];
					[header addObject:lineText];
					
					// this first line of the header contains valuable information!
					if ([lineText rangeOfString:@"Content-Disposition: form-data;"].location != NSNotFound) {
					
						NSArray *c = [lineText componentsSeparatedByString:@"\""];
						NSMutableDictionary *part = [NSMutableDictionary dictionaryWithObject:[c objectAtIndex:1] forKey:@"name"];
						if ([c count] == 5) {
							[part setValue:[c objectAtIndex:3] forKey:@"filename"];
						}
						[parts addObject:part];
					}
					
					[lineText release];
				}
			}
		}
	}
	

}




- (NSString *)dataToString:(NSData *)data {
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
}


- (void)subPostDataChunkWithRange:(NSRange)range forPart:(NSMutableDictionary *)part {
	/**
	Check the part dictionary to see if this method is saving a string value or
	streaming an upload to a file.
	*/
	
	NSString *filename = [part objectForKey:@"filename"];
	if (filename) {
	} else {
		// extract and place this value in to the "part" dictionary.
		
		

		NSString *value = [self dataToString:[postDataChunk subdataWithRange:range]];
		[part setValue:value forKey:@"value"];
		[value release];
		
		NSLog(@"part: %@", part);
	}
};



@end
