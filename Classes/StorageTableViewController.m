//
//  FileTableViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "StorageTableViewController.h"
#import "FilesTableViewController.h"

// DetailViewControllers.
#import "FileController.h"
#import "MovieController.h"
#import "DocumentController.h"
#import "ImageController.h"
#import "AudioController.h"



@implementation StorageTableViewController


@synthesize absolutePath;
@synthesize storageItemList;



- (void)dealloc
{
	self.absolutePath = nil;
	self.storageItemList = nil;
	
//	[searchBar dealloc];
//	[searchDisplayController dealloc];

	[super dealloc];
}





- (void)viewDidLoad 
{
	
	[super viewDidLoad];
	

	
	// Table Style
	self.tableView.rowHeight = 44;
	
//	NSLog(@"%@", );
	
	
	
	
	// Notifications
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newItem:) name:@"newItem" object:nil];


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return [self.storageItemList count];
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
	StorageItem *storageItem = nil;
	storageItem = [self.storageItemList objectAtIndex:indexPath.row];
	
	[cell.imageView setImage:[UIImage imageNamed:[storageItem.kind stringByAppendingPathExtension:@"png"]]];
	nameLabel.text = storageItem.name;
	metaLabel.text = storageItem.date;

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	StorageItem *storageItem = [storageItemList objectAtIndex:indexPath.row];
	
	
	if ([storageItem.kind isEqualToString:@"directory"]) {
	
		FilesTableViewController *filesTableViewController = [FilesTableViewController initWithAbsolutePath:[self.absolutePath stringByAppendingPathComponent:storageItem.name]];
		[self.navigationController pushViewController:filesTableViewController animated:YES];
		[filesTableViewController release];
		
	} else {
	
		FileController *fileController = nil;
		if ([storageItem.kind isEqualToString:@"video"]) {
		
			fileController = [[MovieController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"document"]) {
		
			fileController = [[DocumentController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"image"]) {
		
		
			fileController = [[ImageController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else if ([storageItem.kind isEqualToString:@"audio"]) {
		
			fileController = [[AudioController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
			
		} else {
			// show generic controller... The Unknown.
		}

	
		fileController.directoryItem = storageItem;
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
		[self.navigationController presentModalViewController:fileController animated:YES];
		[fileController release];
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

