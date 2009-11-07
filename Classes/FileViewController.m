//
//  StorageItemViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/29.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileViewController.h"
#import "File.h";

// Document
#import "TapDetectingWebView.h"
// Image
#import "TapDetectingScrollView.h"


@implementation FileViewController

@synthesize delegate;
@synthesize file;

@synthesize navigationBar;
@synthesize paginationSegmentControl;

@synthesize toolbar;
@synthesize activityIndicator;


// Document
@synthesize documentWebView;
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
	
	// Document
	self.documentWebView = nil;
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
	UIBarButtonItem *activityIndicatorBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator release];
	
	
	[toolbar setItems:[NSArray arrayWithObjects:activityIndicatorBarButtonItem, nil] animated:YES];
	[activityIndicatorBarButtonItem release];
	[toolbar release];
	
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
	if (self.file != nil && self.file.kind != aFile.kind) {
	
		// Unload the view
		switch (self.file.kind) {
			case FILE_KIND_AUDIO:
				break;
			
			case FILE_KIND_DOCUMENT:
				[self.documentWebView removeFromSuperview];
				self.documentWebView = nil;
				break;
				
			case FILE_KIND_IMAGE:
				[self.imageScrollView removeFromSuperview];
				self.imageView = nil;
				self.imageScrollView = nil;
				break;
			
			case FILE_KIND_VIDEO:
				break;
				
			default:
				break;
		}
		
	}
	
	
	file = aFile;
	[self determineFileKindAndLoad];
	
	
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
		self.toolbar.frame = CGRectMake(0, self.view.frame.size.height - self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
	} else {
		// HIDE
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
		self.navigationBar.frame = CGRectMake(0, (self.navigationBar.frame.size.height + 20) * -1, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
		self.toolbar.frame = CGRectMake(0, self.view.frame.size.height + self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
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









- (void)determineFileKindAndLoad;
{
	[self.activityIndicator startAnimating];
	
	// Unload the view
	switch (self.file.kind) {
		case FILE_KIND_AUDIO:
			break;
			
		case FILE_KIND_DOCUMENT:
			[self loadDocumentFile];
			break;
				
		case FILE_KIND_IMAGE:
			[self loadImageFile];
			break;
			
		case FILE_KIND_VIDEO:
			break;
				
		default:
			break;
	}
}








#pragma mark -
#pragma mark DOCUMENTS

- (void)loadDocumentFile;
{
	if (self.documentWebView == nil) {
		self.documentWebView = [[TapDetectingWebView alloc] initWithFrame:self.view.frame];
		documentWebView.delegate = self;
		documentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		documentWebView.scalesPageToFit = YES;
		[self.view insertSubview:documentWebView atIndex:0];
		[documentWebView release];
	}
	
	[documentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.file.absolutePath]]];
}

- (void)tapDetectingWebViewGotSingleTap:(TapDetectingWebView *)aWebView;
{
	[self toggleBarsVisibilty];
}


- (void)webViewDidStartLoad:(UIWebView *)aWebView;
{
	[self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView;
{
	[self.activityIndicator stopAnimating];
}

#pragma mark -
#pragma mark IMAGES

- (void)loadImageFile;
{
	if (self.imageScrollView == nil) {
		// Loading a "fresh" image.
		self.imageScrollView = [[TapDetectingScrollView alloc] initWithFrame:self.view.frame];
		imageScrollView.delegate = self;
		imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		imageScrollView.bouncesZoom = YES;
		imageScrollView.alwaysBounceHorizontal = YES;
		imageScrollView.alwaysBounceVertical = YES;
		imageScrollView.clipsToBounds = YES;
		imageScrollView.showsVerticalScrollIndicator = NO;
		imageScrollView.showsHorizontalScrollIndicator = NO;
		[self.view insertSubview:imageScrollView atIndex:0];
		[imageScrollView release];
	} else {
		// Loading another image
		[self.imageView removeFromSuperview];
		self.imageView = nil;
	}

	// Load the image!
	NSData *imageData = [NSData dataWithContentsOfFile:self.file.absolutePath];
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
	[self.imageScrollView addSubview:imageView];
	[imageView release];
	
	[self.activityIndicator stopAnimating];

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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
{
	if (self.imageView != nil) {
		float minimumZoomScale = imageWidth > imageHeight ? self.imageScrollView.frame.size.width / imageWidth : self.imageScrollView.frame.size.height / imageHeight;
		self.imageScrollView.maximumZoomScale = 2.5;
		self.imageScrollView.minimumZoomScale = minimumZoomScale;
		self.imageScrollView.zoomScale = minimumZoomScale;
		[self viewForZoomingInScrollView:self.imageScrollView];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	NSLog(@"hmpf.");
	[self toggleBarsVisibilty];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
	if (self.navigationBar.hidden == NO && self.toolbar.hidden == NO) {
		[self toggleBarsVisibilty];
	}
}







@end
