//
//  FileViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/29.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewControllerDelegate.h"
#import "FileView.h";

@class File;



@interface FileViewController : UIViewController <FileViewDelegate> {

	id <FileViewControllerDelegate> delegate;
	File *file;

	UIToolbar *navigationBar;
	UILabel *titleViewLabel;
	UIActivityIndicatorView *activityIndicator;
	
	UIToolbar *toolbar;
	UIBarButtonItem *systemActionBarButtonItem;
	UIBarButtonItem *paginateLeftBarButtonItem;
	UIBarButtonItem *paginateRightBarButtonItem;
	UIBarButtonItem *deleteBarButtonItem;
	
	
	
	FileView *fileView;
	UIImageView *capturedFileViewImage;
	BOOL fileViewAnimationLeft;
	
	UIView *modalBackground;
	UIToolbar *modalToolbar;
	
}

@property (nonatomic, assign) id <FileViewControllerDelegate> delegate;
@property (nonatomic, retain) File *file;

@property (nonatomic, retain) UIToolbar *navigationBar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIBarButtonItem *systemActionBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *paginateLeftBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *paginateRightBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *deleteBarButtonItem;




@property (nonatomic, retain) FileView *fileView;
@property (nonatomic, retain) UIImageView *capturedFileViewImage;


- (void)displayFileViewWithKind:(int)kind animated:(BOOL)animated;
- (void)setFileViewWithKind:(int)kind;
- (UIImage *)captureView:(UIView *)view;


// Delete file.
- (void)showDeleteModalToolbar;
- (void)deleteFile;

- (void)showModalToolbar;
- (void)hideModalToolbar;




@end
