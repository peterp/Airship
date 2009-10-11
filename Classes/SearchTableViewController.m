//
//  SearchTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "SearchTableViewController.h"
#import "StorageItem.h"

#import "FileController.h"
#import "MovieController.h"
#import "DocumentController.h"
#import "ImageController.h"
#import "AudioController.h"



@implementation SearchTableViewController

@synthesize documentsDirectory;
@synthesize searchTextField;
@synthesize searchInterstitial;
@synthesize filteredStorageItemList;



- (void)dealloc;
{
	self.documentsDirectory = nil;
	self.searchTextField = nil;
	self.searchInterstitial = nil;
	self.filteredStorageItemList = nil;
	
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
	
	self.documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Files/"];
	self.filteredStorageItemList = [NSMutableArray array];
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



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return [filteredStorageItemList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath ;
{

	const int NAME_TAG = 1001;
	const int META_TAG = 1002;
	
	
	UILabel *nameLabel;
	UILabel *metaLabel;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
		// Create cell
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
		
		// Name 
		nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 250, 22)] autorelease];
		nameLabel.tag = NAME_TAG;
		nameLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
		nameLabel.textColor = [UIColor darkGrayColor];
		[cell.contentView addSubview:nameLabel];
		
		// Meta
		metaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 22, 120, 22)] autorelease];
		metaLabel.tag = META_TAG;
		metaLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
		metaLabel.textColor = [UIColor grayColor];
		[cell.contentView addSubview:metaLabel];
			
	} else {
		// Restore cell
		nameLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
		metaLabel = (UILabel *)[cell viewWithTag:META_TAG];
	}
	
	// Item
	StorageItem *storageItem = [filteredStorageItemList objectAtIndex:indexPath.row];
	
	
	[cell.imageView setImage:[UIImage imageNamed:[storageItem.kind stringByAppendingPathExtension:@"png"]]];
	nameLabel.text = storageItem.name;
	metaLabel.text = storageItem.date;

	return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	StorageItem *storageItem = [filteredStorageItemList objectAtIndex:indexPath.row];
	
	
	if ([storageItem.kind isEqualToString:@"directory"]) {
	
//		FilesTableViewController *filesTableViewController = [FilesTableViewController initWithAbsolutePath:storageItem.absolutePath];
//		[self.navigationController pushViewController:filesTableViewController animated:YES];
//		[filesTableViewController release];
		
	} else {
	
		FileController *fileController = nil;
		if ([storageItem.kind isEqualToString:@"video"]) {
		
			fileController = [[MovieController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"document"]) {
		
			fileController = [[DocumentController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"image"]) {
		
		
			fileController = [[ImageController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"audio"]) {
		
			fileController = [[AudioController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else {
			// show generic controller... The Unknown.
		}

	
		fileController.directoryItem = storageItem;
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
		[self.navigationController presentModalViewController:fileController animated:YES];
		[fileController release];
	}
}


























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








/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





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
		[filteredStorageItemList removeAllObjects];
		[self.tableView reloadData];
	 }
	}
}


- (void)filterContentForSearchText:(NSString*)searchText;
{
	searchText = [searchText lowercaseString];
	[filteredStorageItemList removeAllObjects];

	NSString *itemRelativePath;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
	while (itemRelativePath = [dirEnum nextObject]) {
		NSRange range = [[[itemRelativePath lastPathComponent] lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			// We need to sepera§§te the relativePath from the filename...
			NSString *itemName = [itemRelativePath lastPathComponent];
			NSString *itemPath = [itemRelativePath substringToIndex:[itemRelativePath length] - [itemName length]];
			
			StorageItem *storageItem = [[StorageItem alloc] initWithName:itemName atAbsolutePath:[documentsDirectory stringByAppendingPathComponent:itemPath]];
			[filteredStorageItemList addObject:storageItem];
			[storageItem release];
		}
	}
	
	NSSortDescriptor *storageItemSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	[filteredStorageItemList sortUsingDescriptors:[NSArray arrayWithObject:storageItemSortDescriptor]];
	[storageItemSortDescriptor release];
	
	self.tableView.hidden = NO;
	[self.tableView reloadData];
}





@end

