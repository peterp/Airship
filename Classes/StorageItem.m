//
//  StorageItem.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "StorageItem.h"


@implementation StorageItem

@synthesize absolutePath;
@synthesize name;
@synthesize kind;
@synthesize date;
@synthesize size;


- (void)dealloc
{
	self.absolutePath = nil;
	self.name = nil;
	self.kind = nil;
	self.date = nil;
	self.size = nil;
	
	[super dealloc];
}




- (id)initWithName:(NSString *)itemName atAbsolutePath:(NSString *)itemPath;
{
	self.name = itemName;
	self.absolutePath = [itemPath stringByAppendingPathComponent:itemName];
	
	// Date, Size, Kind
	NSDictionary *attrib = [[NSFileManager defaultManager] attributesOfItemAtPath:self.absolutePath error:nil];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyyy, HH:mm"];
	self.date = [dateFormat stringFromDate:[attrib fileModificationDate]];
	[dateFormat release];

	self.size = @"--";
	
	if ([[attrib fileType] isEqualToString:NSFileTypeDirectory]) {
		self.kind = @"directory";
	} else {
		self.kind = [self determineKindByExtension];
	}


	return self;
}



- (NSString *)determineKindByExtension;
{
	// Kind by Extension
	NSArray  *doc = [NSArray arrayWithObjects:@"doc", @"docx", @"htm", @"html", @"key", @"numbers", @"pages", @"pdf", @"ppt", @"pptx", @"txt", @"rtf", @"xls", @"xlsx", nil];
	NSArray  *img = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"gif", @"tiff", @"png", nil];
	NSArray  *aud = [NSArray arrayWithObjects:@"aac", @"mp3", @"aiff", @"wav", nil];
	NSArray  *vid = [NSArray arrayWithObjects:@"m4v", @"mp4", @"mov", nil];
	
	
	
	
	NSString *ext = [[self.name pathExtension] lowercaseString];
	if ([doc containsObject:ext]) {
		return @"document";
	} else if ([img containsObject:ext]) {
		return @"image";
	} else if ([aud containsObject:ext]) {
		return @"audio";
	} else if ([vid containsObject:ext]) {
		return @"video";
	}


	return @"unknown";
}

@end
