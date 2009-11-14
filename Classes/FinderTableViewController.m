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
@synthesize toolbar, deleteButton;
@synthesize searchBar, searchDisplayController;
@synthesize fileViewController;




+ (id)finderWithPath:(NSString *)path;
{
	FinderTableViewController *finder = [[FinderTableViewController alloc] initWithStyle:UIStatusBarStyleDefault];
	finder.path = path;
	finder.title = [path lastPathComponent];

	return finder;
}


- (void)dealloc;
{
	self.path = nil;
	
	self.fileList = nil;
	self.filteredFileList = nil;
	
	self.deleteButton = nil;
	self.toolbar = nil;

//	[deleteButton release];
//	[toolbar release];

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
		
		// Search
		self.searchBar = [[UISearchBar alloc] init];
		searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
		searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		searchBar.delegate = self;
		searchBar.placeholder = [NSString stringWithFormat:@"Search %@", self.title];
		self.tableView.tableHeaderView = searchBar;
		[searchBar release];
		
		// Search Display Controller;
		self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
		searchDisplayController.delegate = self;
		searchDisplayController.searchResultsDelegate = self;
		searchDisplayController.searchResultsDataSource = self;
		
		
		// Editing
		UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonSystemItemEdit target:self action:@selector(edit:)] autorelease];
		self.navigationItem.rightBarButtonItem = editButton;
		
		// Toolbar
		self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 367, 320, 40)];


		self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 7, 122, 28)];
		[deleteButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[deleteButton setBackgroundImage:[[UIImage imageNamed: @"button_red.png"] stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[deleteButton setImage:[UIImage imageNamed:@"icon_trash.png"] forState:UIControlStateNormal];
		[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
		deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		deleteButton.enabled = NO;
		
		[toolbar addSubview:deleteButton];
		[deleteButton release];
	}
}


- (void)viewDidAppear:(BOOL)animated;
{
	// adjust tableview's frame according to the editing mode.
	CGRect tableViewFrame = self.tableView.frame;
	tableViewFrame.size.height = self.tableView.editing ? 327 : 367;
	self.tableView.frame = tableViewFrame;
	[self.view.superview addSubview:self.toolbar];
}

- (void)viewWillDisappear:(BOOL)animated;
{
	[self.toolbar removeFromSuperview];
}







#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.filteredFileList count];
	} else {
		return [self.fileList count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

	const int PICK_TAG = 1001;
	const int ICON_TAG = 1002;
	const int NAME_TAG = 1003;
	const int META_TAG = 1004;
	
	UIImageView *pickImageView;
	UIImageView *iconImageView;
	UILabel *nameLabel;
	UILabel *metaLabel;
	
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {

		// Create cell
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
		
		// Pick Image
		pickImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(-22, 11, 22, 22)] autorelease];
		pickImageView.tag = PICK_TAG;
		pickImageView.alpha = 0;
		pickImageView.backgroundColor = [UIColor brownColor];
		[cell.contentView addSubview:pickImageView];
		
		// Icon
		iconImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 11, 22, 22)] autorelease];
		iconImageView.tag = ICON_TAG;
		[cell.contentView addSubview:iconImageView];

		
		
		// Name 
		nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(43, 0, 270, 22)] autorelease];
//		nameLabel.backgroundColor = [UIColor grayColor];
		nameLabel.tag = NAME_TAG;
		nameLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
		nameLabel.textColor = [UIColor darkGrayColor];
		[cell.contentView addSubview:nameLabel];
		
		// Meta
		metaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(43, 22, 270, 22)] autorelease];
