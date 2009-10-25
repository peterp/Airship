//
//  FileViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "GenericFileViewController.h"


@implementation GenericFileViewController

//@synthesize navigationBar;
//@synthesize toolbar;

@synthesize delegate;

@synthesize activityIndicator;
@synthesize storageItem;


- (void)dealloc;
{
	NSLog(@"we unload... yeah");

	self.delegate = nil;
	
//	self.navigationBar = nil;
//	self.toolbar = nil;
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

	NSLog(@"i'm loading HERE!");

	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;


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
	self.navigationItem.titleView = titleView;


	// Close button
	UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(unloadViewController)];
	self.navigationItem.leftBarButtonItem = closeBarButtonItem;
	[closeBarButtonItem release];
	
	// Previous and Next Segmented Controls
	UISegmentedControl *paginationSegmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"P", @"N", nil]];
	paginationSegmentControl.momentary = YES;
	paginationSegmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[paginationSegmentControl addTarget:self action:@selector(paginationSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *paginationBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:paginationSegmentControl];
	[paginationSegmentControl release];
	self.navigationItem.rightBarButtonItem = paginationBarButtonItem;
	
	
	
	
//	
//	// Previous next items
//	UIBarButtonItem *nextBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(loadNextFile)];
//	navigationItem.rightBarButtonItem = nextBarButtonItem;
//	[nextBarButtonItem release];
//	
//
//
//	[navigationBar pushNavigationItem:navigationItem animated:NO];
//	[navigationItem release];
//	[self.view addSubview:navigationBar];
//	[navigationBar release];
//
//
//	
//	
//	// Toolbar
//	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480 - 44, 320, 44)];
//	toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
//	
//	
//	// activity indicator
//	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//	UIBarButtonItem *activityBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
//	[activityIndicator startAnimating];
//	[activityIndicator release];
//	
//	toolbar.items = [NSArray arrayWithObjects:activityBarButtonItem, nil];
//	[activityBarButtonItem release];
//	
//	[self.view addSubview:toolbar];
//	[toolbar release];
//	
//	
//	self.toolbar.barStyle = self.navigationBar.barStyle = UIBarStyleBlack;
//	self.toolbar.translucent = self.navigationBar.translucent = YES;
//
//	
//	
//	
//	[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:4];
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
//	if (navigationBar.hidden == YES) {
//		
//		navigationBar.alpha = toolbar.alpha = 0;
//		navigationBar.hidden = toolbar.hidden = NO;
//		
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
//		navigationBar.alpha = toolbar.alpha = 1;
//		[UIView commitAnimations];
//		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
//
//		[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:4];
//	} else {
//		// hide the toolbars
//		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
//		navigationBar.hidden = toolbar.hidden = YES;
//		// cancel the selector.
//		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBarsAfterDelay) object:nil];
//	}
}


- (void)hideBarsAfterDelay;
{
//	// Don't hide if we're still loading...
//	if (self.activityIndicator == nil) {
//		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
//		navigationBar.hidden = toolbar.hidden = YES;
//	} else {
//		[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:1];
//	}
}




- (void)unloadViewController;
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBarsAfterDelay) object:nil];
	
	if ([self.delegate respondsToSelector:@selector(genericFileViewControllerDidFinish:)]) {
		[self.delegate genericFileViewControllerDidFinish:self];
	}
}

- (void)paginationSegmentControlChanged:(id)sender;
{
	if ([self.delegate respondsToSelector:@selector(genericFileViewControllerDidPaginate:toNextFile:)]) {
		UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
		[self.delegate genericFileViewControllerDidPaginate:self.navigationController toNextFile:segmentedControl.selectedSegmentIndex ? YES : NO];
	}
}



@end
