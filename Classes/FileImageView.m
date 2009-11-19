//
//  FileImageView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/18.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileImageView.h"


@implementation FileImageView

@synthesize scrollView;
@synthesize imageView;


- (void)dealloc 
{
	
	self.imageView = nil;
	self.scrollView = nil;

	[super dealloc];
}


- (id)initWithFrame:(CGRect)frame 
{
	if ([super initWithFrame:frame]) {
	
		self.scrollView = [[TapDetectingScrollView alloc] initWithFrame:self.frame];
		scrollView.backgroundColor = [UIColor darkGrayColor];
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		scrollView.delegate = self;
		scrollView.tapDetectingDelegate = self;
		scrollView.bouncesZoom = YES;
		scrollView.alwaysBounceHorizontal = YES;
		scrollView.alwaysBounceVertical = YES;
		scrollView.clipsToBounds = YES;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.showsHorizontalScrollIndicator = NO;
		
		[self addSubview:scrollView];
		[scrollView release];
	}
		
  return self;
}

- (void)loadFileAtPath:(NSString *)path;
{
	// Load and display the image
	NSData *imageData = [NSData dataWithContentsOfFile:path];
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
	[scrollView addSubview:imageView];
	[imageView release];

	// Cache image's original dimensions
	imageWidth = imageView.frame.size.width;
	imageHeight = imageView.frame.size.height;

  // calculate minimum scale to perfectly fit image width, and begin at that scale
	float minimumZoomScale = imageWidth > imageHeight ? self.frame.size.width / imageWidth : self.frame.size.height / imageHeight;
	scrollView.minimumZoomScale = minimumZoomScale;
	scrollView.zoomScale = minimumZoomScale;
	scrollView.maximumZoomScale = 2.5;
	[self viewForZoomingInScrollView:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView;
{
	// If the image is still smaller than the actual size of the frame, keep it centered
	if (imageView.frame.size.height < self.frame.size.height) {
		// determine the center of the frame
		CGPoint p = self.imageView.center;
		imageView.center = CGPointMake(p.x, self.frame.size.height / 2);
	}
	if (self.imageView.frame.size.width < self.frame.size.width) {
		// determine the center of the frame
		CGPoint p = self.imageView.center;
		imageView.center = CGPointMake(self.frame.size.width / 2, p.y);
	}
	return imageView;
}

- (void)didRotateInterfaceOrientation;
{
	float minimumZoomScale = imageWidth > imageHeight ? self.frame.size.width / imageWidth : self.frame.size.height / imageHeight;
	scrollView.maximumZoomScale = 2.5;
	scrollView.minimumZoomScale = minimumZoomScale;
	scrollView.zoomScale = minimumZoomScale;
	[self viewForZoomingInScrollView:scrollView];
}

#pragma mark -
#pragma mark tapDetectingDelegate

- (void)TapDetectingScrollViewWasTapped:(UIScrollView *)scrollView;
{
	NSLog(@"send this along to this view's delegate...");
}

// this is a delegate method from scroll view....
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
	NSLog(@"send this along to this view's delegate...");
//	if (self.navigationBar.hidden == NO && self.toolbar.hidden == NO) {
//		[self toggleBarsVisibilty];
//	}
}







@end
