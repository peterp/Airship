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

	UINavigationBar *navigationBar;
	UILabel *titleViewLabel;
	UISegmentedControl *paginationSegmentControl;
	
	UIToolbar *toolbar;
	UIActivityIndicatorView *activityIndicator;
	
	
	
	FileView *fileView;
	UIImageView *capturedFileViewImage;
	BOOL fileViewAnimationDown;
}

@property (nonatomic, assign) id <FileViewControllerDelegate> delegate;
@property (nonatomic, retain) File *file;

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UISegmentedControl *paginationSegmentControl;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;



@property (nonatomic, retain) FileView *fileView;
@property (nonatomic, retain) UIImageView *capturedFileViewImage;



- (void)displayFileViewWithKind:(int)kind animated:(BOOL)animated;
- (void)setFileViewWithKind:(int)kind;
- (UIImage *)captureView:(UIView *)view;





@end
