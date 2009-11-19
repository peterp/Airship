//
//  FileViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/29.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewDelegate.h"
// Document

@class File;

// Document
@class TapDetectingWebView;

// Image
#import "FileView.h";



@interface FileViewController : UIViewController <UIWebViewDelegate> {

	id <FileViewDelegate> delegate;
	File *file;

	UINavigationBar *navigationBar;
	UISegmentedControl *paginationSegmentControl;
	
	UIToolbar *toolbar;
	UIActivityIndicatorView *activityIndicator;
	
	
	
	FileView *fileView;
	UIImageView *capturedFileViewImage;
	
	BOOL fileViewAnimationDown;
	
	
	
	// Document
	TapDetectingWebView *documentWebView;
	
	
	
}

@property (nonatomic, assign) id <FileViewDelegate> delegate;
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









// Document
@property (nonatomic, retain) TapDetectingWebView *documentWebView;






//- (void)unloadViewController;
//- (void)paginationSegmentControlChanged:(id)sender;
//
////- (void)openFile;
////- (void)closeAndUnloadFile;
//
//
//- (void)determineFileKindAndLoad;
//- (void)unloadFile;
//- (void)loadDocumentFile;
////- (void)loadAudio;
////- (void)loadVideo;
//- (void)loadUnknownFile;





@end
