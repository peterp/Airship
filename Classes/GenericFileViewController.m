//
//  FileViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "GenericFileViewController.h"


@implementation GenericFileViewController

@synthesize navigationBar;
@synthesize toolbar;
@synthesize activityIndicator;
@synthesize storageItem;

- (void)dealloc;
{
	self.navigationBar = nil;
	self.toolbar = nil;
	self.activityIndicator = nil;
	self.storageItem = nil;
	
	[super dealloc];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
			self.wantsFullScreenLayout = YES;
    }
    return self;
}


- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	

	// NavigationBar
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
	navigationBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
	
	// NavigationBar Item
	UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
	UILabel *titleMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 190, 18)];
	titleMainLabel.tag = 1001;
	titleMainLabel.text = storageItem.name;
	titleMainLabel.textColor = [UIColor whiteColor];
	UILabel *titleMetaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 190, 18)];
  titleMetaLabel.tag = 1002;
	titleMetaLabel.text = @"";
	titleMetaLabel.textColor = [UIColor lightGrayColor];
	titleMainLabel.backgroundColor = titleMetaLabel.backgroundColor = [UIColor clearColor];
	titleMainLabel.textAlignment = titleMetaLabel.textAlignment = UITextAlignmentCenter;
	titleMainLabel.font = titleMetaLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	[titleView addSubview:titleMainLabel];
	[titleMainLabel release];
	[titleView addSubview:titleMetaLabel];
	[titleMetaLabel release];
	navigationItem.titleView = titleView;
	
	// done button
	UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(unloadViewController)];
	navigationItem.leftBarButtonItem = doneBarButtonItem;
	[doneBarButtonItem release];
	
	// activity indicator
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator startAnimating];
	[activityIndicator release];
	navigationItem.rightBarButtonItem = activityBarButtonItem;
	[activityBarButtonItem release];


	[navigationBar pushNavigationItem:navigationItem animated:NO];
	[navigationItem release];
	[self.view addSubview:navigationBar];
	[navigationBar release];


	
	
	// Toolbar
	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480 - 44, 320, 44)];
	toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
	[self.view addSubview:toolbar];
	[toolbar release];
	
	
	self.toolbar.barStyle = self.navigationBar.barStyle = UIBarStyleBlack;
	self.toolbar.translucent = self.navigationBar.translucent = YES;

	
	
	
	[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:4];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	return YES;
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








- (void)toggleBarsVisibilty;
{
	if (navigationBar.hidden == YES) {
		
		navigationBar.alpha = toolbar.alpha = 0;
		navigationBar.hidden = toolbar.hidden = NO;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
		navigationBar.alpha = toolbar.alpha = 1;
		[UIView commitAnimations];
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];

		[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:4];
	} else {
		// hide the toolbars
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		navigationBar.hidden = toolbar.hidden = YES;
		// cancel the selector.
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBarsAfterDelay) object:nil];
	}
}


- (void)hideBarsAfterDelay;
{
	// Don't hide if we're still loading...
	if (self.activityIndicator == nil) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		navigationBar.hidden = toolbar.hidden = YES;
	} else {
		[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:1];
	}
}




- (IBAction)unloadViewController;
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBarsAfterDelay) object:nil];

	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}



@end
