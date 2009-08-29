//
//  FileController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileController.h"


@implementation FileController


@synthesize navigationBar, toolBar, activityIndicator;
@synthesize directoryItem;


- (void)dealloc
{
	self.activityIndicator = nil;
	self.navigationBar = nil;
	self.toolBar = nil;
	
	self.directoryItem = nil;
	
	
	[super dealloc];
}


- (void)viewDidLoad 
{

	// our lovely navigationbar
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

	// toolbar
	self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
	toolBar.barStyle = UIBarStyleBlackTranslucent;
	toolBar.alpha = 0;
	[self.view addSubview:toolBar];
	[toolBar release];
	

	
	[self toggleToolBarsHidden];


	
	[super viewDidLoad];
}







# pragma mark UINavigationBar and UIToolBar

- (void)toggleToolBarsHidden
{
	if (navigationBar.alpha > 0) {
		// hide tools bars.
		[self setToolBarsHidden:YES];
		[hideToolBarsTimer invalidate];
	} else {
		// show tools bars
		[self setToolBarsHidden:NO];
		hideToolBarsTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideToolBars:) userInfo:nil repeats:NO];
	}
}

- (void)hideToolBars:(NSTimer *)aTimer
{
	[self setToolBarsHidden:YES];
}


- (void)setToolBarsHidden:(BOOL)b
{
	[UIView beginAnimations:nil context:self];
	[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
	navigationBar.alpha = b ? 0 : 1;
	toolBar.alpha = b ? 0 : 1;
	[UIView commitAnimations];
}







- (IBAction)closeFile
{
	[hideToolBarsTimer invalidate];
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}






- (void)showActivityIndicator
{
}



- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	navigationBar.topItem.rightBarButtonItem = activityIndicator;
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




@end

