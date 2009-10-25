//
//  StorageTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageItem.h"
#import "GenericFileViewDelegate.h"

@interface StorageTableViewController : UITableViewController <GenericFileViewDelegate> {

	// Storage Directory Path;
	NSString *absolutePath;

	// Data Source
	NSMutableArray *storageItemList;
	NSMutableArray *filteredStorageItemList;


}

@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, retain) NSMutableArray *storageItemList;
@property (nonatomic, retain) NSMutableArray *filteredStorageItemList;


@end
