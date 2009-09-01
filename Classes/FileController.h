//
//  FileController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectoryItem.h"


@interface FileController : UIViewController {

	UINavigationBar *navigationBar;
	UIToolbar *toolBar;
	
	UIActivityIndicatorView *activityIndicatorView;
	DirectoryItem *directoryItem;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) DirectoryItem *directoryItem;

- (IBAction)unloadView;

- (void)showHideToolBars;
- (void)hideToolBarsAfterDelay;


//- (void)toggleToolBarsHidden;
//- (void)hideToolBars:(NSTimer*)aTimer;
//- (void)setToolBarsHidden:(BOOL)b;


@end
