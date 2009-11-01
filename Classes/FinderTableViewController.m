//
//  FinderTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/31.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FinderTableViewController.h"

#import "FileViewController.h"
#import "File.h";

@implementation FinderTableViewController


@synthesize path;
@synthesize fileList, filteredFileList;
@synthesize fileViewController;




+ (id)finderWithPath:(NSString *)path;
{
	FinderTableViewController *finder = [[FinderTableViewController alloc] initWithStyle:UIStatusBarStyleDefault];
	finder.path = path;


	return finder;
}


- (void)dealloc;
{
	self.path = nil;
	
	self.fileList = nil;
	self.filteredFileList = nil;
	
	self.fileViewController = nil;
	
	[super dealloc];
}





- (id)initWithStyle:(UITableViewStyle)style;
{
  if (self = [super initWithStyle:style]) {
		
		self.title = @"Files";
		self.tabBarItem.image = [UIImage imageNamed:@"dock_finder.png"];

	}
  return self;
}


- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	if (self.path != nil) {
	
		// DATA SOURCE
		NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:self.path];
		self.fileList = [NSMutableArray arrayWithCapacity:[directoryContents count]];
		for (NSString *name in directoryContents) {
			File *file = [[File alloc] initWithName:name atPath:self.path]; 
			[self.fileList addObject:file];
			[file release];
		}
		directoryContents = nil;
	}
}









#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return [self.fileList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
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
		file = [self.filteredFileList objectAtIndex:indexPath.row];
	} else {
		file = [self.fileList objectAtIndex:indexPath.row];
	}
	
//	[cell.imageView setImage:[UIImage imageNamed:[storageItem.kind stringByAppendingPathExtension:@"png"]]];
	nameLabel.text = file.name;
	metaLabel.text = file.date;

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	File *file = [self fileForIndexPath:indexPath.row];
	
	if (file.kind == FILE_KIND_DIRECTORY) {
	} else {
		// Present the file.
		[self presentFileViewControllerWithFile:file];
	}
}





















#pragma mark TableView helper methods




- (int)numberOfRowsForActiveTableView;
{
	return (self.searchDisplayController.active) ? 
		[self.filteredFileList count] :
		[self.fileList count];
}

- (int)indexPathForActiveTableView;
{
	return (self.searchDisplayController.active) ? 
		[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row :
		[self.tableView indexPathForSelectedRow].row;
}

- (File*)fileForIndexPath:(int)row;
{
	return (self.searchDisplayController.active) ? 
		[self.filteredFileList objectAtIndex:row] :
		[self.fileList objectAtIndex:row];
}

- (int)indexPathForPaginationToNextFile:(BOOL)nextFile;
{
	// Currently selected row
	int index = [self indexPathForActiveTableView];
	
	index = nextFile ? ++index : --index;
	while (index >= 0 && index <= [self numberOfRowsForActiveTableView] - 1) {

		// Grab file object at index.
		File *file = [self fileForIndexPath:index];

		// Only want to paginate to files, not directories.
		if (file.kind != FILE_KIND_DIRECTORY) {
			return index;
		}

		// Increment, decrement
		index = nextFile ? ++index : --index;
		
	}
	return -1;
}

- (void)presentFileViewControllerWithFile:(File *)file;
{
	
	BOOL isActive = YES;
	if (self.fileViewController == nil) {
		self.fileViewController = [[FileViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
		self.fileViewController.delegate = self;
		isActive = NO;
	}

	self.fileViewController.file = file;
	
	
	[self.fileViewController.paginationSegmentControl setEnabled:[self indexPathForPaginationToNextFile:NO] >= 0 ? YES : NO forSegmentAtIndex:0];
	[self.fileViewController.paginationSegmentControl setEnabled:[self indexPathForPaginationToNextFile:YES] >= 0 ? YES : NO forSegmentAtIndex:1];
	
	
	if (isActive == NO) {
		[self.navigationController presentModalViewController:self.fileViewController animated:YES];
		[self.fileViewController release];
	}
}





#pragma mark FileViewDelegate methods

- (void)fileViewControllerDidFinish:(FileViewController *)controller;
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	[self.navigationController dismissModalViewControllerAnimated:YES];

	self.fileViewController = nil;
}

- (void)fileViewControllerDidPaginate:(FileViewController *)controller toNextFile:(BOOL)nextFile;
{
	// check to see if we can paginate.
	int index = [self indexPathForPaginationToNextFile:nextFile];
	if (index < 0) {
		return;
	}
	
	self.searchDisplayController.active ?
		[self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle] :
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	
	File *file = [self fileForIndexPath:index];
	[self presentFileViewControllerWithFile:file];
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

