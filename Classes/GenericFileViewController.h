//
//  FileViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericFileViewDelegate.h"
#import "StorageItem.h"


@interface GenericFileViewController : UIViewController {

	id <GenericFileViewDelegate> delegate;

//	UIBarButtonItem *
//	IBOutlet UINavigationBar *navigationBar;
//	IBOutlet UIToolbar *toolbar;
	
	UIActivityIndicatorView *activityIndicator;
	StorageItem *storageItem;
	
	

}

@property (nonatomic, assign) id <GenericFileViewDelegate> delegate;

//@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) StorageItem *storageItem;






- (void)unloadViewController;
- (void)paginationSegmentControlChanged:(id)sender;


- (void)toggleBarsVisibilty;
- (void)hideBarsAfterDelay;

@end
