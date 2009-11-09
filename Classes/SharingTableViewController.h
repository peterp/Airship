//
//  SharingTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/09.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@class HTTPServer;



@interface SharingTableViewController : UITableViewController {

	// Reachability
	Reachability *localWiFiReachable;
	BOOL localWiFiConnected;
	
	// Web Sharing
	HTTPServer *httpServer;
	BOOL httpServerOn;
}

// Web Sharing
- (void)startWebSharing;
- (void)installWebSharingDocuments:(NSString *)toPath;


// Reachability
- (void)initReachability;
- (void)reachabilityChanged:(NSNotification *)notification;
- (void)updateInterfaceWithReachability:(Reachability *)currentReach;
- (NSString *)WiFiIPAddress;


@end
