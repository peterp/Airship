//
//  HumboldtAppDelegate.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import "HumboldtAppDelegate.h"
#import "HTTPServer.h"
#import "StorageHTTPConnection.h"

@implementation HumboldtAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {

    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	// Get the document root
	NSString *documentRoot = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																  NSUserDomainMask, 
																  YES) objectAtIndex:0];
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[StorageHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:documentRoot]];
	[httpServer setPort:8000];
	
	// Start the HTTP server
	NSError *httpError;
	if (![httpServer start:&httpError]) {
		NSLog(@"Error starting HTTPServer: %@", httpError);
	}
}


- (void)dealloc {
	[httpServer release];
    [window release];
    [super dealloc];
}


@end
