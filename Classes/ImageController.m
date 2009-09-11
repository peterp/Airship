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
	scrollView.clipsToBounds = YES;
	scrollView.bouncesZoom = YES;
	scrollView.showsVerticalScrollIndicator = scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.alwaysBounceHorizontal = NO;

	[self.view addSubview:scrollView];
	[scrollView release];
	
	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{

	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:directoryItem.path]];


	float minimumScale = 0;
	switch(self.interfaceOrientation) {
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			minimumScale = scrollView.frame.size.width / imageView.frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			minimumScale = scrollView.frame.size.height / imageView.frame.size.height;
			break;
	}
	scrollView.maximumZoomScale = 1.5;
	scrollView.minimumZoomScale = minimumScale;
	scrollView.zoomScale = minimumScale;
	
	imageView.center = CGPointMake(160, 240);
	
	[scrollView addSubview:imageView];
	[imageView release];
	
	[activityIndicatorView stopAnimating];
	[activityIndicatorView removeFromSuperview];
	self.activityIndicatorView = nil;
	
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(160, 240, 5, 5)];
	v.backgroundColor = [UIColor redColor];
	[self.view addSubview:v];
	[v release];
}



#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView 
{
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale
{
}







#pragma mark TapDetectingScrollView methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[self showHideToolBars];
}


#pragma mark Orientation

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration
{
}



@end
