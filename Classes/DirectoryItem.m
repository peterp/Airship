//
//  AFDirectoryItem.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DirectoryItem.h"


@implementation DirectoryItem

@synthesize path, name, type, date;



+ (id)initWithName:(NSString *)itemName atPath:(NSString *)itemPath
{
	DirectoryItem *directoryItem = [[[DirectoryItem alloc] initWithName:itemName atPath:itemPath] autorelease];
	return directoryItem;
}


- (id)initWithName:(NSString *)itemName atPath:(NSString *)itemPath
{
	if ([super init]) {
		self.path = [itemPath stringByAppendingPathComponent:itemName];
		self.name = itemName;
		
		
		NSLog(@"%@", self.path);
		
		// Attributes
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:nil];
		// Date
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"MMM dd yyyy, HH:mm"];
		self.date = [dateFormat stringFromDate:[attributes fileModificationDate]];
		[dateFormat release];
		// Size
		
		// Type
		if ([[attributes fileType] isEqualToString:NSFileTypeDirectory]) {
			self.type = @"directory";
		} else {
			[self determineFileTypeByExtension];
		}
	}
	return self;
}


- (void)determineFileTypeByExtension
{
	// Types
	NSArray *vid = [NSArray arrayWithObjects:@"m4v", @"mp4", @"mov", nil];
	NSArray *snd = [NSArray arrayWithObjects:@"aac", @"mp3", @"aiff", @"wav", nil];
	NSArray *img = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"gif", @"tiff", @"png", nil];
	NSArray *doc = [NSArray arrayWithObjects:@"doc", @"docx", @"htm", @"html", @"key", @"numbers", @"pages", @"pdf", @"ppt", @"pptx", @"txt", @"rtf", @"xls", @"xlsx", nil];
	
	NSString *ext = [self.name pathExtension];
	if ([img containsObject:ext]) {
		// Image
		self.type = @"image";
	} else if ([doc containsObject:ext]) {
		// Document
		self.type = @"document";
	} else if ([snd containsObject:ext]) {
		// Sound
		self.type = @"sound";
	} else if ([vid containsObject:ext]) {
		// Video
		self.type = @"video";
	} else { 
		// Unknown
		self.type = @"unknown";
	}
}

- (void)dealloc 
{
	self.path = nil;
	self.name = nil;
	self.type = nil;
	self.date = nil;
	[super dealloc];
}

@end
