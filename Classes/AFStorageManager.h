//
//  AFStorageManager.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFStorageManager : NSObject {
	NSFileManager  *fileManager;
	NSMutableArray *items;
}

- (id)initWithPath:(NSString *)aPath;
- (void)updateItemsAtPath;

- (void)changePath:(NSString *)aPath isAbsolute:(BOOL)absolutePath;

- (NSDictionary *)objectAtIndex:(NSInteger)index;
- (NSInteger)count;



@end
