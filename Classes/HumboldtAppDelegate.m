//
//  HumboldtAppDelegate.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright appfactory 2009. All rights reserved.
//

#import "HumboldtAppDelegate.h"


#import "FinderViewController.h"
#import "SpotlightViewController.h"
#import "SharingViewController.h"
//#import "SharingTableViewController.h"



@implementation UINavigationBar (CustomBackgroundImage)

-(void)drawRect:(CGRect)rect;
{
	UIImage *image = [UIImage imageNamed:@"ui_navigationBar.png"];
	[image drawInRect:rect];	
}

@end



@implementation HumboldtAppDelegate


@synthesize window;
@synthesize tabBarController;


- (void)dealloc 
{
	self.tabBarController = nil;
	self.window = nil;
  [super dealloc];
}


# pragma mark -
# pragma mark Application setup


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	FinderViewController *finder = [FinderViewController finderWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Files/"]];
	UINavigationController *finderNavigationController = [[UINavigationController alloc] initWithRootViewController:finder];
	[finder release];
	

	SpotlightViewController *spotlight = [[SpotlightViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
	UINavigationController *spotlightNavigationController = [[UINavigationController alloc] initWithRootViewController:spotlight];
	[spotlight release];

	SharingViewController *sharingViewController = [[SharingViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
	UINavigationController *sharingNavigationController = [[UINavigationController alloc] initWithRootViewController:sharingViewController];
	[sharingViewController release];
	
	

	// Tab bar controller
	self.tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers  = [NSArray arrayWithObjects:finderNavigationController, spotlightNavigationController, sharingNavigationController, nil];
	tabBarController.selectedIndex = 0;

	[finderNavigationController release];
	[spotlightNavigationController release];
	[sharingNavigationController release];


	// window background
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_tableViewBackground.png"]];
	backgroundImageView.frame = CGRectMake(0, 44, 320, 392);
	[window addSubview:backgroundImageView];
	[backgroundImageView release];
	window.backgroundColor = [UIColor blackColor];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	
	// Prevent sleep
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}






@end
