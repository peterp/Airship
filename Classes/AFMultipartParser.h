//
//  AFMultipartParser.h

#import <Foundation/Foundation.h>


@interface AFMultipartParser : NSObject {

	NSFileHandle *fileHandler;

	
	// We search for these

	Byte *nextBoundaryBytes;
	Byte *lastBoundaryBytes;
	
	int nextBoundaryLength;
	int lastBoundaryLength;
	
	// We need to store these indexes.
	int lineStartIndex;
	int bodyStartIndex;
	
	NSMutableDictionary *parts;
	NSString *lastPartName;
}

@property (nonatomic, retain) NSFileHandle *fileHandler;
@property (nonatomic, retain) NSMutableDictionary *parts;
@property (nonatomic, copy) NSString *lastPartName;


- (id)initWithBoundary:(NSString *)boundary;
- (void)parseMultipartChunk:(NSData *)postDataChunk;
- (void)bodyForPostDataChunk:(NSData *)data withRange:(NSRange)range;


- (NSString *)stringFromData:(NSData *)data;

@end
