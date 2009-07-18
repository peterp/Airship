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


@synthesize window, navigationController;

# pragma mark -
# pragma mark Application setup
- (void)applicationDidFinishLaunching:(UIApplication *)application 
{


	// Directory view
	DirectoryTableViewController *directoryTableViewController = [[DirectoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
	directoryTableViewController.relativePath = @"Storage/";
	
	// Navigation
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:directoryTableViewController];
	self.navigationController = aNavigationController;
	[window addSubview:navigationController.view];
	[window makeKeyAndVisible];

	// Release
	[directoryTableViewController release];
	[aNavigationController release];


	// Copy HTML Data
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	[self copyWWWDataToPath:documentPath];	
	
	// Setup & Start HTTP server
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[StorageHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:documentPath]];
	[httpServer setPort:8000];
	NSError *httpError;
	if (![httpServer start:&httpError]) {
		NSLog(@"Error starting HTTPServer: %@", httpError);
	}
}


- (void)dealloc 
{
	[httpServer release];
  [window release];
  [super dealloc];
}



- (void)copyWWWDataToPath:(NSString *)documentPath
{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	
	if (![fileManager fileExistsAtPath:[documentPath stringByAppendingPathComponent:@"wwwroot"]]) {
		NSError *error;
		[fileManager copyItemAtPath:[resourcePath stringByAppendingPathComponent:@"wwwroot"] toPath:[documentPath stringByAppendingPathComponent:@"wwwroot"] error:&error];
		NSLog(@"error: %@", error);
	}
	
	// Create document path.
	if (![fileManager fileExistsAtPath:[documentPath stringByAppendingPathComponent:@"Storage"]]) {
		[fileManager createDirectoryAtPath:[documentPath stringByAppendingPathComponent:@"Storage"] attributes:nil];
	}
}




@end
