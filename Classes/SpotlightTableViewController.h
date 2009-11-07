//
//  SpotlightTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/31.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinderTableViewController.h"


@interface SpotlightTableViewController : FinderTableViewController <UITextFieldDelegate> {


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
