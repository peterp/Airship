//
//  SpotlightViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinderViewController.h";



@interface SpotlightViewController : FinderViewController <UITextFieldDelegate, UIScrollViewDelegate> {
	// Search
	UITextField *searchTextField;
	UIControl *searchInterstitial;
	UILabel *searchResultsEmptyLabel;
}

@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) UIControl *searchInterstitial;
@property (nonatomic, retain) UILabel *searchResultsEmptyLabel;

// Search
- (void)setSearchInterstitialHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)hideSearchKeyboardAndInterstitial;
- (void)filterContentForSearchText:(NSString*)searchText;


@end
