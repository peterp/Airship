//
//  FileController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileController.h"


@implementation FileController


@synthesize navigationBar, toolBar;
@synthesize directoryItem;
@synthesize activityIndicator;


- (void)dealloc
{
	self.navigationBar = nil;
	self.toolBar = nil;
	
	self.directoryItem = nil;
	[super dealloc];
}


- (void)viewDidLoad 
{
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	navigationBar.barStyle = UIBarStyleBlackTranslucent;
	navigationBar.alpha = 0;
	UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:directoryItem.name];
	UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeFile)];
	navigationItem.leftBarButtonItem = doneBarButton;
	[doneBarButton release];
	[navigationBar pushNavigationItem:navigationItem animated:NO];
	[navigationItem release];
	[self.view addSubview:navigationBar];
	[navigationBar release];




	
//	
//	self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320,8 44)];
//	toolBar.tintColor = [UIColor blackColor];
//	toolBar.translucent = YES;
//	[self.view addSubview:toolBar];
//	[toolBar release];
	

	
	[self toggleControls];
	
	[super viewDidLoad];
}










- (void)toggleControls
{
	float alpha = 1.0f;
	if (navigationBar.alpha > 0) {
		alpha = 0.0f;
		[hideControlsTimer invalidate];
	} else {
		hideControlsTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(hideControls:) userInfo:nil repeats:NO];
	}

	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	navigationBar.alpha = alpha;
	toolBar.alpha = alpha;
	[UIView commitAnimations];
}




- (void)hideControls:(NSTimer*)aTimer
{
	if (navigationBar.alpha > 0) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationDuration:0.2];
		navigationBar.alpha = 0;
		toolBar.alpha = 0;
		[UIView commitAnimations];
	}
}


- (IBAction)closeFile
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}










- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - 25, (self.view.frame.size.height / 2) - 25, 50, 50)];
	activityIndicator.activityIndicatorViewStyle = style;
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[activityIndicator release];
}


- (void)hideActivityIndicator
{
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	self.activityIndicator = nil;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



@end
