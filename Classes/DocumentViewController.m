//
//  DocumentViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "DocumentViewController.h"


@implementation DocumentViewController

@synthesize webView;

- (void)dealloc;
{
		self.webView = nil;
		[super dealloc];
}

- (void)viewDidLoad;
{
	self.webView = [[TapDetectingWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
	[webView release];
	
	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated;
{
	NSURL *url = [NSURL fileURLWithPath:storageItem.absolutePath];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark UIWebView Delegates


- (void)tapDetectingWebViewGotSingleTap:(TapDetectingWebView *)aWebView;
{
	[self toggleBarsVisibilty];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView;
{
	[self.activityIndicator stopAnimating];
	[self.activityIndicator removeFromSuperview];
	self.activityIndicator = nil;
}




@end
