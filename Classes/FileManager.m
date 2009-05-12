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
	
	NSArray *directoryContents = [fileManager directoryContentsAtPath:[fileManager currentDirectoryPath]];
	[contents removeAllObjects];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyy, HH:mm"];
	
	for (NSString *fileName in directoryContents) {
		
		NSDictionary *attributes = [fileManager fileAttributesAtPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:fileName] traverseLink:NO];
		
		[contents addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
																 fileName,
																 [dateFormat stringFromDate:[attributes objectForKey:NSFileModificationDate]],
																 [NSString stringWithFormat:@"%1.0f", [[attributes objectForKey:NSFileSize] floatValue] / 1024],
																 nil
							 ] 
														forKeys:[NSArray arrayWithObjects:
																 @"name",
																 @"date",
																 @"size",
																 nil
							 ]
		 ]
		];
	}
	[dateFormat release];
}

-(void) changeCurrentPath:(NSString *)aPath {
	[fileManager changeCurrentDirectoryPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:aPath]];
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
