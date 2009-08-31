//
//  DocumentController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileController.h"
//#import "TapDetectingWebView.h"
@class TapDetectingWebView;


@interface DocumentController : FileController <UIWebViewDelegate> {
	
	TapDetectingWebView *webView;
}

@property (nonatomic, retain) TapDetectingWebView *webView;


@end
