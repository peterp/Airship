//
//  AFMultipartParser.m

#import "AFMultipartParser.h"


@implementation AFMultipartParser


@synthesize fileHandler;
@synthesize parts;
@synthesize lastPartName;

			

/**
 * The boundary is obtained from the headers of the HTTP request. This method 
 * creates the next/ last part boundaries.
 **/
- (id)initWithBoundary:(NSString *)boundary 
{

	if ([super init]) {
		
		// We search for boundaries, cache the length.
		nextBoundaryLength = boundary.length + 2;
		nextBoundaryBytes = (Byte *)malloc(nextBoundaryLength);
		memcpy(nextBoundaryBytes, [[[NSString stringWithFormat:@"--%@", boundary] dataUsingEncoding:NSUTF8StringEncoding] bytes], nextBoundaryLength);
		
		lastBoundaryLength = boundary.length + 4;
		lastBoundaryBytes = (Byte *)malloc(lastBoundaryLength);
		memcpy(lastBoundaryBytes, [[[NSString stringWithFormat:@"--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding] bytes], lastBoundaryLength);
		
		// These index are used to mark the start of data that we are going to slice.
		lineStartIndex = -1;
		bodyStartIndex = -1;
		
		
		// this dictionary will hold all the information about the various parts.
		self.parts = [NSMutableDictionary dictionary];
	}
	
	return self;
}


- (void) dealloc
{
	self.fileHandler = nil;
		
	free(nextBoundaryBytes);
	free(lastBoundaryBytes);

	self.parts = nil;
	self.lastPartName = nil;


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
- (void)parseMultipartChunk:(NSData *)postDataChunk {

	//NSLog(@"~~~ CHUNK ~~~");
	
	// Cache the "bytes" function call and length.
	int postDataChunkLength = postDataChunk.length;
	Byte *postDataChunkBytes = (Byte *)postDataChunk.bytes;

	for (int i = 0; i < postDataChunkLength; i++) {

		// Search for last boundary
		if (postDataChunkBytes[i] == lastBoundaryBytes[0]) {
			if (memcmp(lastBoundaryBytes, postDataChunkBytes + i, lastBoundaryLength) == 0) {
				//NSLog(@". part END (last)");
				//NSLog(@"... data SAVE (last)");
				
				[self bodyForPostDataChunk:postDataChunk withRange:NSMakeRange(bodyStartIndex, (i - bodyStartIndex) - 2)];
				bodyStartIndex = -1;
				break;
			}
		}
		
		// Search for next boundary
		if (postDataChunkBytes[i] == nextBoundaryBytes[0]) {
			if (memcmp(nextBoundaryBytes, postDataChunkBytes + i, nextBoundaryLength) == 0) {
				
				// We're already tracking a body. Save the data.
				if (bodyStartIndex >= 0) {
					//NSLog(@"... data SAVE (next)");
					[self bodyForPostDataChunk:postDataChunk withRange:NSMakeRange(bodyStartIndex, (i - bodyStartIndex) - 2)];
					//NSLog(@". part END (next)");
				}
				
				//NSLog(@". part START (next)");
				//NSLog(@".. header START");
				
				// Reset search range, looking for headers now
				bodyStartIndex = -1;

				i += nextBoundaryLength + 2;
				lineStartIndex = i;
			}
		}
		
		
		// Searching for CRLF because we're searching for headers now
		if (bodyStartIndex < 0 && i < postDataChunkLength - 1) {
			if (postDataChunkBytes[i] == 0x0D && postDataChunkBytes[i + 1] == 0x0A) {
			
				int lineLength = (i - lineStartIndex);
				if (lineLength == 0) {
					//NSLog(@".. header STOP");
					bodyStartIndex = i + 2;
				} else {
					//NSLog(@"... header PARSE");
					
					
					// I added this here... THIS MIGHT BREAK EVERYTHING. PLEASE TEST IT.
					if (lineStartIndex >= i) {
						lineStartIndex = 0;
					}
					
					NSData *lineData = [postDataChunk subdataWithRange:NSMakeRange(lineStartIndex, i - lineStartIndex)];
					NSString *line = [self stringFromData:lineData];
					
					//Content-Disposition: form-data; name="new_file"; filename="iPhone HIG.pdf"
					// The first line of the header contains the field's name as well. And if it's a 
					// file field, it contains the name of the file.
					if ([line rangeOfString:@"Content-Disposition: form-data;"].location != NSNotFound) {
						NSArray *bits = [line componentsSeparatedByString:@"\""];
						NSMutableDictionary *part = [NSMutableDictionary dictionary];
						if ([bits count] == 5) {
							if ([[bits objectAtIndex:2] isEqualToString:@"; filename="]) {
								// confirmed file upload
								
								
								// replacing \ with / because windows uploads the entire file path... Can you imagine the fail.
								NSString *filename = [[[bits objectAtIndex:3] stringByReplacingOccurrencesOfString:@"\\" withString:@"//"] lastPathComponent];
								[part setObject:filename forKey:@"filename"];
								
							}
						}
						// Add this to the "parts" array.
						self.lastPartName = [bits objectAtIndex:1];
						[parts setObject:part forKey:lastPartName];
					}
					
					[line release];
				}
				lineStartIndex = i + 2;
			}
		}
	}
	
	/**
	 * Oh no! We haven't found the end of this parts body. It probably means
	 * that this is spanning over many chunked bytes.
	 */
	if (bodyStartIndex >= 0) {
	
		//NSLog(@"... data SAVE (chunk)");
		[self bodyForPostDataChunk:postDataChunk withRange:NSMakeRange(bodyStartIndex, postDataChunkLength - bodyStartIndex)];
		// Since we're still searching for the rest of this parts body set the
		// slice range to the very first byte of the next chunk.
		bodyStartIndex = 0;
	}

	
	
	
}




- (NSString *)stringFromData:(NSData *)data 
{
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
}





- (void)bodyForPostDataChunk:(NSData *)data withRange:(NSRange)range
{

	NSMutableDictionary *part = [parts valueForKey:lastPartName];
	// Is this a file?
	
	NSString *filename = [part valueForKey:@"filename"];
	if (filename) {
	
		// Already started saving this file?
		NSString *tmpFilePath = [part valueForKey:@"tmpFilePath"];
		if (!tmpFilePath) {
			tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f_%@", [NSDate timeIntervalSinceReferenceDate] * 100, filename]];
			
			[part setObject:tmpFilePath forKey:@"tmpFilePath"];
		
			// Create file and assing the fileHandler
			[[NSFileManager defaultManager] createFileAtPath:tmpFilePath contents:nil attributes:nil];
			self.fileHandler = nil;
			self.fileHandler = [NSFileHandle fileHandleForWritingAtPath:tmpFilePath];

		}
		
		// Write
		//NSLog(@"..... write to path: %@", tmpFilePath);
		[fileHandler seekToEndOfFile];
		[fileHandler writeData:[data subdataWithRange:range]];
	} else {
		// Exctract and place this value in the part dictionary
		NSString *value = [self stringFromData:[data subdataWithRange:range]];
		[part setValue:value forKey:@"value"];
		[value release];	
	}
}




@end
