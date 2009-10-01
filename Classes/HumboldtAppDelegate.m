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
	UINavigationController *folderNavigationController = [[UINavigationController alloc] initWithRootViewController:folderController];
	folderNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[folderController release];
	
	
	// Search Controller
	SearchController *searchController = [[SearchController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchController];
	searchNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[searchController release];
	
	
	// Server view controller...
	SharingController *sharingController = [[SharingController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *sharingNavigationController = [[UINavigationController alloc] initWithRootViewController:sharingController];
	sharingNavigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[sharingController release];

	


	


	// Tab bar controller
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers  = [NSArray arrayWithObjects:folderNavigationController, searchNavigationController, sharingNavigationController, nil];
	tabBarController.selectedIndex = 0;

	[folderNavigationController release];
	[searchNavigationController release];
	[sharingNavigationController release];
	

	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}






@end
