//
//  ServerController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/10.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"
@class Reachability;


@interface ServerController : UIViewController 
{


	IBOutlet UILabel *httpAddressLabel;
	IBOutlet UILabel *httpStatusLabel;
	
	BOOL httpRunning;
	HTTPServer *http;
	
	Reachability *wifiReach;
}


@property (nonatomic, retain) IBOutlet UILabel *httpAddressLabel;
@property (nonatomic, retain) IBOutlet UILabel *httpStatusLabel;

- (NSString *)ipAddress;
- (void)copyWWWDataToPath:(NSString *)path;


- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateInterfaceWithReachability:(Reachability *)currentReach;



@end
