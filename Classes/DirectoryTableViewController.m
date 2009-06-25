//
//  DirectoryTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DirectoryTableViewController.h"
#import "DetailViewController.h";


@implementation DirectoryTableViewController

@synthesize absolutePath, relativePath, data, directoryContents, filteredDirectoryContents, filteredData;

#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad 
{

	// Cache these objects, used with files.
	fileManager = [[NSFileManager defaultManager] retain];
	dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyyy, HH:mm"];

	// The *actual* path to this directory
	self.absolutePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:self.relativePath];
	self.directoryContents = [NSMutableArray array];
	for (NSString *name in [fileManager directoryContentsAtPath:self.absolutePath]) {
		// Add items to our data source
		if (![name isEqualToString:@".DS_Store"]) {
			[directoryContents addObject:[NSMutableDictionary dictionaryWithObject:name forKey:@"name"]];
		}
	}
	
	
	// Table defaults
	self.tableView.rowHeight = 44;
	self.title = self.relativePath;


	// Search
	searchBar = [[UISearchBar alloc] initWithFrame:self.tableView.bounds];
	searchBar.delegate = self;
	searchBar.placeholder	= [@"Search " stringByAppendingString:self.relativePath];
	searchBar.showsScopeBar = NO;
	searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"All", @"Docus", @"Media", @"Pictures", nil];
	[searchBar sizeToFit];
	self.tableView.tableHeaderView = searchBar;
	
	// Search Display
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.searchResultsDelegate = self;
	searchDisplayController.searchResultsDataSource = self;
	searchDisplayController.delegate = self;
	
	// Search results
	self.filteredDirectoryContents = [NSMutableArray arrayWithCapacity:[self.directoryContents count]];

	

	// Notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadCompleted:) name:@"fileUploadCompleted" object:nil];

}


- (void)dealloc 
{

	self.absolutePath = nil;
	self.relativePath = nil;
	
	self.directoryContents = nil;
	self.filteredDirectoryContents = nil;
	
	self.data = nil;
	self.filteredData = nil;
	

	[searchBar release];
	[searchDisplayController release];
	
	[super dealloc];
}


/**
 * This method is called in every table view when a file is uploaded, 
 * it checks to see if uploaded files path matches this file's path...
 * This is so that we can update the table view with new content once it 
 * arrives.
 */
- (void) fileUploadCompleted:(NSNotification *)notification {

	// Is this update for this table view?
	if (![[notification.userInfo valueForKey:@"relativePath"] 
		isEqualToString:relativePath]) {
		return;
	}

	// figure out where to inser this item in the items array as well as the
	// tableview
	NSString *filename = [notification.userInfo valueForKey:@"filename"];
	int indexRow = - 1;
	for (int i = 0; i < [data count]; i++) {

		if ([filename compare:[data objectAtIndex:i] options:NSCaseInsensitiveSearch] < 1) {
			indexRow = i;
		}
		
		if (i == [data count] - 1 && indexRow < 0) {
			indexRow = i + 1;
		}
		
		if (indexRow > 0) {
			// We need to insert this right at the back...
			[data insertObject:filename atIndex:indexRow];
			
			[self.tableView beginUpdates];
			[self.tableView insertRowsAtIndexPaths:[NSArray
				arrayWithObject:[NSIndexPath indexPathForRow:indexRow inSection:0]]
				withRowAnimation:UITableViewRowAnimationRight];
			[self.tableView endUpdates];
			break;
		}
	}
}





- (void)attributesForItem:(NSDictionary *)item 
{
	
	// Item's attributes
	NSDictionary *attrs = [fileManager attributesOfItemAtPath:[absolutePath stringByAppendingPathComponent:[item objectForKey:@"name"]] error:nil];
	
	if ([[attrs fileType] isEqualToString:NSFileTypeDirectory]) {
		[item setValue:@"folder" forKey:@"type"];
	} else {
	
		NSString *ext = [[item objectForKey:@"name"] pathExtension];

		NSArray *pictures  = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"gif", @"tiff", @"png", nil];
		NSArray *documents = [NSArray arrayWithObjects:@"doc", @"docx", @"htm", @"html", @"key", @"numbers", @"pages", @"pdf", @"ppt", @"pptx", @"txt", @"rtf", @"xls", @"xlsx", nil];
		//NSArray *audio		 = [NSArray arrayWithObjects:@"aac", @"mp3", @"aiff", @"wav"];
		//NSArray *video		 = [NSArray arrayWithObjects:@"m4v", @"mp4", @"mov"];
		
		if ([pictures containsObject:ext]) {
			[item setValue:@"image" forKey:@"type"];
		} else if ([documents containsObject:ext]) {
			[item setValue:@"document" forKey:@"type"];
		} else {
			[item setValue:@"unknown" forKey:@"type"];
		}
	}
	
	[item setValue:[dateFormat stringFromDate:[attrs fileModificationDate]] forKey:@"date"];
}









#pragma mark -
#pragma mark UITableView data source and delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.filteredDirectoryContents count];
  } else {
		return [self.directoryContents count];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	// Custom labels
	UILabel *nameLabel;
	UILabel *metaLabel;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
		// Create cell
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
		
		// Name 
		nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 250, 22)] autorelease];
		nameLabel.tag = 1001;
		nameLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
		nameLabel.textColor = [UIColor blackColor];
		[cell.contentView addSubview:nameLabel];
		
		// Meta
		metaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 22, 250, 22)] autorelease];
		metaLabel.tag = 1002;
		metaLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
		metaLabel.textColor = [UIColor grayColor];
		[cell.contentView addSubview:metaLabel];
			
	} else {
		// Restore cell
		nameLabel = (UILabel *)[cell viewWithTag:1001];
		metaLabel = (UILabel *)[cell viewWithTag:1002];
	}
	
	// Grab item
	NSDictionary *item = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		item = [self.filteredDirectoryContents objectAtIndex:indexPath.row];
	}	else {
		item = [self.directoryContents objectAtIndex:indexPath.row];
	}
	
	
	
	
	// Grab & cache item's attribute information
	if (![item objectForKey:@"type"]) {
		// Cache these items
		[self attributesForItem:item];
	}
	
	[cell.imageView initWithImage:[UIImage imageNamed:[[item objectForKey:@"type"] stringByAppendingString:@".png"]]];

	nameLabel.text = [item objectForKey:@"name"];
	metaLabel.text = [item objectForKey:@"date"];

	return cell;
}










- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSDictionary *item = [data objectAtIndex:indexPath.row];
	if ([[item objectForKey:@"type"] isEqualToString:@"NSFileTypeDirectory"]) {

		// this is a directory... Push another view onto the navigation stack.
		DirectoryTableViewController *directoryTableView = 
			[[DirectoryTableViewController alloc] 
				initWithNibName:nil bundle:[NSBundle mainBundle]];
		directoryTableView.relativePath = 
			[self.relativePath stringByAppendingPathComponent:[item objectForKey:@"name"]];

		[self.navigationController pushViewController:directoryTableView animated:YES];
		[directoryTableView release];
	} else {
	
		DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
		
		[detailViewController openFile:[absolutePath stringByAppendingPathComponent:[item objectForKey:@"name"]]];
		
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}





















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

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
*/

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



#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope 
{
	[self.filteredData removeAllObjects];
	
	for (NSDictionary *item in self.data) {
	
		NSComparisonResult result = [[item objectForKey:@"name"] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame) {
			[self.filteredData addObject:item];
		}
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	

	[self filterContentForSearchText:searchString scope:nil];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//			[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}





@end