//		metaLabel.backgroundColor = [UIColor darkGrayColor];
		metaLabel.tag = META_TAG;
		metaLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
		metaLabel.textColor = [UIColor grayColor];
		[cell.contentView addSubview:metaLabel];
			
			
	} else {
		// Restore cell
		pickImageView = (UIImageView *)[cell viewWithTag:PICK_TAG];
		iconImageView = (UIImageView *)[cell viewWithTag:ICON_TAG];
		nameLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
		metaLabel = (UILabel *)[cell viewWithTag:META_TAG];
	}
	
	File *file = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		file = [self.filteredFileList objectAtIndex:indexPath.row];
	} else {
		file = [self.fileList objectAtIndex:indexPath.row];
	}
	
	nameLabel.text = file.name;
	metaLabel.text = file.date;
	[iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"file_kind_%d.png", file.kind]]];
	
	
	[UIView beginAnimations:nil context:nil];
	if (editing) {
		pickImageView.frame = CGRectMake(7, 11, 22, 22);
		pickImageView.alpha = 1;
		iconImageView.frame = CGRectMake(43, 11, 22, 22);
		nameLabel.frame = CGRectMake(79, 0, 234, 22);
		metaLabel.frame = CGRectMake(79, 22, 234, 22);
	} else {
		pickImageView.frame = CGRectMake(-22, 11, 22, 22);
		pickImageView.alpha = 0;
		iconImageView.frame = CGRectMake(7, 11, 22, 22);
		nameLabel.frame = CGRectMake(43, 0, 270, 22);
		metaLabel.frame = CGRectMake(43, 22, 270, 22);
	}
	
	[UIView commitAnimations];

	return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	File *file = [self fileForIndexPath:indexPath.row];
	
	if (file.kind == FILE_KIND_DIRECTORY) {
	
	
		FinderTableViewController *finderTableViewController = [FinderTableViewController finderWithPath:file.absolutePath];
		[self.navigationController pushViewController:finderTableViewController animated:YES];
		[finderTableViewController release];

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
	if (self.fileViewController == nil) {
		self.fileViewController = [[FileViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
		fileViewController.delegate = self;
		[self.navigationController presentModalViewController:self.fileViewController animated:YES];
		[fileViewController release];
	}

	self.fileViewController.file = file;
	[self.fileViewController.paginationSegmentControl setEnabled:[self indexPathForPaginationToNextFile:NO] >= 0 ? YES : NO forSegmentAtIndex:0];
	[self.fileViewController.paginationSegmentControl setEnabled:[self indexPathForPaginationToNextFile:YES] >= 0 ? YES : NO forSegmentAtIndex:1];
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



#pragma mark -
#pragma mark Searching

- (void)filterContentForSearchText:(NSString*)searchText;
{
	if (self.filteredFileList == nil) {
		self.filteredFileList = [NSMutableArray array];
	} else {
		[filteredFileList removeAllObjects];
	}
	searchText = [searchText lowercaseString];
	
	for (File *file in fileList) {
		NSRange range = [[file.name lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			[filteredFileList addObject:file];
		}
	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
{
	[self filterContentForSearchText:searchString];
	return YES;
}





#pragma mark -
#pragma mark Editing





- (void)edit:(id)sender;
{
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemDone target:self action:@selector(cancel:)] autorelease];
	self.navigationItem.rightBarButtonItem = cancelButton;
	
	[self showToolbar:YES];
	editing = YES;
	[self.tableView reloadData];
}

- (void)cancel:(id)sender;
{
	UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)] autorelease];
	self.navigationItem.rightBarButtonItem = editButton;
	[self showToolbar:NO];
	editing = NO;
	[self.tableView reloadData];
}



- (void)showToolbar:(BOOL)show;
{

	// Animate show/ hide
	CGRect toolbarFrame = self.toolbar.frame;
	CGRect tableViewFrame = self.tableView.frame;
	
	if (show) {
		toolbarFrame.origin.y = 327;
		tableViewFrame.size.height = self.view.superview.frame.size.height - toolbarFrame.size.height;
	} else {
		toolbarFrame.origin.y = self.view.superview.frame.size.height;
		tableViewFrame.size.height = self.view.superview.frame.size.height;
	}
	
	// this will allow us to animate the checkmarks.
	[self.tableView reloadData];
	
	[UIView beginAnimations:nil context:nil];
	toolbar.frame = toolbarFrame;
	self.tableView.frame = tableViewFrame;
	[UIView commitAnimations];
	
}


#pragma mark -
#pragma mark Generic editing controls.


// Set the style for the editing mode
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

// Update the data source array and delete the row 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	
		// get the File.
		File *file = [fileList objectAtIndex:indexPath.row];
		
		// remove the file
		if ([file delete]) {

			if (tableView == self.searchDisplayController.searchResultsTableView) {
				[filteredFileList removeObjectAtIndex:indexPath.row];
			} else {
				[fileList removeObjectAtIndex:indexPath.row];
			}
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
			
		} else {
		
			// display an error.
		}
	}
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

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
//{
//	return NO;
//}





@end

