//
//  StorageItemViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/29.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileViewController.h"
#import "File.h";




@implementation FileViewController

@synthesize delegate;
@synthesize file;

@synthesize navigationBar;
@synthesize paginationSegmentControl;

@synthesize toolbar;
@synthesize activityIndicator;




// Image
@synthesize imageScrollView;
@synthesize imageView;




- (void)dealloc;
{
	self.delegate = nil;
	self.file = nil;
	
	
	self.navigationBar = nil;
	self.paginationSegmentControl = nil;

	self.toolbar = nil;
	self.activityIndicator = nil;
	
	
	
	// Image
	self.imageScrollView = nil;
	self.imageView = nil;
	

	[super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{	
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.wantsFullScreenLayout = YES;
		self.view.backgroundColor = [UIColor blackColor];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
  }
  return self;
}


- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	// NavigationBar
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
	navigationBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	// NavigationBar + NavigationItem
	UINavigationItem *navigationItem = [[UINavigationItem alloc] init];

	// NavigationBar + NavigationItem + doneBarButtonItem
	UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(unloadViewController)];
	navigationItem.leftBarButtonItem = doneBarButtonItem;
	[doneBarButtonItem release];
	
	// NavigationBar + NavigationItem + paginationSegmentControl
	self.paginationSegmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"-", @"+", nil]];
	paginationSegmentControl.frame = CGRectMake(0, 0, 90, 30);
	paginationSegmentControl.momentary = YES;
	paginationSegmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[paginationSegmentControl addTarget:self action:@selector(paginationSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *paginationBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:paginationSegmentControl];
	[paginationSegmentControl release];
	navigationItem.rightBarButtonItem = paginationBarButtonItem;
	[paginationBarButtonItem release];
	
	// NavigationBar + NavigationItem + titleView
	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigationBar.frame.size.width - (self.paginationSegmentControl.frame.size.width * 2), navigationBar.frame.size.height)];
	titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

	// NavigationBar + NavigationItem + titleView + titleMainLabel
	UILabel *titleMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, navigationBar.frame.size.width - (self.paginationSegmentControl.frame.size.width * 2), navigationBar.frame.size.height / 2)];
	titleMainLabel.tag = 1001;
	titleMainLabel.textColor = [UIColor whiteColor];
	titleMainLabel.textAlignment = UITextAlignmentCenter;
	titleMainLabel.backgroundColor = [UIColor clearColor];
	titleMainLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	[titleView addSubview:titleMainLabel];
	[titleMainLabel release];

	// NavigationBar + NavigationItem + titleView + titleMetaLabel
	UILabel *titleMetaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (navigationBar.frame.size.height / 2) - 4, navigationBar.frame.size.width - (self.paginationSegmentControl.frame.size.width * 2), navigationBar.frame.size.height / 2)];
	titleMetaLabel.tag = 1002;
	titleMetaLabel.textColor = [UIColor grayColor];
	titleMetaLabel.textAlignment = UITextAlignmentCenter;
	titleMetaLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
	titleMetaLabel.backgroundColor = [UIColor clearColor];
	[titleView addSubview:titleMetaLabel];
	[titleMetaLabel release];
	navigationItem.titleView = titleView;
	[titleView release];
	
	[navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
	[navigationItem release];
	[self.view addSubview:navigationBar];
	[navigationBar release];
	




	
	
	
	
	
	// Toolbar
	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	[self.view addSubview:toolbar];

	
	// Toolbar + ActivityIndicator
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.hidesWhenStopped = YES;
	[activityIndicator startAnimating];
	
	UIBarButtonItem *activityIndicatorBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator release];
	
	
	[toolbar setItems:[NSArray arrayWithObjects:activityIndicatorBarButtonItem, nil] animated:YES];
	[activityIndicatorBarButtonItem release];
	[toolbar release];
	
	
//	[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:4];
//	[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:8];

	
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	return YES;
}


- (void)didReceiveMemoryWarning;
{
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload;
{
}









- (void)setFile:(File *)aFile;
{
	// check the views, which one will it be placed inside?
	
	
	// ok, load it up!
	
	




//	// Not the same file, unload and reload
//	if (self.file.kind != aFile.kind) {
//	
//	
//		// remove
//		if (self.file.kind == FILE_KIND_IMAGE) {
//		
//
//
//			
//			
//			
//			
//		}
//	}
//	
//	// Set the file.
//	file = aFile;
//	if (self.file.kind == FILE_KIND_IMAGE) {
//		NSLog(@"image is loaded.");
//		[self loadImage];
//	}
//
	
	
	
	UILabel *titleMainLabel = (UILabel *)[navigationBar.topItem.titleView viewWithTag:1001];
	titleMainLabel.text = file.name;
	UILabel *titleMetaLabel = (UILabel *)[navigationBar.topItem.titleView viewWithTag:1002];
	titleMetaLabel.text = [file kindDescription];
	
	// Now we actually need to load the file...
}
















#pragma mark -
#pragma mark Toolbar methods

- (void)unloadViewController;
{

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBarsAfterDelay) object:nil];
	
	if ([self.delegate respondsToSelector:@selector(fileViewControllerDidFinish:)]) {
		[self.delegate fileViewControllerDidFinish:self];
	}
}

