//
//  ImagViewControlle.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "ImageViewController.h"


@implementation ImageViewController

@synthesize scrollView;
@synthesize imageView;


- (void)dealloc;
{
	self.imageView = nil;
	self.scrollView = nil;
	[super dealloc];
}

- (void)viewDidLoad;
{
	self.scrollView = [[TapDetectingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	scrollView.delegate = self;
	scrollView.bouncesZoom = YES;
	scrollView.alwaysBounceHorizontal = NO;
	[self.view addSubview:scrollView];
	[scrollView release];

	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated;
{
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:storageItem.absolutePath]];
	[self.scrollView addSubview:imageView];
	[imageView release];
	
	float minimumScale = self.scrollView.frame.size.width / self.imageView.frame.size.width;
	self.scrollView.maximumZoomScale = 2.5;
	self.scrollView.minimumZoomScale = minimumScale;
	self.scrollView.zoomScale = minimumScale;
	self.scrollView.showsHorizontalScrollIndicator = self.scrollView.showsVerticalScrollIndicator = NO;
	
	self.imageView.center = CGPointMake(160, 240);
	
	[self.activityIndicator stopAnimating];
	[self.activityIndicator removeFromSuperview];
	self.activityIndicator = nil;
}



#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView;
{
	return imageView;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	[self toggleBarsVisibilty];
}





@end
