//
//  HumboldtAppDelegate.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import "HumboldtAppDelegate.h"
#import "FolderController.h"
#import "SearchController.h"
#import "SharingController.h"


@implementation HumboldtAppDelegate


@synthesize window;//, navigationController;

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
	self.window.backgroundColor = [UIColor blackColor];

	// Folder Controller
	FolderController *folderController = [FolderController initWithPath:@"Files"];
	// Navigation Controller....
	UINavigationController *folderNavigationController = [[UINavigationController alloc] initWithRootViewController:folderController];
	folderNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[folderController release];
	
	
	// Server view controller...
	SharingController *sharingController = [[SharingController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *sharingNavigationController = [[UINavigationController alloc] initWithRootViewController:sharingController];
	sharingNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[sharingController release];

	


	// Search Controller
	SearchController *searchController = [[SearchController alloc] initWithStyle:UITableViewStyleGrouped];
	
	


	// Tab bar controller
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers  = [NSArray arrayWithObjects:folderNavigationController, searchController, sharingNavigationController, nil];
	tabBarController.selectedIndex = 0;

	[folderNavigationController release];
	[searchController release];
	[sharingNavigationController release];
	

	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}






@end
