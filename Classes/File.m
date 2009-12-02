//
//  File.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "File.h"


@implementation File

@synthesize absolutePath;
@synthesize name;
@synthesize kind;
@synthesize date;
@synthesize size;


- (void)dealloc
{
	self.absolutePath = nil;
	self.name = nil;
	self.date = nil;
	self.size = nil;
	
	[super dealloc];
}




- (id)initWithName:(NSString *)fileName atPath:(NSString *)filePath;
{
	self.name = fileName;
	self.absolutePath = [filePath stringByAppendingPathComponent:fileName];
	
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:absolutePath error:nil];
	
	// DATE
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	dateFormat.dateFormat = @"dd MMM yyyy h:mm a";
	self.date = [dateFormat stringFromDate:[attributes fileModificationDate]];
	[dateFormat release];
	
	// SIZE
	self.size = @"--";
	
	// KIND
	self.kind = [self kindByExtension];
	if (kind == FILE_KIND_UNKNOWN && [[attributes fileType] isEqualToString:NSFileTypeDirectory]) {
		kind = FILE_KIND_DIRECTORY;
	}
	
	return self;
}



- (int)kindByExtension;
{
	// Kind by Extension
	NSArray  *aud = [NSArray arrayWithObjects:@"aac", @"mp3", @"aiff", @"wav", nil];
	NSArray  *doc = [NSArray arrayWithObjects:@"doc", @"docx", @"htm", @"html", @"key", @"numbers", @"pages", @"pdf", @"ppt", @"pptx", @"txt", @"rtf", @"xls", @"xlsx", nil];
	NSArray  *img = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"gif", @"tiff", @"png", nil];
	NSArray  *vid = [NSArray arrayWithObjects:@"m4v", @"mp4", @"mov", nil];
	
	NSString *ext = [[self.name pathExtension] lowercaseString];

	if ([aud containsObject:ext]) {
		return FILE_KIND_AUDIO;
	} else if ([doc containsObject:ext]) {
		return FILE_KIND_DOCUMENT;
	} else if ([img containsObject:ext]) {
		return FILE_KIND_IMAGE;
	} else if ([vid containsObject:ext]) {
		return FILE_KIND_VIDEO;
	}
	
	return FILE_KIND_UNKNOWN;
}



- (NSString *)kindDescription;
{
	switch (kind) {
		case FILE_KIND_AUDIO:
			return @"Audio";
			break;
		case FILE_KIND_DOCUMENT:
			return @"Document";
			break;
		case FILE_KIND_IMAGE:
			return @"Image";
			break;
		case FILE_KIND_VIDEO:
			return @"Video";
			break;
		case FILE_KIND_DIRECTORY:
			return @"Directory";
			break;
		default:
			return @"Unknown";
			break;
	}
}


- (BOOL)delete;
{
	return [[NSFileManager defaultManager] removeItemAtPath:self.absolutePath error:nil];
}




@end
