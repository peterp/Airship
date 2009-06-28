//
//  AFMultipartParser.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFMultipartParser : NSObject {
	NSFileHandle *fileHandler;
	NSData *postDataChunk;

	NSData *crlf;
	NSData *nextBoundary;
	NSData *lastBoundary;
	
	int lineStartIndex;
	int bodyStartIndex;
	
	
	NSMutableArray *parts;
	NSString *lastPartKey;
}

@property (nonatomic, retain) NSFileHandle *fileHandler;
@property (nonatomic, retain) NSData *postDataChunk;

@property (nonatomic, retain) NSData *nextBoundary;
@property (nonatomic, retain) NSData *lastBoundary;

@property (nonatomic, retain) NSMutableArray *parts;
@property (nonatomic, retain) NSString *lastPartKey;


- (id)initWithBoundary:(NSString *)boundary;
- (void)parseMultipartChunk:(NSData *)data;
- (void)bodyForPostDataChunkWithRange:(NSRange)range forPart:(NSMutableDictionary *)part;


- (NSString *)stringFromData:(NSData *)data;

@end
