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

	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UIToolbar *toolBar;
	
	UIActivityIndicatorView *activityIndicatorView;
	DirectoryItem *directoryItem;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) DirectoryItem *directoryItem;

- (IBAction)unloadView;

- (void)showHideToolBars;
- (void)hideToolBarsAfterDelay;


@end
