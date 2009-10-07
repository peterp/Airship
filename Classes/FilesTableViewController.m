//
//  FilesTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FilesTableViewController.h"


@implementation FilesTableViewController


+ (id)initWithAbsolutePath:(NSString *)path;
{
	FilesTableViewController *filesTableViewController = [[FilesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	filesTableViewController.absolutePath = path;
	filesTableViewController.title = [path lastPathComponent];
	return filesTableViewController;
}




- (void)viewDidLoad 
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


	


//	
//	// Search
//	searchBar = [[UISearchBar alloc] initWithFrame:self.tableView.bounds];
//	searchBar.delegate = self;
//	searchBar.tintColor = [UIColor grayColor];
//	searchBar.placeholder	= [@"Search " stringByAppendingString:self.title];
//	[searchBar sizeToFit];
//	self.tableView.tableHeaderView = searchBar;
//	
//	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//	searchDisplayController.searchResultsDelegate = self;
//	searchDisplayController.searchResultsDataSource = self;
//	searchDisplayController.delegate = self;
//	self.filteredDirectoryItems = [NSMutableArray array];
//	
//	
//	
//	// Notifications
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newItem:) name:@"newItem" object:nil];
}








@end

