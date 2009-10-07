//
//  StorageItem.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StorageItem : NSObject {
	NSString *absolutePath;
	
	NSString *name;
	NSString *kind;
	NSString *date;
	NSString *size;
}

@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *size;

- (id)initWithName:(NSString *)itemName atAbsolutePath:(NSString *)atPath;
- (NSString *)determineItemType;


@end
