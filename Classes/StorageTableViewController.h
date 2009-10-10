//
//  FileTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageItem.h"

@interface StorageTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {

	// Storage Directory Path;
	NSString *absolutePath;

	// DataSource
	NSMutableArray *storageItemList;
	

}

@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, retain) NSMutableArray *storageItemList;



@end
