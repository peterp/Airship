//
//  FileDocumentView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/20.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileDocumentView.h"
#import "TapDetectingWebView.h"



@implementation FileDocumentView


@synthesize webView;
@synthesize singleTapGestureRecognizer;

- (void)dealloc;
{
	self.webView = nil;
	self.singleTapGestureRecognizer = nil;
	[super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		
		self.webView = nil;
		
		
		
		if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"3.1.3"]) {
			
			self.webView = [[TapDetectingWebView alloc] initWithFrame:frame];			
			
		} else {
			self.webView = [[UIWebView alloc] initWithFrame:frame];
			self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
			singleTapGestureRecognizer.numberOfTapsRequired = 1;
			singleTapGestureRecognizer.delegate = self;
			[webView addGestureRecognizer:singleTapGestureRecognizer];		
			[singleTapGestureRecognizer release];
		}
		

		
		webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		webView.scalesPageToFit = YES;
		webView.delegate = self;
		scrollTo = 0;
		[self addSubview:webView];
		
		
		
		
		[webView release];
	}
  return self;
}

- (void)loadFileAtPath:(NSString *)atPath;
{
	path = atPath;
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

#pragma mark -
#pragma mark delegate

- (void)handleSingleTap:(UITapGestureRecognizer*)sender;
{
	if ([self.delegate respondsToSelector:@selector(fileViewDidToggleToolbars)]) {
		[self.delegate fileViewDidToggleToolbars];
	}
}

- (void)tapDetectingWebViewGotSingleTap:(TapDetectingWebView *)aWebView;
{
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
//	NSLog(@"%d", scrollTo);
	[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0, %d);", scrollTo]];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self didStopLoading];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"A problem occured whilst trying to open the document \"%@\"", [path lastPathComponent]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

- (void)restoreFromPreviousSessionWithPosition:(int)position;
{
	if (position > 0) {
		scrollTo = position;
	}
}

- (int)getPosition;
{
	return [[webView stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}








@end
