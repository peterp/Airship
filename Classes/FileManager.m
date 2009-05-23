//
//  FileManager.m
//  test
//
//  Created by Peter Pistorius on 2009/05/12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"




@implementation FileManager




- (id)initWithPath:(NSString *)aPath {
	
	// get the default document path
	NSString *currentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	currentPath = [currentPath stringByAppendingPathComponent:aPath];
	
	contents = [[NSMutableArray alloc] init];

	fileManager = [NSFileManager defaultManager];
	[fileManager changeCurrentDirectoryPath:currentPath];
	[self getContentsOfCurrentPath];

	return self;
}


- (void)getContentsOfCurrentPath {
}



-(void) changeCurrentPath:(NSString *)aPath {
	[fileManager changeCurrentDirectoryPath:
	 [[fileManager currentDirectoryPath] stringByAppendingPathComponent:aPath]];
	[self getContentsOfCurrentPath];
}


-(NSInteger) count {
	return [contents count];
}

- (NSDictionary *)getDictionaryAtIndex:(int)index {
	return [contents objectAtIndex:index];
}


-(void) dealloc {
	[contents release];
	[super dealloc];
}


@end
