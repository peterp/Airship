//
//  HumboldtAppDelegate.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import "HumboldtAppDelegate.h"


#import "FilesTableViewController.h"
#import "SearchTableViewController.h"
#import "SharingTableViewController.h"


@implementation HumboldtAppDelegate


@synthesize window;

- (void)dealloc 
{
  [window release];
  [super dealloc];
}


# pragma mark -
# pragma mark Application setup


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{

	// Prevent sleep
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	

	// FilesTableViewController
	FilesTableViewController *filesTableViewController = [FilesTableViewController initWithAbsolutePath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Files/"]];
	UINavigationController *filesNavigationController = [[UINavigationController alloc] initWithRootViewController:filesTableViewController];
	[filesTableViewController release];
	

	// Search Controller
	SearchTableViewController *searchTableViewController = [[SearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchTableViewController];
	[searchTableViewController release];
	
	
	// Server view controller...
	SharingTableViewController *sharingTableViewController = [[SharingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *sharingNavigationController = [[UINavigationController alloc] initWithRootViewController:sharingTableViewController];
	[sharingTableViewController release];

	// Tab bar controller
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers  = [NSArray arrayWithObjects:filesNavigationController, searchNavigationController, sharingNavigationController, nil];
	tabBarController.selectedIndex = 0;

	[filesNavigationController release];
	[searchNavigationController release];
	[sharingNavigationController release];
	

	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}






@end
