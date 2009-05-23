//
//  RootViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController {
	IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
