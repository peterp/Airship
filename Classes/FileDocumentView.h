//
//  FileImageView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/18.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileView.h"

#import "TapDetectingWebView.h"


@interface FileDocumentView : FileView <UIWebViewDelegate> {

	int scrollTo;
	TapDetectingWebView *webView;
	NSString *path;
}

@property (nonatomic, retain) TapDetectingWebView *webView;




@end
