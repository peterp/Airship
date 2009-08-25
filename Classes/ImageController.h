//
//  ImageController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileController.h"
@class TapDetectingScrollView;

@interface ImageController : FileController <UIScrollViewDelegate> {
	IBOutlet TapDetectingScrollView *scrollView;
	UIImageView *imageView;
}

@property (nonatomic, retain) IBOutlet TapDetectingScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;


@end
