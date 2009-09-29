//
//  SharingController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/09/25.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface SharingController : UITableViewController {

	// stores the state...
	Reachability *localWiFiReachable;
	BOOL localWiFiConnected;
}



// Reachability
- (void)initReachability;
- (void)reachabilityChanged:(NSNotification *)notification;
- (void)updateInterfaceWithReachability:(Reachability *)currentReach;
- (NSString *)WiFiIPAddress;


@end
