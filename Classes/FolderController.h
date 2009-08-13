//
//  DirectoryTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/06/27.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
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



+ (id)initWithPath:(NSString *)path;
- (void)newItem:(NSNotification *)notification;


@end
