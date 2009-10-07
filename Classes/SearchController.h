//
//  SearchController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/09/23.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {

	// Search
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
	NSMutableArray *searchItems;

}

@property (nonatomic, retain) NSMutableArray *searchItems;

@end
