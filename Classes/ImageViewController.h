//
//  ImagViewControlle.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericFileViewController.h"
#import "TapDetectingScrollView.h"

@interface ImageViewController : GenericFileViewController <UIScrollViewDelegate> {

	TapDetectingScrollView *scrollView;
	UIImageView *imageView;
}

@property (nonatomic, retain) TapDetectingScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;

@end
