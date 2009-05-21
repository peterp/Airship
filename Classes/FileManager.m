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

	// empty out the contents before adding new files.
	[contents removeAllObjects];
	// create a date formatter, in the same style that finder uses.
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyy, HH:mm"];
	
	for (NSString *name in [fileManager directoryContentsAtPath:[fileManager currentDirectoryPath]]) 
	{
		NSDictionary *attributes = 
			[fileManager fileAttributesAtPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:name]
								 traverseLink:NO];
		[contents addObject:
		 [NSDictionary dictionaryWithObjectsAndKeys:
		  name, @"name",
		  [dateFormat stringFromDate:[attributes objectForKey:NSFileModificationDate]], @"date",
		  [attributes objectForKey:NSFileSize], @"size",
		  [attributes objectForKey:NSFileType], @"type",
		  @"na", @"kind",
		  nil]
		];
	}
	[dateFormat release];
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
