//
//  ImageController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageController.h"
#import "TapDetectingScrollView.h"


@implementation ImageController

@synthesize scrollView, imageView;

- (void)dealloc 
{
	self.imageView = nil;
	self.scrollView = nil;
	[super dealloc];
}

- (void)viewDidLoad
{
	

	self.scrollView = [[TapDetectingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	scrollView.backgroundColor = [UIColor blackColor];
	scrollView.delegate = self;
	scrollView.clipsToBounds = NO;
	scrollView.showsVerticalScrollIndicator = scrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:scrollView];
	[scrollView release];
	
	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{

	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:directoryItem.path]];
	imageView.contentMode = UIViewContentModeCenter;

	
	float minimumScale = scrollView.frame.size.width / imageView.frame.size.width;
	scrollView.maximumZoomScale = 2.5;
	scrollView.minimumZoomScale = minimumScale;
	scrollView.zoomScale = minimumScale;
	scrollView.contentSize = imageView.frame.size;
	

	imageView.frame = scrollView.frame;
	[scrollView addSubview:imageView];
	[imageView release];
	
	[activityIndicatorView stopAnimating];
	self.activityIndicatorView = nil;
}



#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
	return imageView;
}


#pragma mark TapDetectingScrollView methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[self showHideToolBars];
}



@end
