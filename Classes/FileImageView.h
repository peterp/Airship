//
//  FileImageView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/18.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileView.h"
#import "TapDetectingScrollView.h"


@interface FileImageView : FileView <UIScrollViewDelegate, TapDetectingScrollViewDelegate> {

	TapDetectingScrollView *scrollView;
	UIImageView *imageView;

	float imageWidth;
	float imageHeight;
}

@property (nonatomic, retain) TapDetectingScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;





@end
