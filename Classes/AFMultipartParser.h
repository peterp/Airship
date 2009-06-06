//
//  AFMultipartParser.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFMultipartParser : NSObject {

	NSData *nextPartBoundary;
	NSData *lastPartBoundary;
}

- (id)initWithBoundary:(NSString *)boundary;
- (void)parseMultipartChunk:(NSData *)postDataChunk;

@end
