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


- (void)dealloc 
{
	self.webView = nil;
	[super dealloc];
}



- (void)viewDidAppear:(BOOL)animated
{
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:directoryItem.path]]];
	[self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
}


#pragma mark AFWebView methods

- (void)webView:(UIWebView *)sender tappedWithTouch:(UITouch *)touch event:(UIEvent *)event
{
//	NSLog(@"event: %@ \r\n\n\n\n\n---------------------------------", event);

//	if (touch.tapCount == 1) {
//		[self toggleToolBarsHidden];
//	}
}

//- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
//{
////	NSLog(@"finished zooming");
//}

#pragma mark UIWebView Delegates

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[self hideActivityIndicator];
}



@end
