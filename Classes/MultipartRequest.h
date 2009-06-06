//
//  MultipartRequest.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MultipartRequest : NSObject {
	
	NSData *CRLF;
	int CRLFLen;
	
	int lineStartIndex;
	
	int dataStartIndex;
	int dataStopIndex;
	
	
	NSData *nextPartBoundary;
	NSData *lastPartBoundary;
	NSData *boundary;
	
	
	NSMutableArray *parts;
	NSMutableArray *rawPartHeaders;
	

	int currentPartState;
	
	BOOL currentPartHasHeader;
	int currentPartDataStartIndex;
	int currentPartDataStopIndex;

}

@property (nonatomic, retain) NSData *boundary;
@property (nonatomic, retain) NSData *nextPartBoundary;
@property (nonatomic, retain) NSData *lastPartBoundary;
@property (nonatomic, retain) NSMutableArray *parts;
@property (nonatomic, retain) NSMutableArray *rawPartHeaders;

- (id)initWithDefaults;


- (void)parseMultipartChunk:(NSData *)postDataChunk;
- (NSString *)dataToString:(NSData *)data;





@end
