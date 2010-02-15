//
//  File.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>


#define FILE_KIND_UNKNOWN 0
#define FILE_KIND_DIRECTORY 1
#define FILE_KIND_AUDIO 2
#define FILE_KIND_DOCUMENT 3
#define FILE_KIND_IMAGE 4
#define FILE_KIND_VIDEO 5



@interface File : NSObject {

	NSString *absolutePath;
	
	NSString *name;
	int kind;
	NSString *date;
	NSString *size;
}

@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, copy) NSString *name;
@property int kind;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *size;


- (id)initWithName:(NSString *)fileName atPath:(NSString *)filePath;
- (int)kindByExtension;
- (NSString *)kindDescription;
- (NSString *)mimeType;

- (BOOL)delete;


@end
