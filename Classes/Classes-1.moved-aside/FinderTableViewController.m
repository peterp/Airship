//
//  StorageTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FinderTableViewController.h"

#import "File.h"
#import "FileViewController.h"


@implementation FinderTableViewController



@synthesize absolutePath;
@synthesize fileList;
@synthesize filteredFileList;

@synthesize searchBar;
@synthesize searchDisplayController;


@synthesize fileViewController;


+ (id)initWithAbsolutePath:(NSString *)path;
{
	FinderTableViewController *finderTableViewController = [[FinderTableViewController alloc] initWithStyle:UITableViewStylePlain];
	finderTableViewController.absolutePath = path;
	finderTableViewController.title = [path lastPathComponent];
	return finderTableViewController;
}


- (void)dealloc;
{
	self.absolutePath = nil;
	self.fileList = nil;
	self.filteredFileList = nil;
	
	self.fileViewController = nil;
	
	self.searchBar = nil;
	self.searchDisplayController = nil;

	[super dealloc];
}


- (id)initWithStyle:(UITableViewStyle)style 
{
	if (self = [super initWithStyle:style]) {
		self.title = @"Files";
		self.tabBarItem.image = [UIImage imageNamed:@"dock_finder.png"];
	}
  return self;
}




- (void)viewDidLoad;
{
	// Table Style
	self.tableView.rowHeight = 44;


	// Populate datasource
	
	

	
	
	NSArray *directoryContents = [[[NSFileManager defaultManager] directoryContentsAtPath:self.absolutePath] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	self.fileList = [NSMutableArray arrayWithCapacity:[directoryContents count]];
	for (NSString *name in directoryContents) {
		File *file = [[File alloc] fileWithName:name atPath:absolutePath];
		[fileList addObject:file];
		[file release];
	}
	directoryContents = nil;
	
	
	// SearchBar
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
	searchBar.delegate = self;
	searchBar.placeholder = [NSString stringWithFormat:@"Search %@", self.title];
	self.tableView.tableHeaderView = searchBar;
	
	
	self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.delegate = self;
	searchDisplayController.searchResultsDelegate = self;
	searchDisplayController.searchResultsDataSource = self;
	self.filteredFileList = [NSMutableArray array];

//	// Notifications
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newItem:) name:@"newItem" object:nil];

	[super viewDidLoad];
}



























#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [filteredFileList count];
	} else {
		return [fileList count];
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
		metaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 22, 140, 22)] autorelease];
		metaLabel.tag = META_TAG;
		metaLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
		metaLabel.textColor = [UIColor grayColor];
		[cell.contentView addSubview:metaLabel];
			
	} else {
		// Restore cell
		nameLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
		metaLabel = (UILabel *)[cell viewWithTag:META_TAG];
	}
	
	File *file = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		file = [filteredFileList objectAtIndex:indexPath.row];
	} else {
		file = [fileList objectAtIndex:indexPath.row];
	}

	
//	[cell.imageView setImage:[UIImage imageNamed:[storageItem.kind stringByAppendingPathExtension:@"png"]]];
	nameLabel.text = file.name;
	metaLabel.text = file.date;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	File *file = [self fileForRowAtIndex:indexPath.row];
	
	NSLog(@"didSelectRowAtIndex: %@", file);
	
	if (file.kind == FILE_KIND_DIRECTORY) {
		
	} else {
	
		[self presentFileViewControllerWithFile:file];
	}
}











#pragma mark FinderTableViewController helper methods





- (int)numberOfFilesInTableView;
{
	return self.searchDisplayController.active == NO ? [fileList count] : [filteredFileList count];
}

- (int)indexForSelectedRow;
{
	return self.searchDisplayController.active == NO ? [self.tableView indexPathForSelectedRow].row : [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row;
}

- (File *)fileForRowAtIndex:(int)index;
{
	return self.searchDisplayController.active == NO ? [fileList objectAtIndex:index] : [filteredFileList objectAtIndex:index];
}

- (void)presentFileViewControllerWithFile:(File *)file;
{
	BOOL modalIsActive = YES;
	if (self.fileViewController == nil) {
			self.fileViewController = [[FileViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			self.fileViewController.delegate = self;
			modalIsActive = NO;
	}
	
	// Enable / disable pagination
	[self.fileViewController.paginationSegmentControl setEnabled:[self indexOfRowForPaginationToNextFile:NO] >= 0 ? YES : NO forSegmentAtIndex:0];
	[self.fileViewController.paginationSegmentControl setEnabled:[self indexOfRowForPaginationToNextFile:YES] > 0 ? YES : NO forSegmentAtIndex:1];
	
	self.fileViewController.file = file;
	
	if (modalIsActive == NO) {
		[self.navigationController presentModalViewController:self.fileViewController animated:YES];
		[self.fileViewController release];
	}
}


- (int)indexOfRowForPaginationToNextFile:(BOOL)nextFile;
{
	int index = [self indexForSelectedRow];

	index = nextFile ? ++index : --index;
	while (index >= 0 && index < [self numberOfFilesInTableView]) {
	
		File *f = [self fileForRowAtIndex:index];
		if (f.kind != FILE_KIND_DIRECTORY) {
			return index;
		}
		index = nextFile ? ++index : --index;
	}
	return -1;
}











#pragma mark StorageItemViewDelegate methods






- (void)fileViewControllerDidFinish:(FileViewController *)controller;
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	[self.navigationController dismissModalViewControllerAnimated:YES];

	self.fileViewController = nil;
}



- (void)fileViewControllerDidPaginate:(FileViewController *)controller toNextFile:(BOOL)nextFile;
{
	int index = [self indexOfRowForPaginationToNextFile:nextFile];
	if (self.searchDisplayController.active == NO) {
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	} else {
		[self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	}

	File *file = [self fileForRowAtIndex:index];
	[self presentFileViewControllerWithFile:file];
}






#pragma mark Searching

- (void)filterContentForSearchText:(NSString*)searchText
{
	searchText = [searchText lowercaseString];
	[filteredFileList removeAllObjects];
	
	for (File *file in fileList) {
		NSRange range = [[file.name lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			[filteredFileList addObject:file];
		}
	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString 
{
	[self filterContentForSearchText:searchString];
	return YES;
}




@end

