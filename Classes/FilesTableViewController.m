//
//  FilesTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FilesTableViewController.h"


@implementation FilesTableViewController

@synthesize searchItemList;



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
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
	searchBar.delegate = self;
	[searchBar sizeToFit];
	self.tableView.tableHeaderView = searchBar;
	[searchBar release];
	
	
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.delegate = self;
	searchDisplayController.searchResultsDelegate = self;
	searchDisplayController.searchResultsDataSource = self;


	
	
	// SearchBar
	searchBar.placeholder = [NSString stringWithFormat:@"Search '%@'", self.title];
	
//	// Notifications
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newItem:) name:@"newItem" object:nil];
}








@end

