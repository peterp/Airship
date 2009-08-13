//
//  ServerController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTTPServer;


@interface ServerController : UIViewController {

	IBOutlet UILabel *httpAddressLabel;
	IBOutlet UILabel *httpStatusLabel;
	
	BOOL httpRunning;
	HTTPServer *http;
}

@property (nonatomic, retain) IBOutlet UILabel *httpAddressLabel;
@property (nonatomic, retain) IBOutlet UILabel *httpStatusLabel;

- (NSString *)ipAddress;
- (void)copyWWWDataToPath:(NSString *)path;

@end
