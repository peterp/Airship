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



@interface FileViewController : UIViewController <UIScrollViewDelegate> {

	id <FileViewDelegate> delegate;
	File *file;

	UINavigationBar *navigationBar;
	UISegmentedControl *paginationSegmentControl;
	
	UIToolbar *toolbar;
	UIActivityIndicatorView *activityIndicator;
	
	
	// Image
	UIScrollView *imageScrollView;
	UIImageView *imageView;
	float imageWidth;
	float imageHeight;
}

@property (nonatomic, assign) id <FileViewDelegate> delegate;
@property (nonatomic, retain) File *file;

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UISegmentedControl *paginationSegmentControl;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;




// Image
@property (nonatomic, retain) UIScrollView *imageScrollView;
@property (nonatomic, retain) UIImageView *imageView;



- (void)unloadViewController;
- (void)paginationSegmentControlChanged:(id)sender;




//- (void)loadAudio;
//- (void)loadDocument;
- (void)loadImage;
//- (void)loadVideo;





@end
