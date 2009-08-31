//
//  DocumentController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DocumentController.h"
#import "TapDetectingWebView.h"


@implementation DocumentController


@synthesize webView;


- (void)dealloc 
{
	self.webView = nil;
	[super dealloc];
}


- (void)viewDidAppear:(BOOL)animated
{
	// show activity indicator.
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:directoryItem.path]]];
}

- (void)viewDidLoad
{
	self.webView = [[TapDetectingWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:webView];
	[webView release];
	
	// add navigationBar & toolBar.
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{

	NSLog(@"OH SHIT, A FUCKEN MEMORY WARNING");
	[super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark TapDetectingWebViewDelegate methods


- (void)tapDetectingWebViewGotSingleTap:(TapDetectingWebView *)aWebView
{
//	[self toggleToolBarsHidden];
}


#pragma mark UIWebView Delegates


- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
//	[self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
//	[self hideActivityIndicator];
}




@end
