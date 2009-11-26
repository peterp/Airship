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

#import "FileAudioView.h";
#import "FileDocumentView.h"
#import "FileImageView.h";
#import "FileVideoView.h"
#import "FileUnknownView.h";





@implementation FileViewController

@synthesize delegate;
@synthesize file;

@synthesize navigationBar;
@synthesize paginationSegmentControl;

@synthesize toolbar;
@synthesize activityIndicator;



@synthesize fileView;
@synthesize capturedFileViewImage;





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
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	
	
	// NavigationBar
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
	navigationBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	// NavigationBar + NavigationItem
	UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
	
	
	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 200, 44)];
	titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 44)];
	titleViewLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleViewLabel.backgroundColor = [UIColor clearColor];
	titleViewLabel.textAlignment = UITextAlignmentCenter;
	titleViewLabel.font = [UIFont boldSystemFontOfSize:13];
	titleViewLabel.textColor = [UIColor whiteColor];
	titleViewLabel.shadowColor = [UIColor blackColor];
	titleViewLabel.shadowOffset = CGSizeMake(2, 2);
	[titleView addSubview:titleViewLabel];
	[titleViewLabel release];
	
	navigationItem.titleView = titleView;
	[titleView release];

	
	

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
	
	// star? maybe...
	// email
	// revert (if the file is unknown).
	
	// delete
	// activity indicator.

	
	// Toolbar + ActivityIndicator
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.hidesWhenStopped = YES;
	UIBarButtonItem *activityIndicatorBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator release];
	
	// Toolbar + Email
	
	
	// Toolbar + Revert
	
	
	// Toolbar + Delete
	
	
	
	
	[toolbar setItems:[NSArray arrayWithObjects:activityIndicatorBarButtonItem, nil] animated:YES];
	[activityIndicatorBarButtonItem release];

	[self.view addSubview:toolbar];
	[toolbar release];
	
}

- (void)didReceiveMemoryWarning;
{
	[super didReceiveMemoryWarning];
}


- (void)viewWillDisappear:(BOOL)animated;
{
	[fileView removeFromSuperview];
}



#pragma mark -
#pragma mark Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	// Support all orientations.
	return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	// Image is a special case when it comes to orientation, so things 
	// need to be reset, so are we displaying an image?
	if ([fileView isKindOfClass:[FileImageView class]]) {
		[fileView didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	}
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

- (void)paginationSegmentControlChanged:(UISegmentedControl *)segmentedControl;
{

	if ([self.delegate respondsToSelector:@selector(fileViewControllerDidPaginate:toNextFile:)]) {

		fileViewAnimationDown = segmentedControl.selectedSegmentIndex ? YES : NO;
		[self.delegate fileViewControllerDidPaginate:self toNextFile:segmentedControl.selectedSegmentIndex ? YES : NO];
	}
}










#pragma mark -
#pragma mark Switching file methods


- (void)setFile:(File *)aFile;
{
	titleViewLabel.text = aFile.name;
	file = aFile;
}



- (void)displayFileViewAnimatedDidFinish;
{
	[capturedFileViewImage removeFromSuperview];
	self.capturedFileViewImage = nil;
	
	[fileView loadFileAtPath:file.absolutePath];
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


		// Reposition fileView, above or below the main view's frame.
		CGRect fileViewRect = fileView.frame;
		fileViewRect.origin.y = (fileViewAnimationDown) ? fileViewRect.size.height : (fileViewRect.size.height * -1);
		fileView.frame = fileViewRect;
		[self.view insertSubview:fileView atIndex:0];
		[fileView release];
		
		// Animate
		[UIView beginAnimations:@"displayFileViewAnimated" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDidStopSelector:@selector(displayFileViewAnimatedDidFinish)];
		
		// Reposition image.
		CGRect capturedFileViewImageRect = capturedFileViewImage.frame;
		capturedFileViewImageRect.origin.y = (fileViewAnimationDown) ? self.view.frame.size.height * -1 : self.view.frame.size.height;
		capturedFileViewImage.frame = capturedFileViewImageRect;
		
		fileView.frame = self.view.bounds;
		
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
	[activityIndicator startAnimating];

	switch (kind) {
		
		case FILE_KIND_AUDIO:
			self.fileView = [[FileAudioView alloc] initWithFrame:self.view.bounds];
			break;
	
	
		case FILE_KIND_DOCUMENT:
			self.fileView = [[FileDocumentView alloc] initWithFrame:self.view.bounds];
			break;

		case FILE_KIND_IMAGE:
			self.fileView = [[FileImageView alloc] initWithFrame:self.view.bounds];
			break;
			
		case FILE_KIND_VIDEO:
			self.fileView = [[FileVideoView alloc] initWithFrame:self.view.bounds];
			break;

		case FILE_KIND_UNKNOWN:
			self.fileView = [[FileUnknownView alloc] initWithFrame:self.view.bounds];
		default:
			break;
	}
	

	fileView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	fileView.delegate = self;
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





#pragma mark -
#pragma mark FileView delegate methods




- (void)fileViewDidOpenFileAs:(int)kind;
{
	[self displayFileViewWithKind:kind animated:NO];
	// add a little button to revert back to "unknown."
}


- (void)fileViewDidStartLoading;
{
	[activityIndicator startAnimating];
}

- (void)fileViewDidStopLoading;
{
	[activityIndicator stopAnimating];
}


- (void)setBarsHidden;
{
	self.navigationBar.hidden = YES;
	self.toolbar.hidden = YES;
}

- (void)fileViewDidToggleToolbars;
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


- (BOOL)fileViewToolbarsHidden;
{
	return self.navigationBar.hidden == YES && self.toolbar.hidden == YES;
}






//
//- (void)hideBarsAfterDelay;
//{
//	// if they have already been hidden, then just skip this.
//	if (self.toolbar.hidden == NO && self.navigationBar.hidden == NO) {
//	
//		// only hide if we're not loading...
//		if (self.activityIndicator.hidden) {
//			[self fileViewDidToggleToolbars];
//		} else {
//			[self performSelector:@selector(hideBarsAfterDelay) withObject:nil afterDelay:1];
//		}
//	}
//}









@end
