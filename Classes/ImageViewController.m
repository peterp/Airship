//
//  ImageViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/31.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"
#import "DirectoryItem.h"


#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5


@interface ImageViewController (UtilityMethods)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end


@implementation ImageViewController

- (void)dealloc 
{
	[imageScrollView release];
  [super dealloc];
}

- (void)loadView 
{
	[super loadView];
}

- (void)openFile:(DirectoryItem *)file 
{
	self.navigationItem.title = file.name;

  // set up main scroll view
	imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
//	[imageScrollView setBackgroundColor:[UIColor blackColor]];
	[imageScrollView setDelegate:self];
	[imageScrollView setBouncesZoom:YES];
	[imageScrollView setShowsVerticalScrollIndicator:NO];
	[imageScrollView setShowsHorizontalScrollIndicator:NO];
	[[self view] addSubview:imageScrollView];
	
	// add touch-sensitive image view to the scroll view
	TapDetectingImageView *imageView = [[TapDetectingImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:file.path]];
	[imageView setDelegate:self];
	[imageView setTag:ZOOM_VIEW_TAG];
	[imageScrollView setContentSize:[imageView frame].size];
	[imageScrollView addSubview:imageView];
	[imageView release];
	
	// calculate minimum scale to perfectly fit image width, and begin at that scale
	float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
	[imageScrollView setMinimumZoomScale:minimumScale];
	[imageScrollView setZoomScale:minimumScale];
}



#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint 
{
    // single tap does nothing for now
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint 
{
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint 
{
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}


#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end