//
//  AFMultipartParser.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AFMultipartParser.h"


@implementation AFMultipartParser

- (id)initWithBoundary:(NSString *)boundary {

	if ([super init]) {
		NSLog(@"%@", boundary);
	}
	return self;
	
}



- (void)parseMultipartChunk:(NSData *)postDataChunk {

}


@end
