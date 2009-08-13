//
//  ImageViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/31.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "TapDetectingImageView.h"
@class DirectoryItem;

@interface ImageViewController : UIViewController <UIScrollViewDelegate, TapDetectingImageViewDelegate> {
	UIScrollView *imageScrollView;
}

- (void)openFile:(DirectoryItem *)file;

@end
