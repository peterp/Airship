//
//  StorageTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "StorageTableViewController.h"
#import "FilesTableViewController.h"

#import "GenericFileViewController.h"
#import "AudioViewController.h"
#import "DocumentViewController.h"
#import "ImageViewController.h"
#import "VideoViewController.h"


@implementation StorageTableViewController


@synthesize absolutePath;
@synthesize storageItemList;
@synthesize filteredStorageItemList;


- (void)dealloc;
{
	self.absolutePath = nil;
	self.storageItemList = nil;
	self.filteredStorageItemList = nil;

	[super dealloc];
}


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


//- (void)viewDidLoad {
//
//
//
//    [super viewDidLoad];
//
//
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}


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
	
		GenericFileViewController *genericFileViewController = [[GenericFileViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
		if ([storageItem.kind isEqualToString:@"audio"]) {

			genericFileViewController = [[AudioViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"document"]) {
		
			genericFileViewController = [[DocumentViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"image"]) {
		
			genericFileViewController = [[ImageViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"video"]) {
		
			genericFileViewController = [[VideoViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else {
		}

		genericFileViewController.storageItem = storageItem;
		[self presentModalViewController:genericFileViewController animated:YES];
		[genericFileViewController release];
	}
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

