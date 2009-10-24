//
//  DocumentViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericFileViewController.h"
#import "TapDetectingWebView.h"

@interface DocumentViewController : GenericFileViewController <UIWebViewDelegate> {

	TapDetectingWebView *webView;
}

@property (nonatomic, retain) TapDetectingWebView *webView;


@end
