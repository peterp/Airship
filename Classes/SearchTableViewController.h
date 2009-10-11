//
//  SearchTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/11.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchTableViewController : UITableViewController <UITextFieldDelegate> {
	
	NSString *documentsDirectory;

	// Search
	UITextField *searchTextField;
	UIControl *searchInterstitial;
	NSMutableArray *filteredStorageItemList;
}

@property (nonatomic, copy) NSString *documentsDirectory;

@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) UIControl *searchInterstitial;
@property (nonatomic, retain) NSMutableArray *filteredStorageItemList;


// Search
- (void)setSearchInterstitialHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)hideSearchKeyboardAndInterstitial;
- (void)filterContentForSearchText:(NSString*)searchText;



@end
