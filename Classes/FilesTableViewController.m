//
//  FilesTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FilesTableViewController.h"


@implementation FilesTableViewController


@synthesize searchBar;
@synthesize searchDisplayController;


+ (id)initWithAbsolutePath:(NSString *)path;
{
	FilesTableViewController *filesTableViewController = [[FilesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	filesTableViewController.absolutePath = path;
	filesTableViewController.title = [path lastPathComponent];
	return filesTableViewController;
}




- (void)dealloc;
{
	self.searchBar = nil;
	self.searchDisplayController = nil;
	

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

