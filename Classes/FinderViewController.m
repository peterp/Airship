//
//  FinderViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FinderViewController.h"
#import "FileViewController.h"
#import "File.h";






@implementation FinderViewController




@synthesize path;
@synthesize fileList;
@synthesize filteredFileList;

@synthesize finderTableView;
@synthesize searchBar;
@synthesize searchDisplayController;

@synthesize fileViewController;

@synthesize toolbar;
@synthesize deleteButton;
@synthesize selectedFileList;




+ (id)finderWithPath:(NSString *)path;
{
	FinderViewController *finderViewControlller = [[FinderViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
	finderViewControlller.path = path;
	finderViewControlller.title = [path lastPathComponent];
	return finderViewControlller;
}


- (void)dealloc;
{
	self.path = nil;

	self.fileList = nil;
	self.filteredFileList = nil;


	self.finderTableView = nil;
	self.searchBar = nil;
	self.searchDisplayController = nil;
	
	self.fileViewController = nil;
	
	self.toolbar = nil;
	self.deleteButton = nil;
	self.selectedFileList = nil;
	
	
	[super dealloc];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tabBarItem.image = [UIImage imageNamed:@"dock_finder.png"];
	}
  return self;
}






- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:58/255.0 alpha:1];
	
	self.finderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	finderTableView.frame = CGRectMake(0, 0, 320, 367);
	finderTableView.delegate = self;
	finderTableView.dataSource = self;
	finderTableView.rowHeight = 44;
	finderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	finderTableView.backgroundColor = [UIColor clearColor];
	
	// TABLE VIEW HEADER / FOOTER
	UIImageView *tableViewFooter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_tableViewFooter.png"]];
	tableViewFooter.frame = CGRectMake(0, 0, 320, 44);
	finderTableView.tableFooterView = tableViewFooter;
	[tableViewFooter release];
	[self.view addSubview:finderTableView];
	[finderTableView release];
	finderTableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0); // This makes the content 44 pixels smaller, so that our shadow isn't
	// considered an actual row.
	
	if (self.path != nil) {
		
	  // DATA SOURCE
		NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil];
		self.fileList = [NSMutableArray arrayWithCapacity:[directoryContents count]];
		for (NSString *name in directoryContents) {
			File *file = [[File alloc] initWithName:name atPath:self.path]; 
			[fileList addObject:file];
			[file release];
		}
		directoryContents = nil;
	
		// Search
		searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
		searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
		searchBar.delegate = self;
		searchBar.placeholder = [NSString stringWithFormat:@"Search %@", self.title];
		searchBar.tintColor = [UIColor colorWithRed:115/255.0 green:114/255.0 blue:121/255.0 alpha:1];	
		self.finderTableView.tableHeaderView = searchBar;
		finderTableView.contentOffset = CGPointMake(0, 44); // hide the search bar by default.
	
		// Search Display Controller
		searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
		searchDisplayController.delegate = self;
		searchDisplayController.searchResultsDelegate = self;
		searchDisplayController.searchResultsDataSource = self;
	}
	
	
	// EDIT METHODS!
	
	editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 32)];
	[editButton setBackgroundImage:[[UIImage imageNamed: @"ui_barButtonBlue.png"] stretchableImageWithLeftCapWidth:25.5 topCapHeight:0.0]  forState:UIControlStateNormal];
	[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	[editButton setTitleColor:[UIColor colorWithRed:168/255.0 green:169/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
	[editButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
	[editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
	editButton.titleLabel.font = [UIFont systemFontOfSize:12.6];
	editButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
	self.navigationItem.rightBarButtonItem = editBarButtonItem;
	[editBarButtonItem release];
	
	
	
	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 367, 320, 40)];
	UIImageView *toolbarBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	toolbarBackgroundImage.image = [UIImage imageNamed:@"ui_tableViewToolbarBackground.png"];
	[toolbar addSubview:toolbarBackgroundImage];
	[toolbarBackgroundImage release];
	
	
	
	
	self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(193, 5, 122, 32)];
	[deleteButton addTarget:self action:@selector(deleteSelection) forControlEvents:UIControlEventTouchUpInside];
	[deleteButton setBackgroundImage:[[UIImage imageNamed:@"ui_barButtonSilver.png"] stretchableImageWithLeftCapWidth:25.5 topCapHeight:0.0] forState:UIControlStateNormal];
	[deleteButton setTitleColor:[UIColor colorWithRed:25/255.0 green:25/255.0 blue:46/255.0 alpha:1] forState:UIControlStateNormal];
	[deleteButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
	[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	deleteButton.titleLabel.font = [UIFont systemFontOfSize:13];
	[deleteButton setImage:[UIImage imageNamed:@"ui_iconTrash.png"] forState:UIControlStateNormal];
	[toolbar addSubview:deleteButton];
	[deleteButton release];
	[self.view addSubview:toolbar];
	[toolbar release];
	
	// Notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewForRemovedFile:) name:@"removedFileNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFileListForAddedFile:) name:@"addedFileNotification" object:nil];
	

	if (restorePreviousOpenedFile) {
		
		
		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		NSString *openFilePath;
		int openFilePosition = -1;
		if (standardUserDefaults) {
			openFilePath = [standardUserDefaults objectForKey:@"openFilePath"];
			openFilePosition = [[standardUserDefaults objectForKey:@"openFilePosition"] intValue];
		}
		
		int index = 0;
		for (File *f in self.fileList) {
			
			if ([[openFilePath lastPathComponent] isEqualToString:f.name]) {
				
				[finderTableView reloadData];
				[finderTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
				[self presentFileViewControllerWithFile:f];
				[self.fileViewController.fileView restoreFromPreviousSessionWithPosition:openFilePosition];
				
				// remember to set the position.
				return;
			}
			index++;
		}
	}
	

}

- (void)viewWillAppear:(BOOL)animated;
{
	if (self.searchDisplayController.active) {
		[self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[self indexPathForActiveTableView] inSection:0] animated:animated];
	} else {
		[finderTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[self indexPathForActiveTableView] inSection:0] animated:animated];
	}
}










#pragma mark -
#pragma mark UITableViewDataSource Protocol


- (int)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [filteredFileList count];
	} else {
		return [fileList count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

	const int PICK_TAG = 1001;
	const int ICON_TAG = 1002;
	const int NAME_TAG = 1003;
	const int META_TAG = 1004;
	
	UIImageView *pickImageView;
	UIImageView *iconImageView;
	w	
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {

		// Create cell
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
		cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_tableViewCellNotSelectedBackground.png"]] autorelease];
		cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_tableViewCellSelectedBackground.png"]];


		// this is always the default colour
		
		// Icon
		pickImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(-20, 0, 20, 44)] autorelease];
		pickImageView.contentMode = UIViewContentModeCenter;
		pickImageView.tag = PICK_TAG;
		[cell.contentView addSubview:pickImageView];
		
		// Icon
		iconImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 30, 44)] autorelease];
		iconImageView.contentMode = UIViewContentModeCenter;
		iconImageView.tag = ICON_TAG;
		[cell.contentView addSubview:iconImageView];
		
		// Name 
		nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(48, 2, 270, 21)] autorelease];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.tag = NAME_TAG;
		nameLabel.font = [UIFont systemFontOfSize:15];
		nameLabel.textColor = [UIColor colorWithRed:68/255.0 green:64/255.0 blue:81/255.0 alpha:1];
		[cell.contentView addSubview:nameLabel];
		
		// Meta
		metaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(48, 20, 270, 21)] autorelease];
		metaLabel.backgroundColor = [UIColor clearColor];
		metaLabel.tag = META_TAG;
		metaLabel.font = [UIFont systemFontOfSize:12];
		metaLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
		[cell.contentView addSubview:metaLabel];

	} else {
		// Restore cell
		pickImageView = (UIImageView *)[cell viewWithTag:PICK_TAG];
		iconImageView = (UIImageView *)[cell viewWithTag:ICON_TAG];
		nameLabel = (UILabel *)[cell viewWithTag:NAME_TAG];
		metaLabel = (UILabel *)[cell viewWithTag:META_TAG];
	}
	
	File *file = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		file = [filteredFileList objectAtIndex:indexPath.row];
	} else {
		file = [fileList objectAtIndex:indexPath.row];
	}
	
	
	[iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"file_kind_%d.png", file.kind]]];
	nameLabel.text = file.name;
	metaLabel.text = file.date;
	
	if (isEditing == YES) {
		if ([selectedFileList objectForKey:indexPath] == nil) {
			[pickImageView setImage:[UIImage imageNamed:@"ui_tableViewCellNotSelected.png"]];
			cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_tableViewCellNotSelectedBackground.png"]] autorelease];
		} else {
			[pickImageView setImage:[UIImage imageNamed:@"ui_tableViewCellSelected.png"]];
			cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_tableViewCellSelectedBackground.png"]] autorelease];
		}
	} else {
		cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_tableViewCellNotSelectedBackground.png"]] autorelease];
	}
	
	
	[UIView beginAnimations:nil context:nil];
	if (isEditing != YES) {
		pickImageView.frame = CGRectMake(-20, 0, 20, 44);
		iconImageView.frame = CGRectMake(9, 0, 30, 44);
		nameLabel.frame = CGRectMake(48, 2, 270, 21);
		metaLabel.frame = CGRectMake(48, 20, 270, 21);

	} else {
		pickImageView.frame = CGRectMake(9, 0, 20, 44);
		iconImageView.frame = CGRectMake(38, 0, 30, 44);
		nameLabel.frame = CGRectMake(77, 2, 270, 21);
		metaLabel.frame = CGRectMake(77, 20, 270, 21);
	}
	[UIView commitAnimations];

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (isEditing) {
	
		// update selection count.
	
		if (self.selectedFileList == nil) {
			self.selectedFileList = [NSMutableDictionary dictionary];
		}
		
		if ([selectedFileList objectForKey:indexPath] == nil) {
			[selectedFileList setObject:[NSNumber numberWithInt:1] forKey:indexPath];
		} else {
			[selectedFileList removeObjectForKey:indexPath];
		}
		
		[finderTableView reloadData];
		[self updateSelectionCount];
		
	
	} else {

		File *file = [self fileForIndexPath:indexPath.row];
		if (file.kind == FILE_KIND_DIRECTORY) {
		
			FinderViewController *finderViewController = [FinderViewController finderWithPath:file.absolutePath];
			[self.navigationController pushViewController:finderViewController animated:YES];
			[finderViewController release];

		} else {
			// Present the file.
			[self presentFileViewControllerWithFile:file];
		}
	}
}












