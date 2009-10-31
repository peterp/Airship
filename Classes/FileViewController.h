//
//  FileViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/29.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewDelegate.h"

@class File;





@interface FileViewController : UIViewController {

	id <FileViewDelegate> delegate;
	File *file;

	UINavigationBar *navigationBar;
	UISegmentedControl *paginationSegmentControl;
	
	UIToolbar *toolbar;
}

@property (nonatomic, assign) id <FileViewDelegate> delegate;
@property (nonatomic, retain) File *file;

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UISegmentedControl *paginationSegmentControl;

@property (nonatomic, retain) UIToolbar *toolbar;



- (void)unloadViewController;
- (void)paginationSegmentControlChanged:(id)sender;




@end
