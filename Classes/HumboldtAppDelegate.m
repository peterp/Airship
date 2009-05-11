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
#import "RootViewController.h"

@implementation HumboldtAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	RootViewController *rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	self.navigationController = aNavigationController;
	
	[window addSubview:navigationController.view];
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
	
	[rootViewController release];
	[aNavigationController release];
}


- (void)dealloc {
	[httpServer release];
    [window release];
    [super dealloc];
}


@end
