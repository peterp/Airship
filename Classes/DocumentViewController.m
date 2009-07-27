//
//  DocumentViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DocumentViewController.h"
#import "DirectoryItem.h"




@implementation DocumentViewController

- (void)dealloc 
{
    [super dealloc];
}


- (void)viewDidLoad 
{

	[super viewDidLoad];
	
}

- (void)openFile:(DirectoryItem *)file
{
	self.title = file.name;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:file.path]]];
}



- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
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