#pragma mark TableView helper methods


- (int)numberOfRowsForActiveTableView;
{
	return (self.searchDisplayController.active) ? 
		[filteredFileList count] :
		[fileList count];
}

- (int)indexPathForActiveTableView;
{
	return (self.searchDisplayController.active) ? 
		[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row :
		[finderTableView indexPathForSelectedRow].row;
}

- (File*)fileForIndexPath:(int)row;
{
	return (self.searchDisplayController.active) ? 
		[filteredFileList objectAtIndex:row] :
		[fileList objectAtIndex:row];
}

- (int)indexPathForPaginationToNextFile:(BOOL)nextFile;
{
	// Currently selected row
	int index = [self indexPathForActiveTableView];
	
	index = nextFile ? ++index : --index;
	while (index >= 0 && index <= [self numberOfRowsForActiveTableView] - 1) {

		// Grab file object at index.
		File *file = [self fileForIndexPath:index];

		// Only want to paginate to files, not directories.
		if (file.kind != FILE_KIND_DIRECTORY) {
			return index;
		}

		// Increment, decrement
		index = nextFile ? ++index : --index;
		
	}
	return -1;
}

- (void)presentFileViewControllerWithFile:(File *)file;
{

	BOOL animated = YES;

	if (self.fileViewController == nil) {
		self.fileViewController = [[FileViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
		fileViewController.delegate = self;
		[self.navigationController presentModalViewController:fileViewController animated:YES];
		[fileViewController release];
		animated = NO;
	}

	self.fileViewController.file = file;

	
	[self.fileViewController.paginateLeftBarButtonItem setEnabled:[self indexPathForPaginationToNextFile:NO] >= 0 ? YES : NO];
	[self.fileViewController.paginateRightBarButtonItem setEnabled:[self indexPathForPaginationToNextFile:YES] >= 0 ? YES : NO];

	[self.fileViewController displayFileViewWithKind:file.kind animated:animated];
	
}









#pragma mark FileViewDelegate methods

- (void)fileViewControllerDidFinish:(FileViewController *)controller;
{
//	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	[self.navigationController dismissModalViewControllerAnimated:YES];

	self.fileViewController = nil;
}

- (void)fileViewControllerDidPaginate:(FileViewController *)controller toNextFile:(BOOL)nextFile;
{
	// check to see if we can paginate.
	int index = [self indexPathForPaginationToNextFile:nextFile];
	if (index < 0) {
		return;
	}
	
	self.searchDisplayController.active ?
		[self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle] :
		[finderTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	
	[self presentFileViewControllerWithFile:[self fileForIndexPath:index]];
}





- (void)fileViewControllerDidDeleteFile:(FileViewController *)controller;
{
	
		
	int deleteFileIndexPath = [self indexPathForActiveTableView];
	File *file = [self fileForIndexPath:deleteFileIndexPath];
	[file delete];

	// remove the file... from the tableview.
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removedFileNotification" object:self userInfo:
	 [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:file], @"removedFiles", @"fileViewController", @"removedBy", nil]];
	
	
	
	if (fileViewController.paginateRightBarButtonItem.enabled) {	
		[fileViewController setFileViewAnimationLeft:YES];
		[self presentFileViewControllerWithFile:[self fileForIndexPath:deleteFileIndexPath]];
	} else if (fileViewController.paginateLeftBarButtonItem.enabled) {		

		deleteFileIndexPath -= 1;
		[fileViewController setFileViewAnimationLeft:NO];
		self.searchDisplayController.active ?
			[self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:deleteFileIndexPath inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle] :
			[finderTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:deleteFileIndexPath inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
		
		[self presentFileViewControllerWithFile:[self fileForIndexPath:deleteFileIndexPath]];
		
	} else {
		[self fileViewControllerDidFinish:fileViewController];
	}
}












#pragma mark -
#pragma mark Searching

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView;
{
	[self cancel:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
	[filteredFileList removeAllObjects];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
	return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText;
{
	if (filteredFileList == nil) {
		self.filteredFileList = [NSMutableArray array];
	} else {
		[filteredFileList removeAllObjects];
	}
	searchText = [searchText lowercaseString];
	
	for (File *file in fileList) {
		NSRange range = [[file.name lowercaseString] rangeOfString:searchText];
		if (range.length > 0) {
			[filteredFileList addObject:file];
		}
	}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
{
	[self filterContentForSearchText:searchString];
	return YES;
}















#pragma mark -
#pragma mark Custom Editing


- (void)edit:(id)sender;
{
	// Create a cancel button.
	[editButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[editButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];	
	[editButton setBackgroundImage:[[UIImage imageNamed: @"ui_barButtonSilver.png"] stretchableImageWithLeftCapWidth:25.5 topCapHeight:0.0]  forState:UIControlStateNormal];
	[editButton setTitleColor:[UIColor colorWithRed:25/255.0 green:25/255.0 blue:46/255.0 alpha:1] forState:UIControlStateNormal];
	[editButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
	
	[self showToolbar:YES];
	[self updateSelectionCount];
	isEditing = YES;
	[finderTableView reloadData];
}

- (void)cancel:(id)sender;
{
	[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	[editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];	
	[editButton setBackgroundImage:[[UIImage imageNamed: @"ui_barButtonBlue.png"] stretchableImageWithLeftCapWidth:25.5 topCapHeight:0.0]  forState:UIControlStateNormal];
	[editButton setTitleColor:[UIColor colorWithRed:168/255.0 green:169/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
	[editButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
	

	
	[self showToolbar:NO];
	isEditing = NO;
	[selectedFileList removeAllObjects];
	self.selectedFileList = nil;
	[finderTableView reloadData];
}

- (void)showToolbar:(BOOL)show;
{
	[UIView beginAnimations:nil context:nil];
	if (show) {
		if ([fileList count] > 7) {
			
			
			finderTableView.contentInset = UIEdgeInsetsMake(0, 0, -4, 0);
		}
		toolbar.frame = CGRectMake(0, 327, 320, 40);
	} else {
		if ([fileList count] > 7) {
			finderTableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
		}
		toolbar.frame = CGRectMake(0, 367, 320, 40);
	}
	[UIView commitAnimations];
}

- (void)updateSelectionCount;
{
	int count = [selectedFileList count];
	
	[deleteButton setTitle:[NSString stringWithFormat:@"Delete (%ld)", count] forState:UIControlStateNormal];
	deleteButton.enabled = (count != 0);
}

- (void)deleteSelection;
{
	NSArray *indexPaths = [NSArray arrayWithArray:[selectedFileList allKeys]];
	NSMutableArray *removedFiles = [NSMutableArray array];
	for (NSIndexPath *indexPath in indexPaths) {
	
		// delete the file object.
		File *file = [fileList objectAtIndex:indexPath.row];
		[removedFiles addObject:file];
		[file delete];
	}
			
	// Post notification.
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removedFileNotification" object:self userInfo:
	[NSDictionary dictionaryWithObjectsAndKeys:removedFiles, @"removedFiles", nil]];
	
	
	[self cancel:self];
}



// When a file is removed or added, the possibility exists that the 
// prev + next pagination controls can be altered.

// we need to ensur that we update these controls according to 
// the currently active rows...
// the best place to do that is below, using these two method calls

//	[self.fileViewController.paginateLeftBarButtonItem setEnabled:[self indexPathForPaginationToNextFile:NO] >= 0 ? YES : NO];
//	[self.fileViewController.paginateRightBarButtonItem setEnabled:[self indexPathForPaginationToNextFile:YES] >= 0 ? YES : NO];




- (void)updateTableViewForRemovedFile:(NSNotification *)notification;
{
	NSString *removedBy = [notification.userInfo objectForKey:@"removedBy"];
	NSMutableArray *removedFiles = [notification.userInfo objectForKey:@"removedFiles"];
	for (File *rmFile in removedFiles) {
	
		// Is this a folder that's deleted, and is this the visible view controller?
		if (self.navigationController.visibleViewController == self && rmFile.kind == FILE_KIND_DIRECTORY) {
			
			// Does our folder still exist?
			if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
			
				// It's gone, reset the view.
				[self.navigationController popToRootViewControllerAnimated:YES];
			}
		}

		if ([path isEqualToString:[rmFile.absolutePath stringByDeletingLastPathComponent]]) {
			// Loop, and check through, filteredFileList
			if (self.searchDisplayController.active) {
				int i = 0;
				for (File *f in filteredFileList) {
				
					// Is the file been deleted in this tableView?
					if ([f.absolutePath isEqualToString:rmFile.absolutePath]) {
					
						// Remove from datasource and tableView.
						[filteredFileList removeObjectAtIndex:i];
						[self.searchDisplayController.searchResultsTableView beginUpdates];
						[self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
						[self.searchDisplayController.searchResultsTableView endUpdates];
						break;
					}
					i += 1;
				}
			}
		
		
			// Loop, and check through, FileList
			int i = 0;
			for (File *f in fileList) {
			
				// Is the file been deleted in this tableView?
				if ([f.absolutePath isEqualToString:rmFile.absolutePath]) {
					
					
					//fileViewController
					if ([self.fileViewController.file.absolutePath isEqualToString:rmFile.absolutePath] && ![removedBy isEqualToString:@"fileViewController"]) {
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The file you were viewing has been deleted." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
						[alert show];
						[alert release];
						
						[self.fileViewController.fileView removeFromSuperview];
							
						[self fileViewControllerDidFinish:fileViewController];
					}
					
				
					// Remove from datasource and tableView.
					[fileList removeObjectAtIndex:i];
					[finderTableView beginUpdates];
					[finderTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
					[finderTableView endUpdates];
					break;
				}
				
				
				
				
				i += 1;
			}
		}
	}
}




- (void)updateFileListForAddedFile:(NSNotification *)notification;
{

	for (File *newFile in [notification.userInfo objectForKey:@"addedFiles"]) {
	
		if ([path isEqualToString:[newFile.absolutePath stringByDeletingLastPathComponent]]) {
		
		
			int indexPathRow = 0;
			int i = 0;
			for (File *f in fileList) {
				
				if ([newFile.name compare:f.name options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch] < 1) {
					indexPathRow = i;
					break;
				}
				
				if (i == [fileList count] - 1) {
					indexPathRow = i + 1;
					break;
				}
				
				i += 1;
			}
			
			[fileList insertObject:newFile atIndex:indexPathRow];
			[finderTableView beginUpdates];
			[finderTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
			[finderTableView endUpdates];
		}
	}
}

- (void)setRestorePreviousOpenedFile:(BOOL)yesOrNo;
{
	restorePreviousOpenedFile = yesOrNo;
}












/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}







@end