- (void)paginationSegmentControlChanged:(id)sender;
{

	if ([self.delegate respondsToSelector:@selector(fileViewControllerDidPaginate:toNextFile:)]) {
		UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
		[self.delegate fileViewControllerDidPaginate:self toNextFile:segmentedControl.selectedSegmentIndex ? YES : NO];
	}
}

- (void)setBarsHidden;
{
	self.navigationBar.hidden = YES;
	self.toolbar.hidden = YES;
}

- (void)toggleBarsVisibilty;
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
	[UIView setAnimationDelegate:self];

	if (self.toolbar.hidden && self.navigationBar.hidden) {
		// SHOW
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
		self.navigationBar.hidden = NO;
		self.toolbar.hidden = NO;
		self.navigationBar.frame = CGRectMake(0, 20, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
		self.toolbar.frame = CGRectMake(0, self.toolbar.frame.origin.y - self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
	} else {
		// HIDE
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
		self.navigationBar.frame = CGRectMake(0, (self.navigationBar.frame.size.height + 20) * -1, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
		self.toolbar.frame = CGRectMake(0, self.toolbar.frame.origin.y + self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
		[UIView setAnimationDidStopSelector:@selector(setBarsHidden)];
	}

	[UIView commitAnimations];
}


- (void)hideBarsAfterDelay;
{
	// if they have already been hidden, then just skip this.
	if (self.toolbar.hidden == NO && self.navigationBar.hidden == NO) {
	
		// only hide if we're not loading...
		if (self.activityIndicator.hidden) {
			[self toggleBarsVisibilty];
		} else {
			[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:1];
		}
	}
}











- (void)loadImage;
{
	if (self.imageScrollView == nil) {
		self.imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
		//self.imageScrollView.backgroundColor = [UIColor grayColor];
		self.imageScrollView.delegate = self;
		self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.imageScrollView.bouncesZoom = YES;
		self.imageScrollView.bounces = YES;
		self.imageScrollView.clipsToBounds = YES;
		self.imageScrollView.showsVerticalScrollIndicator = NO;
		self.imageScrollView.showsHorizontalScrollIndicator = NO;
		[self.view insertSubview:self.imageScrollView atIndex:0];
		[self.imageScrollView release];
	} else {
		// remove image view.
		[self.imageView removeFromSuperview];
		self.imageView = nil;
	}

	// Load the image!
	
//	NSData *imageData = [NSData dataWithContentsOfFile:fileLocation];


	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.file.absolutePath]];
	NSLog(@"on startup: %d", [self.imageView retainCount]);
	[self.imageScrollView addSubview:imageView];
	NSLog(@"on adding to view: %d", [self.imageView retainCount]);
	[imageView release];
	NSLog(@"on release: %d", [self.imageView retainCount]);
	
	// Cache image's original dimensions
	imageWidth = imageView.frame.size.width;
	imageHeight = imageView.frame.size.height;
  // calculate minimum scale to perfectly fit image width, and begin at that scale
	float minimumZoomScale = imageWidth > imageHeight ? self.imageScrollView.frame.size.width / imageWidth : self.imageScrollView.frame.size.height / imageHeight;
	self.imageScrollView.minimumZoomScale = minimumZoomScale;
	self.imageScrollView.zoomScale = minimumZoomScale;
	self.imageScrollView.maximumZoomScale = 2.5;
	[self viewForZoomingInScrollView:self.imageScrollView];
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView;
{
	// If the image is still smaller than the actual size of the frame, keep it in the center.
	if (self.imageView.frame.size.height < self.imageScrollView.frame.size.height) {
		// determine the center of the frame
		CGPoint p = self.imageView.center;
		self.imageView.center = CGPointMake(p.x, self.imageScrollView.frame.size.height / 2);
	}
	
	if (self.imageView.frame.size.width < self.imageScrollView.frame.size.width) {
		// determine the center of the frame
		CGPoint p = self.imageView.center;
		self.imageView.center = CGPointMake(self.imageScrollView.frame.size.width / 2, p.y);
	}
	return self.imageView;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (self.imageView != nil) {
		float minimumZoomScale = imageWidth > imageHeight ? self.imageScrollView.frame.size.width / imageWidth : self.imageScrollView.frame.size.height / imageHeight;
		self.imageScrollView.maximumZoomScale = 2.5;
		self.imageScrollView.minimumZoomScale = minimumZoomScale;
		self.imageScrollView.zoomScale = minimumZoomScale;
		[self viewForZoomingInScrollView:self.imageScrollView];
	}
}





@end
