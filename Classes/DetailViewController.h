//
//  DetailViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {

	UIWebView *aWebView;

}

- (void)openFile:(NSString *)atPath;


@end
