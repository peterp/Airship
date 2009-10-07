//
//  DirectoryTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/27.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FolderController.h"

#import "DirectoryItem.h"

#import "FileController.h"
#import "MovieController.h"
#import "DocumentController.h"
#import "ImageController.h"
#import "AudioController.h"


@implementation FolderController

@synthesize relativePath, absolutePath, directoryItems, filteredDirectoryItems;


- (void)dealloc 
{
	self.absolutePath = nil;
	self.relativePath = nil;
	self.directoryItems = nil;
	self.filteredDirectoryItems = nil;
	
	[super dealloc];
}


+ (id)initWithPath:(NSString *)path 
{
	FolderController *fc = [[FolderController alloc] initWithStyle:UITableViewStylePlain];
	fc.relativePath = path;
	return fc;
}




# pragma mark -
# pragma mark Setup / Tear down

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// TableView setup
	self.title = [self.relativePath lastPathComponent];
	self.tableView.rowHeight = 44;

	// Data source
	self.absolutePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:self.relativePath];
	NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:self.absolutePath];
	self.directoryItems = [NSMutableArray array];
	for (NSString *name in [directoryContents sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
		if (![name isEqualToString:@".DS_Store"]) {
			// Create DirectoryItem
			[self.directoryItems addObject:[DirectoryItem initWithName:name atPath:self.absolutePath]];
		}
	}
	
	// Search
	searchBar = [[UISearchBar alloc] initWithFrame:self.tableView.bounds];
	searchBar.delegate = self;
	searchBar.tintColor = [UIColor grayColor];
	searchBar.placeholder	= [@"Search " stringByAppendingString:self.title];
	[searchBar sizeToFit];
	self.tableView.tableHeaderView = searchBar;
	
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.searchResultsDelegate = self;
	searchDisplayController.searchResultsDataSource = self;
	searchDisplayController.delegate = self;
	self.filteredDirectoryItems = [NSMutableArray array];
	
	
	
	// Notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newItem:) name:@"newItem" object:nil];
}






#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.filteredDirectoryItems count];
	} else {
		return [self.directoryItems count];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// Custom labels
	
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
	DirectoryItem *item = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		item = [self.filteredDirectoryItems objectAtIndex:indexPath.row];
	}	else {
		item = [self.directoryItems objectAtIndex:indexPath.row];
	}
	
	[cell.imageView setImage:[UIImage imageNamed:[item.type stringByAppendingPathExtension:@"png"]]];
	nameLabel.text = item.name;
	metaLabel.text = item.date;

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	DirectoryItem *item = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		item = [self.filteredDirectoryItems objectAtIndex:indexPath.row];
	}	else {
		item = [self.directoryItems objectAtIndex:indexPath.row];
	}
	
	if ([item.type isEqualToString:@"directory"]) {

		FolderController *folderController = [FolderController initWithPath:[self.relativePath stringByAppendingPathComponent:item.name]];
		[self.navigationController pushViewController:folderController animated:YES];
		[folderController release];
		
	} else {
	
//		FileController *fileController = nil;
//	
//		if ([item.type isEqualToString:@"video"]) {
//			fileController = [[MovieController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
//		} else if ([item.type isEqualToString:@"document"]) {
//			fileController = [[DocumentController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
//		} else if ([item.type isEqualToString:@"image"]) {
//			fileController = [[ImageController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
//		} else if ([item.type isEqualToString:@"audio"]) {
//			fileController = [[AudioController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
//		} else {
//			// show generic controller... The Unknown.
//		}
		
		
//		fileController.directoryItem = item;
//		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
//		[self.navigationController presentModalViewController:fileController animated:YES];
//		[fileController release];
	}


	
}



#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	searchText = [searchText lowercaseString];
	[self.filteredDirectoryItems removeAllObjects];

	for (DirectoryItem *item in self.directoryItems) {
		// Compare
		
		NSRange range = [[item.name lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			[self.filteredDirectoryItems addObject:item];
		}
	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString 
{
	[self filterContentForSearchText:searchString];
	return YES;
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

# pragma mark - 
# pragma mark Getters, setters, and helper methods



//- (void)setRelativePath:(NSString *)path
//{
//	// Absolute path is based on relative path
//	relativePath = path;
//	NSLog(@"setRelativePath: %@", relativePath);
//	
//}


- (void)newItem:(NSNotification *)notification 
{


	// Not for this view, return;
	if (![[notification.userInfo valueForKey:@"relativePath"] isEqualToString:self.relativePath]) {
		return;
	}

	NSString *name = [notification.userInfo valueForKey:@"name"];
	int indexRow = 0;
	for (int i = 0; [self.directoryItems count] > i; i++) {
	
		
		DirectoryItem *item = [self.directoryItems objectAtIndex:i];
	
		if ([name compare:item.name options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch] < 1) {
			indexRow = i;
			break;
		}
		
		if (i == [self.directoryItems count] - 1) {
			// Place at end
			indexRow = i + 1;
			break;
		}
	}
	
	// No other files to compare against.
	[self.directoryItems insertObject:[DirectoryItem initWithName:name atPath:self.absolutePath] atIndex:indexRow];
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexRow inSection:0]]	withRowAnimation:UITableViewRowAnimationRight];
	[self.tableView endUpdates];
	
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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


@end

