//
//  SearchTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorageTableViewController.h"


@interface SearchTableViewController : StorageTableViewController <UITextFieldDelegate> {
	
	// Search
	UITextField *searchTextField;
	UIControl *searchInterstitial;
}


@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) UIControl *searchInterstitial;


// Search
- (void)setSearchInterstitialHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)hideSearchKeyboardAndInterstitial;
- (void)filterContentForSearchText:(NSString*)searchText;



@end
