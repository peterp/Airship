//
//  AFStorageManager.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AFStorageManager.h"


@implementation AFStorageManager

- (void)dealloc {
	[items release];
	[super dealloc];
}

- (id)initWithPath:(NSString *)aPath {
	
	// create an empty NSMutableArray to store the "Storage Items"
	items = [[NSMutableArray alloc] init];
	
	// set the current path to "aPath"
	fileManager = [NSFileManager defaultManager];
	[self changePath:
		[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
			objectAtIndex:0] stringByAppendingPathComponent:aPath]
		isAbsolute:YES];

	[self updateItemsAtPath];
	return self;
}


- (void)updateItemsAtPath {
	
	// empty out existing items
	[items removeAllObjects];
	
	// create a date formatter in the same style that "Finder" uses.
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyy, HH:mm"];
	
	for (NSString *name in [fileManager directoryContentsAtPath:[fileManager currentDirectoryPath]]) 
	{
		NSDictionary *attr =
			[fileManager fileAttributesAtPath:
				[[fileManager currentDirectoryPath] stringByAppendingPathComponent:name]
								 traverseLink:NO];
		
		[items addObject:
			[NSDictionary dictionaryWithObjectsAndKeys:
				name, @"name",
				[dateFormat stringFromDate:[attr objectForKey:NSFileModificationDate]], @"date",
				[attr objectForKey:NSFileSize], @"size",
				[attr objectForKey:NSFileType], @"type",
				@"none", @"kind",
				nil
			]
		];
	
	}
	[dateFormat release];
}



- (void)changePath:(NSString *)aPath isAbsolute:(BOOL)absolutePath {
	
	if (absolutePath) {
		[fileManager changeCurrentDirectoryPath:aPath];
	} else {
		[fileManager changeCurrentDirectoryPath:
			[[fileManager currentDirectoryPath] stringByAppendingPathComponent:aPath]];
	}

	[self updateItemsAtPath];
}

- (NSDictionary *)objectAtIndex:(NSInteger)index {

	return [items objectAtIndex:index];
}

- (NSInteger)count {

	return [items count];
}




@end
