//
//  FilesTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FilesTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {

	// Storage Directory Path;
	NSString *absolutePath;

	// DataSource
	NSMutableArray *storageItemList;
	
	
	// Search
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
	NSMutableArray *filteredStorageItemList;
}


@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, retain) NSMutableArray *storageItemList;


@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) NSMutableArray *filteredStorageItemList;

+ (id)initWithAbsolutePath:(NSString *)path;



@end




