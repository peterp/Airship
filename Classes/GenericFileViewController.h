//
//  FileViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/12.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageItem.h"


@interface GenericFileViewController : UIViewController {

	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UIToolbar *toolbar;
	
	UIActivityIndicatorView *activityIndicator;
	StorageItem *storageItem;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) StorageItem *storageItem;


- (IBAction)unloadViewController;

- (void)toggleBarsVisibilty;
- (void)hideBarsAfterDelay;

@end
