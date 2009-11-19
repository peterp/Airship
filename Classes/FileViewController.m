//
//  StorageItemViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/29.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FileViewController.h"


#import "File.h";

// Document
#import "TapDetectingWebView.h"

#import "FileImageView.h";



@implementation FileViewController

@synthesize delegate;
@synthesize file;

@synthesize navigationBar;
@synthesize paginationSegmentControl;

@synthesize toolbar;
@synthesize activityIndicator;



@synthesize fileView;
@synthesize capturedFileViewImage;


// Document
@synthesize documentWebView;
// Image





- (void)dealloc;
{
	self.delegate = nil;
	self.file = nil;
	
	
	self.navigationBar = nil;
	self.paginationSegmentControl = nil;

	self.toolbar = nil;
	self.activityIndicator = nil;
	
	
	self.fileView = nil;
	self.capturedFileViewImage = nil;
	
	// Document
	self.documentWebView = nil;



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
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
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
	
	[navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
	[navigationItem release];
	[self.view addSubview:navigationBar];
	[navigationBar release];
	
	
	// Toolbar
	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
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
		
		fileViewAnimationDown = segmentedControl.selectedSegmentIndex ? YES : NO;
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
		self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height - self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
	} else {
		// HIDE
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
		self.navigationBar.frame = CGRectMake(0, (self.navigationBar.frame.size.height + 20) * -1, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
		self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height + self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
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









- (void)setFile:(File *)aFile;
{
	self.navigationBar.topItem.title = aFile.name;
	file = aFile;
}



- (void)displayFileViewAnimatedDidFinish;
{
	[capturedFileViewImage removeFromSuperview];
	self.capturedFileViewImage = nil;
}

- (void)displayFileViewWithKind:(int)kind animated:(BOOL)animated;
{
	
	if (animated == YES) {
	

		// capture fileView
		self.capturedFileViewImage = [[UIImageView alloc] initWithImage:[self captureView:self.fileView]];
		capturedFileViewImage.frame = fileView.frame;
		[self.view insertSubview:capturedFileViewImage aboveSubview:fileView];
		[capturedFileViewImage release];
		
		// Remove fileView
		[fileView removeFromSuperview];
		self.fileView = nil;
		
		// Create
		[self setFileViewWithKind:kind];
		[fileView loadFileAtPath:file.absolutePath];
		// Adjust Frame.
		CGRect fileViewRect = fileView.frame;
		fileViewRect.origin.y = (fileViewAnimationDown) ? self.view.frame.size.height : (self.view.frame.size.height * -1);
		fileView.frame = fileViewRect;
		[self.view insertSubview:fileView atIndex:0];
		[fileView release];
		
		// Animate
		[UIView beginAnimations:@"displayFileViewAnimated" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDidStopSelector:@selector(displayFileViewAnimatedDidFinish)];
		
		
		CGRect capturedFileViewImageRect = capturedFileViewImage.frame;
		capturedFileViewImageRect.origin.y = (fileViewAnimationDown) ? self.view.frame.size.height * -1 : self.view.frame.size.height;
		capturedFileViewImage.frame = capturedFileViewImageRect;
		
		fileView.frame = self.view.frame;
		
		[UIView commitAnimations];
		
		
	} else {
	
		[fileView removeFromSuperview];
		self.fileView = nil;
		
		[self setFileViewWithKind:kind];
		[fileView loadFileAtPath:file.absolutePath];
		[self.view insertSubview:fileView atIndex:0];
		[fileView release];
	}
}

- (void)setFileViewWithKind:(int)kind;
{
	switch (kind) {
		case FILE_KIND_IMAGE:
			self.fileView = [[FileImageView alloc] initWithFrame:self.view.frame];
			break;
		default:
			break;
	}
	
	fileView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	fileView.frame = self.view.frame;
}



- (UIImage *)captureView:(UIView *)view;
{
	CGRect viewRect = view.frame;
	UIGraphicsBeginImageContext(viewRect.size);

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  [[UIColor blackColor] set];
  CGContextFillRect(ctx, viewRect);
	
	[view.layer renderInContext:ctx];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return newImage;
}

























//
//
//
//
//
//
//
//
//#pragma mark -
//#pragma mark DOCUMENTS
//
//- (void)loadDocumentFile;
//{
//	if (self.documentWebView == nil) {
//		self.documentWebView = [[TapDetectingWebView alloc] initWithFrame:self.view.bounds];
//		documentWebView.delegate = self;
//		documentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//		documentWebView.scalesPageToFit = YES;
//		[self.view insertSubview:documentWebView atIndex:0];
//		[documentWebView release];
//	}
//	
//	[documentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.file.absolutePath]]];
//}
//
//- (void)tapDetectingWebViewGotSingleTap:(TapDetectingWebView *)aWebView;
//{
//	[self toggleBarsVisibilty];
//}
//
//
//- (void)webViewDidStartLoad:(UIWebView *)aWebView;
//{
//	self.activityIndicator.hidden = NO;
//	[self.activityIndicator startAnimating];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)aWebView;
//{
//	[self.activityIndicator stopAnimating];
//}
//
//#pragma mark -
//#pragma mark IMAGES
//
//- (void)loadImageFile;
//{
//}
//
//
//
//
//
//#pragma mark -
//#pragma mark UNKNOWN
//
//
//- (void)openAsDocumentFile;
//{
//	[self unloadFile];
//	[self loadDocumentFile];
//}
//
//- (void)loadUnknownFile;
//{
//	[self.activityIndicator stopAnimating];
//	
//	
//	if (self.unknownFileView == nil) {
//		self.unknownFileView = [[UIView alloc] initWithFrame:self.view.frame];
//		unknownFileView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//		unknownFileView.backgroundColor = [UIColor lightGrayColor];
//		[self.view insertSubview:unknownFileView atIndex:0];
//	}
//	
//	
//	
//	if (self.explinationLabel == nil) {
//		self.explinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.navigationBar.frame.size.height + 36, self.view.frame.size.width - 20, 80)];
//		explinationLabel.backgroundColor = [UIColor clearColor];
//		explinationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//		explinationLabel.shadowColor = [UIColor lightTextColor];
//		explinationLabel.shadowOffset = CGSizeMake(1, 1);
//		explinationLabel.numberOfLines = 0;
//		explinationLabel.font = [UIFont systemFontOfSize:16];
//		explinationLabel.textAlignment = UITextAlignmentCenter;
//		[self.unknownFileView addSubview:explinationLabel];
//		[explinationLabel release];
//	}
//	
//	self.explinationLabel.text = [NSString stringWithFormat:@"airship doesn't know how to display \"%@.\"\n\nChoose to display file as...", self.file.name];
//	
//	
//	if (self.openAudioButton == nil) {
//	}
//	
//	if (self.openDocumentButton == nil) {
//		self.openDocumentButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 64, 64)];
//		openDocumentButton.backgroundColor = [UIColor blackColor];
//		openDocumentButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//		[openDocumentButton addTarget:self action:@selector(openAsDocumentFile) forControlEvents:UIControlEventTouchUpInside];
//
//		[openDocumentButton setTitle:@"Document" forState:UIControlStateNormal];
//		[self.unknownFileView addSubview:openDocumentButton];
//		[openDocumentButton release];
//		
////				self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 7, 122, 28)];
////		[deleteButton addTarget:self action:@selector(deleteSelection) forControlEvents:UIControlEventTouchUpInside];
////		[deleteButton setBackgroundImage:[[UIImage imageNamed: @"button_red.png"] stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
////		[deleteButton setImage:[UIImage imageNamed:@"icon_trash.png"] forState:UIControlStateNormal];
////		[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
////		deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
////		[toolbar addSubview:deleteButton];
////		[deleteButton release];
//		
//
//		
//	}
//	
//	
//	
//	
////	UIView *unknownFileView = [[UIView alloc] initWithFrame:self.view.bounds];
////	unknownFileView.backgroundColor = [UIColor whiteColor];
////	unknownFileView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
////	
////	
////
////	UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 300)];
////	description.backgroundColor = [UIColor lightGrayColor];
////	description.numberOfLines = 0;
////	description.shadowColor = [UIColor whiteColor];
////	description.text = @"Airship doesn't know how to open the file <filename>.";
////	description.lineBreakMode = UILineBreakModeWordWrap;
////	
////	[unknownFileView addSubview:description];
////	[description release];
////	
////	[self.view insertSubview:unknownFileView atIndex:0];
////	[unknownFileView release];
////	
////	
////	NSLog(@"loading unknown file");

	
//}







@end
