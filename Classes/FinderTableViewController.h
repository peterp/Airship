//
//  FinderTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/31.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewDelegate.h"

@class FileViewController;
@class File;


@interface FinderTableViewController : UITableViewController <FileViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {


	NSString *path;
	
	NSMutableArray *fileList;
	NSMutableArray *filteredFileList;
	
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
	
	FileViewController *fileViewController;
}


@property (nonatomic, copy) NSString *path;

@property (nonatomic, retain) NSMutableArray *fileList;
@property (nonatomic, retain) NSMutableArray *filteredFileList;

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@property (nonatomic, retain) FileViewController *fileViewController;



+ (id)finderWithPath:(NSString *)path;


// Table Helper methods
- (int)numberOfRowsForActiveTableView;
- (int)indexPathForActiveTableView;
- (File*)fileForIndexPath:(int)row;
- (void)presentFileViewControllerWithFile:(File *)file;
- (int)indexPathForPaginationToNextFile:(BOOL)nextFile;





@end
