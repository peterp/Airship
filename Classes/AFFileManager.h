//
//  AFFileManager.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFFileManager : NSObject {
	
	NSString *absolutePath;

	NSFileManager *fileManager;
	NSDateFormatter *dateFormat;
}

@property (nonatomic, retain) NSString *absolutePath;
@property (nonatomic, retain) NSFileManager *fileManager;
@property (nonatomic, retain) NSDateFormatter *dateFormat;

- (void)initWithPath:(NSString *)path;

@end
