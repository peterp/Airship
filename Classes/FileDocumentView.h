//
//  FileImageView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/18.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileView.h"

//#import "TapDetectingWebView.h"


@interface FileDocumentView : FileView <UIWebViewDelegate, UIGestureRecognizerDelegate> {

	int scrollTo;
	UIWebView *webView;
	NSString *path;
	
	UITapGestureRecognizer *singleTapGestureRecognizer;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UITapGestureRecognizer *singleTapGestureRecognizer;




@end
