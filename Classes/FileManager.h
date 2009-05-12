//
//  FileManager.h
//  test
//
//  Created by Peter Pistorius on 2009/05/12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject {
	
	NSFileManager *fileManager;
	NSMutableArray *contents;
}

- (id)initWithPath:(NSString *)aPath;
- (void)getContentsOfCurrentPath;
- (void)changeCurrentPath:(NSString *)newPath;

- (NSInteger)count;
- (NSDictionary *)getDictionaryAtIndex:(int)index;


@end
