//
//  AFDirectoryItem.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DirectoryItem : NSObject {
	NSString *path;
	NSString *name;
	NSString *type;
	NSString *date;
}

@property (nonatomic, copy) NSString *path, *name, *type, *date;

+ (id)initWithName:(NSString *)itemName atPath:(NSString *)itemPath;
- (id)initWithName:(NSString *)itemName atPath:(NSString *)itemPath;
- (void)determineFileTypeByExtension;

@end
