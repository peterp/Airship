//
//  DirectoryTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/27.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DirectoryTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
	// Search
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
	NSMutableArray *filteredDirectoryItems;

	// Directory Path
	NSString *relativePath;
	NSString *absolutePath;

	// Data source
	NSMutableArray *directoryItems;

}

@property (nonatomic, copy) NSString *relativePath, *absolutePath;

@property (nonatomic, retain) NSMutableArray *directoryItems;
@property (nonatomic, retain) NSMutableArray *filteredDirectoryItems;

- (void)newFileUploaded:(NSNotification *)notification;


@end
