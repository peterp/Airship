//
//  AFMultipartParser.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AFMultipartParser.h"


@implementation AFMultipartParser

@synthesize nextBoundary,
			lastBoundary,
			headers,
			parts;

- (id)initWithBoundary:(NSString *)boundary {

	if ([super init]) {
	
		// create the next and last part boundaries
		self.nextBoundary = [[NSString stringWithFormat:@"--%@", boundary] 
			dataUsingEncoding:NSUTF8StringEncoding];
		self.lastBoundary = [[NSString stringWithFormat:@"--%@--", boundary] 
			dataUsingEncoding:NSUTF8StringEncoding];
		
		lineStartIndex = 0;
		
		self.headers = [NSMutableArray array];
		self.parts = [NSMutableArray array];
		
		dataStartIndex = -1;
		dataEndIndex = -1;

		UInt16 CRLFBytes = 0x0A0D;
		CRLF = [[NSData alloc] initWithBytes:&CRLFBytes length:2];
	}
	return self;
	
}

- (void) dealloc
{
	[nextBoundary release];
	[lastBoundary release];
	
	[headers release];
	[parts release];
	
	[CRLF release];

	[super dealloc];
}




- (void)parseMultipartChunk:(NSData *)postDataChunk {
	
	NSLog(@"---------- new chunk ----------");
	
	for (int i = 0; i < postDataChunk.length; i++) {
	
	
		if (postDataChunk.length >= i + lastBoundary.length) {
		
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, lastBoundary.length)] isEqualToData:lastBoundary]) {
			
				dataEndIndex = i;
				NSLog(@"->->-> data save");
			
				NSLog(@"-> part end (last boundary)");
				
				break;
			}
			
		
		}
	
		if (postDataChunk.length >= i + nextBoundary.length) {
			
			
			// search for a boundary including the EOL.
			// that means that the index + the boundary length is the entire
			// line, so the next bit of data been searched is starting on the next line.
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, nextBoundary.length)] isEqualToData:nextBoundary]) {
			
				if (dataStartIndex > 0) {
					NSLog(@"->->-> data save");
				
					// we'll do this atleast three times, be DRY.
					dataEndIndex = i - CRLF.length;
					
					NSDictionary *part = [parts lastObject];
					
					if ([part objectForKey:@"filename"]) {
						// this is a filename, figure out how to deal with this
						// a bit later...
					} else {
						// ordinary text data. store.
						 NSString *value = [self dataToString:[postDataChunk 
							subdataWithRange:NSMakeRange(dataStartIndex, dataEndIndex - dataStartIndex)]];
						[part setValue:value forKey:@"value"];
						[value release];
					}
					NSLog(@"-> part end");
				}
				
				
				// reset for next part...
				NSLog(@"-> part start");
				NSLog(@"->-> header start");
				
				

				// add object to deal with raw headers
				[headers addObject:[NSMutableArray array]];
				
				dataStartIndex = -1;
				dataEndIndex = -1;
								
				i += nextBoundary.length + CRLF.length;
				lineStartIndex = i;
			}
		}
		
		if (dataStartIndex < 0 && postDataChunk.length >= i + CRLF.length) {
		
			// searching for newlines.
			if ([[postDataChunk subdataWithRange:NSMakeRange(i, CRLF.length)] isEqualToData:CRLF]) {
				
				NSData *line = [postDataChunk subdataWithRange:NSMakeRange(lineStartIndex, i - lineStartIndex)];
				
				lineStartIndex = i + CRLF.length;
				i += (CRLF.length - 1); 

				
				
				// indicates the end of header
				if (line.length == 0) {
					NSLog(@"->-> header stop");
					dataStartIndex = lineStartIndex;
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
	
	NSLog(@"%@", parts);
}

- (NSString *)dataToString:(NSData *)data {
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
}



@end
