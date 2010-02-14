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
@synthesize activityIndicator;


@synthesize toolbar;
@synthesize systemActionBarButtonItem;
@synthesize paginateLeftBarButtonItem;
@synthesize paginateRightBarButtonItem;
@synthesize deleteBarButtonItem;





@synthesize fileView;
@synthesize capturedFileViewImage;





- (void)dealloc;
{
	self.delegate = nil;
	self.file = nil;
	
	
	self.navigationBar = nil;
	self.activityIndicator = nil;

	self.toolbar = nil;
	self.systemActionBarButtonItem = nil;
	self.paginateLeftBarButtonItem = nil;
	self.paginateRightBarButtonItem = nil;
	self.deleteBarButtonItem = nil;
	
	
	
	
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
	self.navigationBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	navigationBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(unloadViewController)];	
	
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.hidesWhenStopped = YES;
	UIBarButtonItem *activityIndicatorBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	
	UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[navigationBar setItems:[NSArray arrayWithObjects:doneBarButtonItem, flexibleSpaceBarButtonItem, activityIndicatorBarButtonItem, nil]];
	[doneBarButtonItem release];
	[activityIndicatorBarButtonItem release];
		
	titleViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
	titleViewLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleViewLabel.backgroundColor = [UIColor clearColor];
	titleViewLabel.textAlignment = UITextAlignmentCenter;
	titleViewLabel.font = [UIFont boldSystemFontOfSize:13];
	titleViewLabel.textColor = [UIColor whiteColor];
	titleViewLabel.shadowColor = [UIColor blackColor];
	titleViewLabel.shadowOffset = CGSizeMake(2, 2);
	[navigationBar addSubview:titleViewLabel];
	[titleViewLabel release];
	
	
	
	[self.view addSubview:navigationBar];
	[navigationBar release];
	
	
	// Toolbar
	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	
	self.systemActionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
	self.paginateLeftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(paginationWasPushed:)];
	paginateLeftBarButtonItem.tag = 2001;
	self.paginateRightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(paginationWasPushed:)];
	paginateRightBarButtonItem.tag = 2002;
	self.deleteBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDeleteModalToolbar)];
	
	[toolbar setItems:[NSArray arrayWithObjects:systemActionBarButtonItem, flexibleSpaceBarButtonItem, paginateLeftBarButtonItem, flexibleSpaceBarButtonItem, paginateRightBarButtonItem, flexibleSpaceBarButtonItem, deleteBarButtonItem, nil]];
	
	[systemActionBarButtonItem release];
	[paginateLeftBarButtonItem release];
	[paginateRightBarButtonItem release];
	[deleteBarButtonItem release];
	[flexibleSpaceBarButtonItem release];
	
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
	if ([self.delegate respondsToSelector:@selector(fileViewControllerDidFinish:)]) {
		[self.delegate fileViewControllerDidFinish:self];
	}
}


- (void)paginationWasPushed:(id)sender;
{
	if ([self.delegate respondsToSelector:@selector(fileViewControllerDidPaginate:toNextFile:)]) {
		
		UIView *item = (UIView *)sender;
		// have to figure out which "arrow" was pushed here.
		fileViewAnimationLeft = item.tag == 2001 ? NO : YES;
		[self.delegate fileViewControllerDidPaginate:self toNextFile:item.tag == 2001 ? NO : YES];
	}
	
}

