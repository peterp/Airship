//
//  FileView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/19.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileView.h"


@implementation FileView

@synthesize delegate;



//- (id)initWithFrame:(CGRect)frame 
//{
//	if (self = [super initWithFrame:frame]) {
//	}
//	return self;
//}


- (void)dealloc;
{
	self.delegate = nil;
  [super dealloc];
}

- (void)loadFileAtPath:(NSString *)path;
{
	// This should never be called...
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
{
	// This should never be called...
}

- (void)didStartLoading;
{
	if ([self.delegate respondsToSelector:@selector(fileViewDidStartLoading)]) {
		[self.delegate fileViewDidStartLoading];
	}
}
- (void)didStopLoading;
{
	if ([self.delegate respondsToSelector:@selector(fileViewDidStopLoading)]) {
		[self.delegate fileViewDidStopLoading];
	}
}

- (void)openAs:(int)kind;
{
	if ([self.delegate respondsToSelector:@selector(fileViewDidOpenFileAs:)]) {
		[self.delegate fileViewDidOpenFileAs:kind];
	}
}

- (void)restoreFromPreviousSessionWithPosition:(int)position;
{
	// Should not be called.
}

- (int)getPosition;
{
	return -1;
}



@end
