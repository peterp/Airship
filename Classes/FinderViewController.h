//
//  FinderViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FileViewDelegate.h"


@class FileViewController;
@class File;

@interface FinderViewController : UIViewController <FileViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate> {


	NSString *path;

	// Datasource
	NSMutableArray *fileList;
	NSMutableArray *filteredFileList;

	UITableView *finderTableView;
	UISearchBar *searchBar;
	UISearchDisplayController *searchDisplayController;
	
	FileViewController *fileViewController;
	
	UIToolbar *toolbar;
	UIButton *deleteButton;
	NSMutableDictionary *selectedFileList;
	BOOL isEditing;
	
}

@property (nonatomic, copy) NSString *path;

@property (nonatomic, retain) NSMutableArray *fileList;
@property (nonatomic, retain) NSMutableArray *filteredFileList;

@property (nonatomic, retain) UITableView *finderTableView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@property (nonatomic, retain) FileViewController *fileViewController;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) NSMutableDictionary *selectedFileList;






+ (id)finderWithPath:(NSString *)path;


// Table Helper methods
- (int)numberOfRowsForActiveTableView;
- (int)indexPathForActiveTableView;
- (File *)fileForIndexPath:(int)row;
- (void)presentFileViewControllerWithFile:(File *)file;
- (int)indexPathForPaginationToNextFile:(BOOL)nextFile;

// Edit table methods
- (void)edit:(id)sender;
- (void)cancel:(id)sender;
- (void)showToolbar:(BOOL)show;
- (void)updateSelectionCount;
- (void)deleteSelection;



@end