- (void)setFileViewAnimationLeft:(BOOL)YesOrNo;
{
	fileViewAnimationLeft = YesOrNo;
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
		
	
		
		// disable the toolbar buttons during animation...

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


//		// Reposition fileView, above or below the main view's frame.
//		CGRect fileViewRect = fileView.frame;
//		fileViewRect.origin.y = (fileViewAnimationDown) ? fileViewRect.size.height : (fileViewRect.size.height * -1);
//		fileView.frame = fileViewRect;
//		[self.view insertSubview:fileView atIndex:0];
//		[fileView release];
		
		// Reposition the new FileView To the Left, or Right, of the CapturedFileViewImage;
		CGRect fileViewRect = fileView.frame;
		fileViewRect.origin.x = fileViewAnimationLeft ? fileViewRect.size.width : (fileViewRect.size.width * -1);
		fileView.frame = fileViewRect;
		[self.view insertSubview:fileView atIndex:0];
		[fileView release];
		
		
		
		
		
		
		// Animate
		[UIView beginAnimations:@"displayFileViewAnimated" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDidStopSelector:@selector(displayFileViewAnimatedDidFinish)];
		
		// Reposition Captured FileView.
		CGRect capturedFileViewImageRect = capturedFileViewImage.frame;
		capturedFileViewImageRect.origin.x = (fileViewAnimationLeft) ? self.view.bounds.size.width * -1 : self.view.bounds.size.width;
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



#pragma mark -
#pragma mark DELETE

- (void)showDeleteModalToolbar;
{
	[self showModalToolbar];
	
	UIButton *deleteFileButton = [UIButton buttonWithType:UIButtonTypeCustom];	
	deleteFileButton.frame = CGRectMake(20, 20, self.view.bounds.size.width - 40, 46);
	[deleteFileButton setBackgroundImage:[[UIImage imageNamed:@"ui_buttonBigRed.png"] stretchableImageWithLeftCapWidth:150.0 topCapHeight:0.0] forState:UIControlStateNormal];
	deleteFileButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[deleteFileButton setTitle:@"Delete" forState:UIControlStateNormal];
	deleteFileButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
	deleteFileButton.backgroundColor = [UIColor clearColor];
	[deleteFileButton addTarget:self action:@selector(deleteFile) forControlEvents:UIControlEventTouchUpInside];
	[modalToolbar addSubview:deleteFileButton];
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.frame = CGRectMake(20, 90, self.view.bounds.size.width - 40, 46);
	[cancelButton setBackgroundImage:[[UIImage imageNamed:@"ui_buttonBigBlack.png"] stretchableImageWithLeftCapWidth:150.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
	cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	cancelButton.backgroundColor = [UIColor clearColor];
	[cancelButton addTarget:self action:@selector(hideModalToolbar) forControlEvents:UIControlEventTouchUpInside];
	[modalToolbar addSubview:cancelButton];
}


- (void)deleteFile;
{
	// use this method to "shift" to the next file.
	if ([self.delegate respondsToSelector:@selector(fileViewControllerDidDeleteFile:)]) {
		[self.delegate fileViewControllerDidDeleteFile:self];
	}
	// hide the toolbar, cleanup time.
	[self hideModalToolbar];
}


- (void)showModalToolbar;
{
	
	// interstitial.
	modalBackground = [[UIView alloc] initWithFrame:self.view.bounds];
	modalBackground.backgroundColor = [UIColor blackColor];
	modalBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	modalBackground.alpha = 0;
	[self.view addSubview:modalBackground];
	[modalBackground release];
	
	modalToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 154)];
	modalToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	modalToolbar.barStyle = UIBarStyleBlackTranslucent;
	[self.view addSubview:modalToolbar];
	[modalToolbar release];
	
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	
	modalToolbar.frame = CGRectMake(0, self.view.bounds.size.height - 154, self.view.bounds.size.width, 154);
	toolbar.alpha = 0;
	modalBackground.alpha = 0.4;
	
	[UIView commitAnimations];
}


- (void)hideModalToolbarAnimationDone;
{
	[modalBackground removeFromSuperview];
	[modalToolbar removeFromSuperview];
}

- (void)hideModalToolbar;
{
	[UIView beginAnimations:@"hideModalToolbar" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideModalToolbarAnimationDone)];
	
	modalBackground.alpha = 0;
	modalToolbar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 154);
	toolbar.alpha = 1;
	
	[UIView commitAnimations];	
}











@end
