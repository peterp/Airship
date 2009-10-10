//
//  FilesTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageTableViewController.h"

@interface FilesTableViewController : StorageTableViewController {
	
	
		// Search
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
	NSMutableArray *searchItemList;

}

@property (nonatomic, retain) NSMutableArray *searchItemList;


+ (id)initWithAbsolutePath:(NSString *)path;


@end
