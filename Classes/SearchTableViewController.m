//
//  SearchTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "SearchTableViewController.h"

@implementation SearchTableViewController

@synthesize searchTextField;
@synthesize searchInterstitial;



- (void)dealloc;
{
	self.searchTextField = nil;
	self.searchInterstitial = nil;
	
	[super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style;
{
	if (self = [super initWithStyle:style]) {
		self.title = @"Search";
	}
  return self;
}


- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	self.absolutePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Files/"];
	self.storageItemList = [NSMutableArray array];
	self.tableView.hidden = YES;
	self.tableView.rowHeight = 44;
	
	
	// Search Input
	self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,0, 300, 44)];
	searchTextField.placeholder = @"Search";
	searchTextField.backgroundColor = [UIColor whiteColor];
	searchTextField.font = [UIFont systemFontOfSize:14];
	searchTextField.bounds = CGRectMake(0, 0, 240, 21);
	searchTextField.delegate = self;
	searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	searchTextField.keyboardAppearance = UIKeyboardTypeDefault;
	searchTextField.returnKeyType = UIReturnKeySearch;
	searchTextField.enablesReturnKeyAutomatically = YES;
	self.navigationItem.titleView = searchTextField;
	[searchTextField release];
	
	
	self.searchInterstitial = [[UIControl alloc] initWithFrame:CGRectMake(0, 64, 320, 480)];
	searchInterstitial.backgroundColor = [UIColor blackColor];
	searchInterstitial.hidden = YES;
	[searchInterstitial addTarget:self action:@selector(hideSearchKeyboardAndInterstitial) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationController.view addSubview:searchInterstitial];
	[searchInterstitial release];
}










#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[searchTextField resignFirstResponder];
	return YES;
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
	string = [textField.text stringByReplacingCharactersInRange:range withString:string];
	[self setSearchInterstitialHidden:([string length] <= 0 ? NO : YES) animated:NO];
	
	if ([string length] > 0) {
		[self filterContentForSearchText:string];
	}

	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
	// Is called everytime the textfield is tapped.
	if ([textField.text length] <= 0) {
		[self setSearchInterstitialHidden:NO animated:YES];
	}
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
	[self setSearchInterstitialHidden:NO animated:NO];
	return YES;
}


- (void)hideSearchKeyboardAndInterstitial;
{
	[self setSearchInterstitialHidden:YES animated:YES];
	[searchTextField resignFirstResponder];
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
		[storageItemList removeAllObjects];
		[self.tableView reloadData];
	 }
	}
}


- (void)filterContentForSearchText:(NSString*)searchText;
{
	searchText = [searchText lowercaseString];
	[storageItemList removeAllObjects];

	NSString *itemRelativePath;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:absolutePath];
	while (itemRelativePath = [dirEnum nextObject]) {
		NSRange range = [[[itemRelativePath lastPathComponent] lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			// We need to sepera§§te the relativePath from the filename...
			NSString *itemName = [itemRelativePath lastPathComponent];
			NSString *itemPath = [itemRelativePath substringToIndex:[itemRelativePath length] - [itemName length]];
			
			StorageItem *storageItem = [[StorageItem alloc] initWithName:itemName atAbsolutePath:[absolutePath stringByAppendingPathComponent:itemPath]];
			[storageItemList addObject:storageItem];
			[storageItem release];
		}
	}
	
	NSSortDescriptor *storageItemSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	[storageItemList sortUsingDescriptors:[NSArray arrayWithObject:storageItemSortDescriptor]];
	[storageItemSortDescriptor release];
	
	self.tableView.hidden = NO;
	[self.tableView reloadData];
}





@end

