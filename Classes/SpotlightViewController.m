//
//  SpotlightViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "SpotlightViewController.h"
#import "File.h"

@implementation SpotlightViewController

@synthesize searchTextField;
@synthesize searchInterstitial;
@synthesize searchResultsEmptyLabel;


- (void)dealloc;
{
	self.searchTextField = nil;
	self.searchInterstitial = nil;
	self.searchResultsEmptyLabel = nil;
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = @"Search";
		self.tabBarItem.image = [UIImage imageNamed:@"dock_spotlight.png"];
	}
  return self;
}



- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	// Setup
	self.finderTableView.hidden = YES;
	self.navigationController.view.backgroundColor = [UIColor darkGrayColor];

	// Data Store
	self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Files/"];
	self.fileList = [NSMutableArray array];
	

	// Search TextField.
	self.searchTextField = [[UITextField alloc] init];
	self.searchTextField.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width - 50, 22);
	searchTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
	searchTextField.delegate = self;
	searchTextField.placeholder = @"Search";
	searchTextField.backgroundColor = [UIColor whiteColor];
	searchTextField.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
	searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	searchTextField.keyboardAppearance = UIKeyboardTypeDefault;
	searchTextField.returnKeyType = UIReturnKeySearch;
	searchTextField.enablesReturnKeyAutomatically = YES;
	self.navigationController.navigationBar.topItem.titleView = searchTextField;
	[searchTextField release];

	// Search Interstitial
	self.searchInterstitial = [[UIControl alloc] initWithFrame:CGRectZero];
	
	searchInterstitial.backgroundColor = [UIColor blackColor];
	searchInterstitial.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	searchInterstitial.hidden = YES;
	[searchInterstitial addTarget:self action:@selector(hideSearchKeyboardAndInterstitial) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationController.view insertSubview:searchInterstitial belowSubview:self.navigationController.navigationBar];
	[searchInterstitial release];

	// No Results Found Label
	self.searchResultsEmptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	searchResultsEmptyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	searchResultsEmptyLabel.hidden = YES;
	searchResultsEmptyLabel.text = @"No Results Found";
	searchResultsEmptyLabel.textAlignment = UITextAlignmentCenter;
	searchResultsEmptyLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	searchResultsEmptyLabel.backgroundColor = [UIColor clearColor];
	searchResultsEmptyLabel.textColor = [UIColor darkTextColor];
	[self.navigationController.view insertSubview:searchResultsEmptyLabel belowSubview:self.navigationController.navigationBar];
	[searchResultsEmptyLabel release];
}


- (void)viewWillAppear:(BOOL)animated;
{
	self.searchInterstitial.frame = self.finderTableView.frame;
	self.searchResultsEmptyLabel.frame = CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, 44);
	
	[finderTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[self indexPathForActiveTableView] inSection:0] animated:animated];
}


#pragma mark -
#pragma mark UITextField Helper/ Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
	// This method is called everytime the textfield is tapped.
	if ([textField.text length] <= 0) {
		[self setSearchInterstitialHidden:NO animated:YES];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	// When "Search" button is pushed.
	[searchTextField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
	// When "Clear" button is pushed.
	self.searchResultsEmptyLabel.hidden = YES;

	[self setSearchInterstitialHidden:NO animated:NO];
	return YES;
}

- (void)setSearchInterstitialHidden:(BOOL)hidden animated:(BOOL)animated;
{
	if (animated) {
		
		if (hidden) {
		
			[UIView beginAnimations:@"hideInterstitial" context:nil];
			[UIView setAnimationDuration:0.3];
			searchInterstitial.alpha = 0;
			[UIView commitAnimations];

		} else {
			// apparently this is causing a leak?
			searchInterstitial.alpha = 0;
			searchInterstitial.hidden = NO;
			[UIView beginAnimations:@"showInterstitial" context:nil];
			[UIView setAnimationDuration:0.3];
			searchInterstitial.alpha = 0.8;
			[UIView commitAnimations];
			
		}
	} else {
	 searchInterstitial.hidden = hidden;
	 
	 if (hidden = YES) {
		// reset 
		self.finderTableView.hidden = YES;
		[fileList removeAllObjects];
		[self.finderTableView reloadData];
	 }
	}
}

- (void)hideSearchKeyboardAndInterstitial;
{
	[self setSearchInterstitialHidden:YES animated:YES];
	[searchTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
	// Called everytime new text is changed in the textview.
	self.searchResultsEmptyLabel.hidden = YES;

	string = [textField.text stringByReplacingCharactersInRange:range withString:string];
	[self setSearchInterstitialHidden:([string length] <= 0 ? NO : YES) animated:NO];
	if ([string length] > 0) {
		[self filterContentForSearchText:string];
	}

	return YES;
}



- (void)filterContentForSearchText:(NSString*)searchText;
{
	searchText = [searchText lowercaseString];
	[fileList removeAllObjects];

	NSString *itemRelativePath;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:self.path];
	while (itemRelativePath = [dirEnum nextObject]) {
		NSRange range = [[[itemRelativePath lastPathComponent] lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			// We need to sepera§§te the relativePath from the filename...
			NSString *fileName = [itemRelativePath lastPathComponent];
			NSString *filePath = [itemRelativePath substringToIndex:[itemRelativePath length] - [fileName length]];
			File *file = [[File alloc] initWithName:fileName atPath:[self.path stringByAppendingPathComponent:filePath]];
			[fileList addObject:file];
			[file release];
		}
	}
		
	if ([fileList count] > 0) {
		NSSortDescriptor *storageItemSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
		[fileList sortUsingDescriptors:[NSArray arrayWithObject:storageItemSortDescriptor]];
		[storageItemSortDescriptor release];
		self.finderTableView.hidden = NO;
	} else {
		self.finderTableView.hidden = YES;
		self.searchResultsEmptyLabel.hidden = NO;
	}
	
	[self.finderTableView reloadData];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
	[searchTextField resignFirstResponder];
}




#pragma mark -
#pragma mark Notification methods
- (void)updateFileListForRemovedFile:(NSNotification *)notification;
{
	File *file = [notification.userInfo objectForKey:@"file"];
	
	// Loop through results, check to see if we have this object.
	int i = 0;
	for (File *f in fileList) {
		if ([f.absolutePath isEqualToString:file.absolutePath]) {
			
			// remove from index.
			[fileList removeObjectAtIndex:i];
			
			// Update tableview.
			[finderTableView beginUpdates];
			[finderTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
			[finderTableView endUpdates];
			
			break;
		}
		i += 1;
	}
}




/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
