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
@synthesize navigationBar, tabBar;


- (void)dealloc 
{
	self.webView = nil;
	self.navigationBar = nil;
	self.tabBar = nil;

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
	NSLog(@"touch: %@", touch);
	NSLog(@"event: %@", event);


	navigationBar.hidden = NO;
	tabBar.hidden = NO;


//	tabBar.hidden = NO;
	
	// let's try and scroll this mofo....
	// ok, so this works... Now we need to figure out a way to get the actual height of this thing...
	
//	NSString *length = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
	

	
//	[webView stringByEvaluatingJavaScriptFromString:@"window.scrollBy(0,300)"];
	
	NSLog(@"tapped");
}

- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
	NSLog(@"finished zooming");
}



@end
