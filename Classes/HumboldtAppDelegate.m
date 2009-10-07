//
//  HumboldtAppDelegate.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import "HumboldtAppDelegate.h"


#import "FilesTableViewController.h"

#import "FolderController.h"
#import "SearchController.h"
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
	filesNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];    
	[filesTableViewController release];
	
	
	// Search Controller
	SearchController *searchController = [[SearchController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchController];
	searchNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[searchController release];
	
	
	// Server view controller...
	SharingController *sharingController = [[SharingController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *sharingNavigationController = [[UINavigationController alloc] initWithRootViewController:sharingController];
	sharingNavigationController.navigationBar.tintColor = [UIColor whiteColor];
	[sharingController release];

	


	


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
