//
//  FilesTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageTableViewController.h"


@interface FilesTableViewController : StorageTableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
	
	// Search
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
}



@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

+ (id)initWithAbsolutePath:(NSString *)path;


@end




