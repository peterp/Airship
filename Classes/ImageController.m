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
	[super viewDidLoad];
//	[self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
}


- (void)viewDidAppear:(BOOL)animated
{

	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:directoryItem.path]];
	imageView.contentMode = UIViewContentModeCenter;

	scrollView.clipsToBounds = NO;
	scrollView.delegate = self;
	float minimumScale = scrollView.frame.size.width / imageView.frame.size.width;
	scrollView.maximumZoomScale = 2.5;
	scrollView.minimumZoomScale = minimumScale;
	scrollView.zoomScale = minimumScale;
	scrollView.contentSize = imageView.frame.size;
	scrollView.showsVerticalScrollIndicator = scrollView.showsHorizontalScrollIndicator = NO;

	imageView.frame = scrollView.frame;
	[scrollView addSubview:imageView];
	[imageView release];
//	[self hideActivityIndicator];
}






#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
	return imageView;
}


#pragma mark TapDetectingScrollView methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
//	[self toggleToolBarsHidden];
}



//
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
//{
//
//	NSLog(@"x: %f, y: %f", scrollView.contentOffset.x, scrollView.contentOffset.y); 
//
////CGFloat tempx = view.center.x-160;
////CGFloat tempy = view.center.y-160;
////myScrollViewOffset = CGPointMake(tempx,tempy);
//}
//
//
///************************************** NOTE **************************************/
///* The following delegate method works around a known bug in zoomToRect:animated: */
///* In the next release after 3.0 this workaround will no longer be necessary      */
///**********************************************************************************/
////- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
////{
////    [scrollView setZoomScale:scale+0.01 animated:NO];
////    [scrollView setZoomScale:scale animated:NO];
////}
//
//#pragma mark TapDetectingImageViewDelegate methods
//
//- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint 
//{
//	// do nothing!
//}
//
//- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint 
//{
//    // double tap zooms in
//    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
//    [imageScrollView zoomToRect:zoomRect animated:YES];
//}
//
//- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint 
//{
//    // two-finger tap zooms out
//    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
//    [imageScrollView zoomToRect:zoomRect animated:YES];
//}
//
//
//#pragma mark Utility methods
//
//- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
//
//	NSLog(@"zoomRect");
//    
//    CGRect zoomRect;
//    
//    // the zoom rect is in the content view's coordinates. 
//    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
//    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
//    zoomRect.size.height = [imageScrollView frame].size.height / scale;
//    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
//    
//    // choose an origin so as to get the right center.
//    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
//    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
//    
//    return zoomRect;
//}
//





@end
