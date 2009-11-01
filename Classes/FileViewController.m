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
	
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 0, 44)];
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[navigationBar sizeToFit];

	UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
	[navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
	[navigationItem release];
	
	// DONE BUTTON
	UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(unloadViewController)];
	navigationBar.topItem.leftBarButtonItem = doneBarButtonItem;
	[doneBarButtonItem release];
	
	// PREV + NEXT SEGMENTED CONTROLS
	self.paginationSegmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"-", @"+", nil]];
	paginationSegmentControl.momentary = YES;
	paginationSegmentControl.frame = CGRectMake(0, 0, 90, 30);
	paginationSegmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[paginationSegmentControl addTarget:self action:@selector(paginationSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *paginationBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:paginationSegmentControl];
	[paginationSegmentControl release];
	navigationBar.topItem.rightBarButtonItem = paginationBarButtonItem;
	[paginationBarButtonItem release];
	
	
	// TITLEVIEW
	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigationBar.frame.size.width - (self.paginationSegmentControl.frame.size.width * 2), navigationBar.frame.size.height)];
	titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	UILabel *titleMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, navigationBar.frame.size.width - (self.paginationSegmentControl.frame.size.width * 2), navigationBar.frame.size.height / 2)];
	titleMainLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleMainLabel.tag = 1001;
	titleMainLabel.textColor = [UIColor whiteColor];
	titleMainLabel.textAlignment = UITextAlignmentCenter;
	titleMainLabel.backgroundColor = [UIColor clearColor];
	titleMainLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	[titleView addSubview:titleMainLabel];
	[titleMainLabel release];
	
	UILabel *titleMetaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (navigationBar.frame.size.height / 2) - 4, navigationBar.frame.size.width - (self.paginationSegmentControl.frame.size.width * 2), navigationBar.frame.size.height / 2)];
	titleMetaLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleMetaLabel.tag = 1002;
	titleMetaLabel.textColor = [UIColor grayColor];
	titleMetaLabel.textAlignment = UITextAlignmentCenter;
	titleMetaLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
	titleMetaLabel.backgroundColor = [UIColor clearColor];
	[titleView addSubview:titleMetaLabel];
	[titleMetaLabel release];


	navigationBar.topItem.titleView = titleView;
	[titleView release];
	
	



	[self.view addSubview:navigationBar];
	[navigationBar release];
	
	
	
	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 0, 44)];
	toolbar.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	[toolbar sizeToFit];
	[self.view addSubview:toolbar];
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
	// Unload the original file view...
	file = aFile;
	
	[self loadImage];
	
	UILabel *titleMainLabel = (UILabel *)[navigationBar.topItem.titleView viewWithTag:1001];
	titleMainLabel.text = file.name;
	UILabel *titleMetaLabel = (UILabel *)[navigationBar.topItem.titleView viewWithTag:1002];
	titleMetaLabel.text = [file kindDescription];
	
	// Now we actually need to load the file...
}


















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










- (void)loadImage;
{
	self.imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	//self.imageScrollView.backgroundColor = [UIColor grayColor];
	self.imageScrollView.delegate = self;
	self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.imageScrollView.bouncesZoom = YES;
	self.imageScrollView.bounces = YES;
	self.imageScrollView.showsVerticalScrollIndicator = NO;
	self.imageScrollView.showsHorizontalScrollIndicator = NO;
	[self.view insertSubview:self.imageScrollView atIndex:0];
	[self.imageScrollView release];

	// add touch-sensitive image view to the scroll view
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.file.absolutePath]];
	[self.imageScrollView addSubview:imageView];
	[self.imageView release];
	
	// Cache image's original dimensions
	imageWidth = imageView.frame.size.width;
	imageHeight = imageView.frame.size.height;
	
	NSLog(@"%f", imageWidth);
	NSLog(@"%f", imageHeight);

	
  // calculate minimum scale to perfectly fit image width, and begin at that scale
	float minimumZoomScale = imageWidth > imageHeight ? self.imageScrollView.frame.size.width / imageWidth : self.imageScrollView.frame.size.height / imageHeight;
	self.imageScrollView.minimumZoomScale = minimumZoomScale;
	self.imageScrollView.zoomScale = minimumZoomScale;
	self.imageScrollView.maximumZoomScale = 2.5;
	self.imageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
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
	float minimumZoomScale = 0;
	if (imageWidth > imageHeight) {
		minimumZoomScale = self.imageScrollView.frame.size.width / imageWidth;
		
		NSLog(@"%f / %f = %f", self.imageScrollView.bounds.size.width, imageWidth, minimumZoomScale);
	} else {
		minimumZoomScale = self.imageScrollView.frame.size.height / imageHeight;
		
		NSLog(@"%f / %f = %f", self.imageScrollView.bounds.size.height, imageHeight, minimumZoomScale);
	}
	
//	float minimumZoomScale = imageWidth > imageHeight ? self.imageScrollView.frame.size.width / imageWidth : self.imageScrollView.frame.size.height / imageHeight;
	NSLog(@"%f", minimumZoomScale);
	
	
	self.imageScrollView.maximumZoomScale = 2.5;
	self.imageScrollView.minimumZoomScale = minimumZoomScale;
	self.imageScrollView.zoomScale = minimumZoomScale;
	
	
	
	[self viewForZoomingInScrollView:self.imageScrollView];
	
	NSLog(@"w:%f, h:%f", self.imageView.frame.size.width,  self.imageView.frame.size.height);	
	
}





@end
