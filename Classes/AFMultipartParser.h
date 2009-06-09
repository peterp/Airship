//
//  AFMultipartParser.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFMultipartParser : NSObject {

	
	NSData *postDataChunk;


	NSData *nextBoundary;
	NSData *lastBoundary;
	
	int lineStartIndex;
	int bodyStartIndex;
	
	NSMutableArray *headers;
	NSMutableArray *parts;
	
	
	
	NSData *CRLF;
}

@property (nonatomic, retain) NSData *postDataChunk;


@property (nonatomic, retain) NSData *nextBoundary;
@property (nonatomic, retain) NSData *lastBoundary;

@property (nonatomic, retain) NSMutableArray *headers;
@property (nonatomic, retain) NSMutableArray *parts;


- (id)initWithBoundary:(NSString *)boundary;


- (void)parseMultipartChunk:(NSData *)data;
- (void)subPostDataChunkWithRange:(NSRange)range forPart:(NSMutableDictionary *)part;


- (NSString *)dataToString:(NSData *)data;

@end
