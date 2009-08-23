//
//  HumboldtAppDelegate.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import "HumboldtAppDelegate.h"
#import "FolderController.h"
#import "ServerController.h"


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

	// Folder Controller
	FolderController *folderController = [FolderController initWithPath:@"Files"];
	// Navigation Controller....
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:folderController];
	navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	[folderController release];
	
	
	
	
	// Server view controller...
	ServerController *serverController = [[ServerController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
	
	// Tab bar controller
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers  = [NSArray arrayWithObjects:navigationController, serverController, nil];
	[navigationController release];
	[serverController release];
	
	window.backgroundColor = [UIColor blackColor];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}






@end
