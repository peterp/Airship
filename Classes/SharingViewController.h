//
//  SharingViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2010/02/14.
//  Copyright 2010 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPServer;

@interface SharingViewController : UIViewController {
	
	UILabel *sharingStatus;
	UILabel *ipAddress;

	
	int checkConnectionInterval;
	
	
	// Web Sharing
	HTTPServer *httpServer;
	BOOL httpServerIsRunning;
}


// Web Sharing
- (void)configureWebSharing;
- (void)installWebSharingDocuments:(NSString *)toPath;


// Reachability
- (void)checkConnectionAndUpdateInterface;
- (NSString *)WiFiIPAddress;


@end
