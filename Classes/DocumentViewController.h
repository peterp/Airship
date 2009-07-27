//
//  DocumentViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFWebView.h"
@class DirectoryItem;

@interface DocumentViewController : UIViewController {

	IBOutlet AFWebView *webView;
	IBOutlet UITabBar *tabBar;
}

- (void)openFile:(DirectoryItem *)file;


@end
