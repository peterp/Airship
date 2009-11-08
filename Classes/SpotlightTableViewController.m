//
//  SpotlightTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/31.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "SpotlightTableViewController.h"
#import "File.h"


@implementation SpotlightTableViewController


@synthesize searchInterstitial;
@synthesize searchResultsEmptyLabel;



- (void)dealloc;
{
	self.searchInterstitial = nil;
	self.searchResultsEmptyLabel = nil;
	
	[super dealloc];
}


- (id)initWithStyle:(UITableViewStyle)style;
{
	if (self = [super initWithStyle:style]) {

		self.title = @"Search";
		self.tabBarItem.image = [UIImage imageNamed:@"dock_spotlight.png"];
	}
	return self;
}


- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	// Setup
	self.tableView.hidden = YES;
	self.navigationController.view.backgroundColor = [UIColor darkGrayColor];

	
	// Data Store
	self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Files/"];
	self.fileList = [NSMutableArray array];
	
	self.navigationController.navigationBar.frame = CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, 44);
	
	// Search
	self.searchBar = [[UISearchBar alloc] init];
	searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
	searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	searchBar.delegate = self;
	searchBar.placeholder = [NSString stringWithFormat:@"Search"];
	self.navigationController.navigationBar.topItem.titleView = searchBar;
	[searchBar release];
	
	
	
	self.searchInterstitial = [[UIControl alloc] initWithFrame:CGRectZero];
	searchInterstitial.frame = self.view.frame;
	searchInterstitial.backgroundColor = [UIColor blackColor];
	searchInterstitial.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	searchInterstitial.hidden = YES;
	[searchInterstitial addTarget:self action:@selector(hideSearchKeyboardAndInterstitial) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationController.view insertSubview:searchInterstitial belowSubview:self.navigationController.navigationBar];
	[searchInterstitial release];
	
	
	
	
	// No Results Label
	self.searchResultsEmptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, 44)];
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






#pragma mark UISearchBar Delegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)search;
{
	// Is called everytime the textfield is tapped.
	if ([search.text length] <= 0) {
		[self setSearchInterstitialHidden:NO animated:YES];
	}
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)search;
{
	[search resignFirstResponder];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
	self.searchResultsEmptyLabel.hidden = YES;

	if ([searchText length] > 0) {
		[self setSearchInterstitialHidden:YES animated:NO];
		[self filterContentForSearchText:searchText];
	} else {
		[self setSearchInterstitialHidden:NO animated:NO];
	}
}



- (void)hideSearchKeyboardAndInterstitial;
{
	[self setSearchInterstitialHidden:YES animated:YES];
	[searchBar resignFirstResponder];
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
		self.tableView.hidden = YES;
		[fileList removeAllObjects];
		[self.tableView reloadData];
	 }
	}
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
		self.tableView.hidden = NO;
	} else {
		self.tableView.hidden = YES;
		self.searchResultsEmptyLabel.hidden = NO;
	}
	
	[self.tableView reloadData];
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
{
	self.navigationController.navigationBar.frame = CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, 44);
}





@end

