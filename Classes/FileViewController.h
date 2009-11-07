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
@class TapDetectingScrollView;



@interface FileViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate> {

	id <FileViewDelegate> delegate;
	File *file;

	UINavigationBar *navigationBar;
	UISegmentedControl *paginationSegmentControl;
	
	UIToolbar *toolbar;
	UIActivityIndicatorView *activityIndicator;
	
	
	// Document
	TapDetectingWebView *documentWebView;
	// Image
	TapDetectingScrollView *imageScrollView;
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

// Document
@property (nonatomic, retain) TapDetectingWebView *documentWebView;
// Image
@property (nonatomic, retain) TapDetectingScrollView *imageScrollView;
@property (nonatomic, retain) UIImageView *imageView;



- (void)unloadViewController;
- (void)paginationSegmentControlChanged:(id)sender;



- (void)determineFileKindAndLoad;
- (void)loadDocumentFile;
- (void)loadImageFile;

//- (void)loadAudio;
//- (void)loadVideo;





@end
