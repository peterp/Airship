//
//  DirectoryTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DirectoryTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
	
	// Filter
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
	NSMutableArray *filteredData;
	NSMutableArray *filteredDirectoryContents;

	// Paths
	NSString *relativePath;
	NSString *absolutePath;
	
	// Data
	NSMutableArray *directoryContents;

	NSMutableArray *data;
	
	// Cached objects
	NSFileManager *fileManager;
	NSDateFormatter *dateFormat;
}


@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, copy) NSString *relativePath;

@property (nonatomic, retain) NSMutableArray *directoryContents;
@property (nonatomic, retain) NSMutableArray *filteredDirectoryContents;

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *filteredData;




- (void)fileUploadCompleted:(NSNotification *)notification;
- (void)attributesForItem:(NSDictionary *)item;


@end


