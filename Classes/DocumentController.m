//
//  DocumentController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DocumentController.h"


@implementation DocumentController


@synthesize webView;
@synthesize navigationBar, toolBar;


- (void)dealloc 
{
	self.webView = nil;
	self.navigationBar = nil;
	self.toolBar = nil;

	[super dealloc];
}



- (void)viewDidLoad 
{
	[super viewDidLoad];
}




- (void)openFile:(DirectoryItem *)file
{
	navigationBar.topItem.title = file.name;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:file.path]]];
}


- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
	if (touch.tapCount == 1) {
		if (navigationBar.hidden) {
			navigationBar.hidden = NO;
			toolBar.hidden = NO;
			hideControlsTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(hideControls:) userInfo:nil repeats:NO];
		} else {
			navigationBar.hidden = YES;
			toolBar.hidden = YES;
			[hideControlsTimer invalidate];
		}
	}
}

- (void)hideControls:(NSTimer*)aTimer
{
	navigationBar.hidden = YES;
	toolBar.hidden = YES;
	
//	if (navigationBar.alpha > 0) {
//			CGContextRef context = UIGraphicsGetCurrentContext();
//			[UIView beginAnimations:nil context:context];
//			[UIView setAnimationDuration:0.2];
//			navigationBar.alpha = 0;
//			tabBar.alpha = 0;
//			[UIView commitAnimations];
//	}
}


- (IBAction)closeFile
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}


- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
//	NSLog(@"finished zooming");
}



@end
