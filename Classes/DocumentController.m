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
		[self toggleControls];
	}
}

- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
//	NSLog(@"finished zooming");
}



@end
