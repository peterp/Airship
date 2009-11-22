//
//  StorageTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewDelegate.h"


@class File;
@class FileViewController;


@interface FinderTableViewController : UITableViewController <FileViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {

	// Storage Directory Path;
	NSString *absolutePath;
	NSMutableArray *fileList;
	NSMutableArray *filteredFileList;
	
	// Search
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;

	FileViewController *fileViewController;
}


@property (nonatomic, copy) NSString *absolutePath;
@property (nonatomic, retain) NSMutableArray *fileList;
@property (nonatomic, retain) NSMutableArray *filteredFileList;

// Search
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;


@property (nonatomic, retain) FileViewController *fileViewController;



+ (id)initWithAbsolutePath:(NSString *)path;


- (int)numberOfFilesInTableView;
- (int)indexOfRowForPaginationToNextFile:(BOOL)nextFile;

- (int)indexForSelectedRow;
- (File *)fileForRowAtIndex:(int)index;
- (void)presentFileViewControllerWithFile:(File *)file;


//- (int)indexOfSelectedRow;
//- (int)numberOfRowsInTableView;
//- (File *)storageItemForSelectedRow;

//- (GenericFileViewController *)genericFileViewControllerForStorageItem:(StorageItem *)storageItem;







@end
