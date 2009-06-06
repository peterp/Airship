//
//  HumboldtAppDelegate.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import "HumboldtAppDelegate.h"
#import "DirectoryTableViewController.h"


#import "HTTPServer.h"
#import "StorageHTTPConnection.h"




@implementation HumboldtAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {

	DirectoryTableViewController *rootViewController = 
		[[DirectoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
	rootViewController.relativePath = @"Airship";
		
	UINavigationController *aNavigationController = 
		[[UINavigationController alloc] initWithRootViewController:rootViewController];
	self.navigationController = aNavigationController;
	
	
	[window addSubview:navigationController.view];
	[window makeKeyAndVisible];
	
	[rootViewController release];
	[aNavigationController release];
	
	
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//	NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"html"];
//	
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	for (NSString *filename in [fileManager contentsOfDirectoryAtPath:resourcePath error:nil]) {
//		[fileManager 
//			copyItemAtPath:[resourcePath stringByAppendingPathComponent:filename] 
//			toPath:[documentPath stringByAppendingPathComponent:filename] 
//			error:nil];
//	}
	
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[StorageHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:documentPath]];
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
