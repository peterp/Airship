//
//  FileController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileController.h"


@implementation FileController


@synthesize navigationBar, toolBar, activityIndicatorView;
@synthesize directoryItem;


- (void)dealloc
{
	self.activityIndicatorView = nil;
	self.navigationBar = nil;
	self.toolBar = nil;
	
	self.directoryItem = nil;
	
	[super dealloc];
}


- (void)viewDidLoad 
{

	[super viewDidLoad];

	// init navigationBar.
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	navigationBar.barStyle = UIBarStyleBlackTranslucent;
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	navigationBar.alpha = 0;
	
	// add navigation item to navigation bar
	UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:directoryItem.name];

	// done button
	UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(unloadView)];
	navigationItem.leftBarButtonItem = doneBarButtonItem;
	[doneBarButtonItem release];

	// activity indicator
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	[activityIndicatorView startAnimating];
	[activityIndicatorView release];
	navigationItem.rightBarButtonItem = activityBarButtonItem;
	[activityBarButtonItem release];
	
	[navigationBar pushNavigationItem:navigationItem animated:NO];
	[navigationItem release];
	[self.view addSubview:navigationBar];
	[navigationBar release];
	
	
	// toolbar
	self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
	toolBar.barStyle = UIBarStyleBlackTranslucent;
	toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	toolBar.alpha = 0;
	[self.view addSubview:toolBar];
	[toolBar release];
	
	// show the toolbars, anything calling view did load will want to see these.
	[self showHideToolBars];
}


- (IBAction)unloadView
{
	// destroy any lingering timers
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToolBarsAfterDelay) object:nil];

	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}







# pragma mark UINavigationBar and UIToolBar 

- (void)showHideToolBars
{
	if (navigationBar.alpha == 0 && toolBar.alpha == 0) { 
	
		navigationBar.hidden = toolBar.hidden = NO;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
		navigationBar.alpha = 1;
		toolBar.alpha = 1;
		[UIView commitAnimations];
		
		
		// after 4S hide the toolbars.
		[self performSelector:@selector(hideToolBarsAfterDelay) withObject:nil afterDelay:4];
	} else {
		navigationBar.hidden = toolBar.hidden = YES;
		navigationBar.alpha = toolBar.alpha = 0;
		// cancel the selector.
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToolBarsAfterDelay) object:nil];
	}
}


- (void)hideToolBarsAfterDelay
{
	if (self.activityIndicatorView == nil) {
		navigationBar.hidden = toolBar.hidden = YES;
	} else {
		[self performSelector:@selector(hideToolBarsAfterDelay) withObject:nil afterDelay:2];
	}
}





@end

