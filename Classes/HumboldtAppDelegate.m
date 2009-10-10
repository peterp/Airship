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

#import "SharingController.h"


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
	FilesTableViewController *filesTableViewController = [FilesTableViewController initWithAbsolutePath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Files"]];
	UINavigationController *filesNavigationController = [[UINavigationController alloc] initWithRootViewController:filesTableViewController];
	[filesTableViewController release];
	
	
	// Search Controller
	SearchTableViewController *searchTableViewController = [[SearchTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchTableViewController];
	[searchTableViewController release];
	
	
	// Server view controller...
	SharingController *sharingController = [[SharingController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *sharingNavigationController = [[UINavigationController alloc] initWithRootViewController:sharingController];
	[sharingController release];



	// Tab bar controller
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers  = [NSArray arrayWithObjects:filesNavigationController, searchNavigationController, sharingNavigationController, nil];
	tabBarController.selectedIndex = 1;

	[filesNavigationController release];
	[searchNavigationController release];
	[sharingNavigationController release];
	

	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}






@end
