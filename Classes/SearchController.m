//
//  SearchController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/09/23.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "SearchController.h"


@implementation SearchController

@synthesize searchItems;

- (void)dealloc
{
	self.searchItems = nil;
	[super dealloc];
	
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// SearchBar
	searchBar = [[UISearchBar alloc] initWithFrame:self.tableView.bounds];
	searchBar.delegate = self;
	searchBar.tintColor = [UIColor grayColor];
	searchBar.placeholder	= @"Search airship";
	[searchBar sizeToFit];
	self.tableView.tableHeaderView = searchBar;

	// SearchDisplayController
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.searchResultsDelegate = self;
	searchDisplayController.searchResultsDataSource = self;
	searchDisplayController.delegate = self;
	self.searchItems = [NSMutableArray array];
}



- (id)initWithStyle:(UITableViewStyle)style 
{
    if (self = [super initWithStyle:style]) {
			self.title = @"Search";
    }
    return self;
}




#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	searchText = [searchText lowercaseString];
	[searchItems removeAllObjects];
	
	
	NSString *file;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Files"]];
	while (file = [dirEnum nextObject]) {
	
		
	
	
//		NSRange range = [[item.name lowercaseString] rangeOfString:searchText];
//		if (range.length > 0) {
//			[self.filteredDirectoryItems addObject:item];
//		}
		
	}
	
	
//	NSString *file;
//NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
//NSDirectoryEnumerator *dirEnum =
//    [[NSFileManager defaultManager] enumeratorAtPath:docsDir];
// 
//while (file = [dirEnum nextObject]) {
//    if ([[file pathExtension] isEqualToString: @"doc"]) {
//        [self scanDocument: [docsDir stringByAppendingPathComponent:file]];
//    }
//}

//	searchText = [searchText lowercaseString];
//	[self.filteredDirectoryItems removeAllObjects];
//
//	for (DirectoryItem *item in self.directoryItems) {
//		// Compare
//		
//		NSRange range = [[item.name lowercaseString] rangeOfString:searchText];
//		if (range.length > 0) {
//			[self.filteredDirectoryItems addObject:item];
//		}
//	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString 
{
	[self filterContentForSearchText:searchString];
	return YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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





@end

