//
//  FileDocumentView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/20.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileDocumentView.h"



@implementation FileDocumentView


@synthesize webView;

- (void)dealloc;
{
	self.webView = nil;

	[super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
	
		self.webView = [[TapDetectingWebView alloc] initWithFrame:frame];
		webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		webView.scalesPageToFit = YES;
		webView.delegate = self;
		
		
		[self addSubview:webView];
		[webView release];
	}
  return self;
}

- (void)loadFileAtPath:(NSString *)path;
{
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

#pragma mark -
#pragma mark delegate

- (void)tapDetectingWebViewGotSingleTap:(TapDetectingWebView *)aWebView;
{
	NSLog(@"margle");
	if ([self.delegate respondsToSelector:@selector(fileViewDidToggleToolbars)]) {
		[self.delegate fileViewDidToggleToolbars];
	}
}


- (void)webViewDidStartLoad:(UIWebView *)aWebView;
{
	[self didStartLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView;
{
	[self didStopLoading];
}



@end
