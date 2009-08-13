//
//  HumboldtAppDelegate.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HumboldtAppDelegate : NSObject <UIApplicationDelegate> 
{
	UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end