//
//  StorageViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StorageTableViewController.h"
#import "AFStorageManager.h"

#import "DirectoryTableViewController.h";


@implementation StorageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Storage";
	
	self.tableView.rowHeight = 80;
//	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//	self.tableView.backgroundColor = [UIColor brownColor];
//	
	//
    // Create a header view. Wrap it in a container to allow us to position
    // it better.
    //
//    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)] autorelease];
//    UILabel *headerLabel =	[[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)] autorelease];
//	
//    headerLabel.text = @"Test.";
//    headerLabel.textColor = [UIColor whiteColor];
//    headerLabel.shadowColor = [UIColor blackColor];
//    headerLabel.shadowOffset = CGSizeMake(0, 1);
//    headerLabel.font = [UIFont boldSystemFontOfSize:22];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    [containerView addSubview:headerLabel];
//    self.tableView.tableHeaderView = containerView;
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	storage = [[AFStorageManager alloc] initWithPath:@"/Storage"];
}



- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [storage count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	UILabel *bottomLabel;
	
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		
		
		// Create the label for the top row of text
		topLabel = [[[UILabel alloc] initWithFrame: CGRectMake(50, 0, 200, 40)] autorelease];
		[cell.contentView addSubview:topLabel];
		// Configure the properties for the text that are the same on every row
		topLabel.tag = TOP_LABEL_TAG;
//		topLabel.backgroundColor = [UIColor greenColor];
//		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
//		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 1];
		
		bottomLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 40, 200, 40)] autorelease];
		[cell.contentView addSubview:bottomLabel];
		// Configure the properties for the text that are the same on every row
		bottomLabel.tag = BOTTOM_LABEL_TAG;
//		bottomLabel.backgroundColor = [UIColor redColor];
//		bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
//		bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 3];
		
		
    } else {
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}
	
	
	NSDictionary *item = [storage objectAtIndex:indexPath.row];
	
	topLabel.text = [item objectForKey:@"name"];
	bottomLabel.text = [item objectForKey:@"date"];
	
    
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSDictionary *item = [storage objectAtIndex:indexPath.row];
	if ([[item objectForKey:@"type"] isEqualToString:@"NSFileTypeDirectory"]) {
	
		DirectoryTableViewController *directoryView = 
			[[DirectoryTableViewController alloc] initWithNibName:nil 
				bundle:[NSBundle mainBundle]];
		directoryView.title = [item objectForKey:@"name"];
		directoryView.relativePath = [item objectForKey:@"name"];
		
		[self.navigationController pushViewController:directoryView animated:YES];
		
	

		//[storage changePath:[item objectForKey:@"name"] isAbsolute:NO];
		//[tableView reloadData];
	}
	
}


- (void)dealloc {
	[storage release];
	
    [super dealloc];
}


@end

