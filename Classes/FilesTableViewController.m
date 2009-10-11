//
//  FilesTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FilesTableViewController.h"
#import "StorageItem.h"

#import "FileController.h"
#import "MovieController.h"
#import "DocumentController.h"
#import "ImageController.h"
#import "AudioController.h"

@implementation FilesTableViewController


@synthesize absolutePath;
@synthesize storageItemList;

@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize filteredStorageItemList;


+ (id)initWithAbsolutePath:(NSString *)path;
{
	FilesTableViewController *filesTableViewController = [[FilesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	filesTableViewController.absolutePath = path;
	filesTableViewController.title = [path lastPathComponent];
	return filesTableViewController;
}


- (void)dealloc;
{
	self.absolutePath = nil;
	self.storageItemList = nil;
	
	self.searchBar = nil;
	self.searchDisplayController = nil;
	self.filteredStorageItemList = nil;
	
	

	[super dealloc];
}


- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	// Table Style
	self.tableView.rowHeight = 44;


	// DataSource
	NSArray *directoryContents = [[[NSFileManager defaultManager] directoryContentsAtPath:self.absolutePath] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	self.storageItemList = [NSMutableArray arrayWithCapacity:[directoryContents count]];
	for (NSString *itemName in directoryContents) {
		StorageItem *storageItem = [[StorageItem alloc] initWithName:itemName atAbsolutePath:self.absolutePath];
		[self.storageItemList addObject:storageItem];
		[storageItem release];
	}
	directoryContents = nil;
	
	
	
	
	
	// SearchBar
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
	searchBar.delegate = self;
	searchBar.placeholder = [NSString stringWithFormat:@"Search '%@'", self.title];
	self.tableView.tableHeaderView = searchBar;
	
	
	self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.delegate = self;
	searchDisplayController.searchResultsDelegate = self;
	searchDisplayController.searchResultsDataSource = self;
	self.filteredStorageItemList = [NSMutableArray array];

//	// Notifications
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newItem:) name:@"newItem" object:nil];
}





/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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








#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{

	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [filteredStorageItemList count];
	} else {
		return [storageItemList count];
	}
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
	StorageItem *storageItem = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		storageItem = [filteredStorageItemList objectAtIndex:indexPath.row];
	} else {
		storageItem = [storageItemList objectAtIndex:indexPath.row];
	}
	
	
	[cell.imageView setImage:[UIImage imageNamed:[storageItem.kind stringByAppendingPathExtension:@"png"]]];
	nameLabel.text = storageItem.name;
	metaLabel.text = storageItem.date;

	return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	StorageItem *storageItem = [storageItemList objectAtIndex:indexPath.row];
	
	
	if ([storageItem.kind isEqualToString:@"directory"]) {
	
		FilesTableViewController *filesTableViewController = [FilesTableViewController initWithAbsolutePath:storageItem.absolutePath];
		[self.navigationController pushViewController:filesTableViewController animated:YES];
		[filesTableViewController release];
		
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








#pragma mark Searching

- (void)filterContentForSearchText:(NSString*)searchText
{
	searchText = [searchText lowercaseString];
	[filteredStorageItemList removeAllObjects];
	
	for (StorageItem *storageItem in storageItemList) {
		NSRange range = [[storageItem.name lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			[filteredStorageItemList addObject:storageItem];
		}
	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString 
{
	[self filterContentForSearchText:searchString];
	return YES;
}






@end

