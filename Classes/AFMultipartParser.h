//
//  AFMultipartParser.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFMultipartParser : NSObject {
	NSData *nextBoundary;
	NSData *lastBoundary;
	
	int lineStartIndex;
	
	NSMutableArray *headers;
	NSMutableArray *parts;
	
	int dataStartIndex;
	int dataEndIndex;
	
	
	NSData *CRLF;
}


@property (nonatomic, retain) NSData *nextBoundary;
@property (nonatomic, retain) NSData *lastBoundary;

@property (nonatomic, retain) NSMutableArray *headers;
@property (nonatomic, retain) NSMutableArray *parts;


- (id)initWithBoundary:(NSString *)boundary;
- (void)parseMultipartChunk:(NSData *)postDataChunk;

- (NSString *)dataToString:(NSData *)data;

@end
