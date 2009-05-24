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


@synthesize relativePath;
@synthesize absolutePath;
@synthesize directoryContents;

- (void)dealloc {
	[relativePath release];
	[absolutePath release];
	[directoryContents release];
	[super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// custom the tableview a tad.
	self.tableView.rowHeight = 80;
	
	// create the fileManager.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	self.absolutePath = 
		[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
			stringByAppendingPathComponent:relativePath];
			
	// date formatter for the directory items
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd yyy, HH:mm"];
			
	self.directoryContents = [NSMutableArray array];
	for (NSString *name in [fileManager directoryContentsAtPath:absolutePath]) {
	
		NSDictionary *attr = [fileManager fileAttributesAtPath:
			[absolutePath stringByAppendingPathComponent:name]
				traverseLink:NO];
	
		[directoryContents addObject:
			[NSDictionary dictionaryWithObjectsAndKeys:
				name, @"name",
				[dateFormat stringFromDate:[attr objectForKey:NSFileModificationDate]], @"date",
				[attr objectForKey:NSFileSize], @"size",
				[attr objectForKey:NSFileType], @"type",
				@"uiwebview", @"open",
				nil
			]
		];
	}
	
	[dateFormat release];
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








- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [directoryContents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	const NSInteger NAME_LABEL_TAG = 1001;
	const NSInteger META_LABEL_TAG = 1002;
	static NSString *CellIdentifier = @"Cell";
	
	UILabel *nameLabel;
	UILabel *metaLabel;

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
	
		cell = 
			[[[UITableViewCell alloc] 
				initWithFrame:CGRectZero 
				reuseIdentifier:CellIdentifier] 
			autorelease];
		
		nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 250, 40)] autorelease];
		nameLabel.tag = NAME_LABEL_TAG;
		nameLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 1];
		[cell.contentView addSubview:nameLabel];
		
		metaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 40, 250, 40)] autorelease];
		metaLabel.tag = META_LABEL_TAG;
		metaLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
		metaLabel.textColor = [UIColor grayColor];
		[cell.contentView addSubview:metaLabel];

			
			
			
    } else {
		nameLabel = (UILabel *)[cell viewWithTag:NAME_LABEL_TAG];
		metaLabel = (UILabel *)[cell viewWithTag:META_LABEL_TAG];
	}
    
    // Set up the cell...
	NSDictionary *item = [directoryContents objectAtIndex:indexPath.row];
	nameLabel.text = [item objectForKey:@"name"];
	metaLabel.text = [item objectForKey:@"date"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSDictionary *item = [directoryContents objectAtIndex:indexPath.row];
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





@end

