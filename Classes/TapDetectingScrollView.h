//
//  TapDetectingScrollView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TapDetectingScrollViewDelegate <NSObject>
@optional
	- (void)TapDetectingScrollViewWasTapped:(UIScrollView *)scrollView;
@end



@interface TapDetectingScrollView : UIScrollView {

	id <TapDetectingScrollViewDelegate> tapDetectingDelegate;
}

@property (nonatomic, assign) id <TapDetectingScrollViewDelegate> tapDetectingDelegate;


@end

