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
#import "FileViewController.h"
#import "File.h"



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
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	int tabBarControllerSelectedIndex = 3;
	NSArray *finderViewControllerPaths;
	NSArray *spotlightViewControllerPaths;
	NSString *openFilePath;
	int openFilePosition = -1;
	if (standardUserDefaults) {

		tabBarControllerSelectedIndex = [[standardUserDefaults objectForKey:@"tabBarControllerSelectedIndex"] intValue];
		finderViewControllerPaths = [standardUserDefaults objectForKey:@"finderViewControllerPaths"];
		spotlightViewControllerPaths = [standardUserDefaults objectForKey:@"spotlightViewControllerPaths"];
		openFilePath = [standardUserDefaults objectForKey:@"openFilePath"];
		openFilePosition = [[standardUserDefaults objectForKey:@"openFilePosition"] intValue];
	}
	
	
	UINavigationController *finderNavigationController = [[UINavigationController alloc] init];
	NSMutableArray *finderViewControllers = [NSMutableArray array];
	FinderViewController *finder = [FinderViewController finderWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Files/"]];
	[finderViewControllers addObject:finder];
	[finder release];
	if ([finderViewControllerPaths count] > 0) {
		// create all the finderView Controllers
		for (NSString *path in finderViewControllerPaths) {		
			FinderViewController *finder = [FinderViewController finderWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[@"Library/Caches/Files/" stringByAppendingPathComponent:path]]];
			[finderViewControllers addObject:finder];
			[finder release];
		}
	}
	[finderNavigationController setViewControllers:finderViewControllers animated:NO];

	
	UINavigationController *spotlightNavigationController = [[UINavigationController alloc] init];
	NSMutableArray *spotlightViewControllers = [NSMutableArray array];
	
	SpotlightViewController *spotlight = [[SpotlightViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
	[spotlightViewControllers addObject:spotlight];
	[spotlight release];
	if ([spotlightViewControllerPaths count] > 0) {
		// create all the finderView Controllers
		for (NSString *path in spotlightViewControllerPaths) {		
			FinderViewController *finder = [FinderViewController finderWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[@"Library/Caches/Files/" stringByAppendingPathComponent:path]]];
			[spotlightViewControllers addObject:finder];
			[finder release];
		}
	}
	[spotlightNavigationController setViewControllers:spotlightViewControllers animated:NO];
	
	
	

	
	
	
	

	
	SharingViewController *sharingViewController = [[SharingViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
	UINavigationController *sharingNavigationController = [[UINavigationController alloc] initWithRootViewController:sharingViewController];
	[sharingViewController release];
	
	

	// Tab bar controller
	self.tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers  = [NSArray arrayWithObjects:finderNavigationController, spotlightNavigationController, sharingNavigationController, nil];
	tabBarController.selectedIndex = tabBarControllerSelectedIndex;
	
	
		 
		 
		 


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
	
	// Determine if the user had a file open.
	if (openFilePath) {
		
		NSLog(@"restoring files is very broken");
		
//		FinderViewController *finder = [[[tabBarController.viewControllers objectAtIndex:tabBarControllerSelectedIndex] viewControllers] lastObject];
//		File *file = [[File alloc] initWithName:[openFilePath lastPathComponent] atPath:finder.path];
//		
//		finder.fileViewController = [[FileViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
//		finder.fileViewController.delegate = finder;
//		[finder presentModalViewController:finder.fileViewController animated:NO];
//		[finder.fileViewController release];
//		finder.fileViewController.file = file;
//		[finder.fileViewController displayFileViewWithKind:file.kind animated:NO];
//
//		// pagination
//		for (UIBarButtonItem *item in finder.fileViewController.toolbar.items) {
//			item.enabled = NO;
//		}
//		[finder.fileViewController.fileView restoreFromPreviousSessionWithPosition:openFilePosition];
//		
//		[file release];
//
	}
	
	
	// Prevent sleep
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}







- (void)applicationWillTerminate:(UIApplication *)application;
{
	// save the active tab bar...
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

	if (standardUserDefaults) {
		NSString *basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Files/"];
		
		// TAB INDEX
		[standardUserDefaults setObject:[NSNumber numberWithInt:tabBarController.selectedIndex] forKey:@"tabBarControllerSelectedIndex"];
		
		// FINDER
		NSMutableArray *finderViewControllerPaths = [NSMutableArray array];
		NSMutableArray *finderViews = [NSMutableArray arrayWithArray:[[tabBarController.viewControllers objectAtIndex:0] viewControllers]];
		[finderViews removeObjectAtIndex:0];
		if ([finderViews count] > 0) {
			for (FinderViewController *f in finderViews) {
				[finderViewControllerPaths addObject:[f.path stringByReplacingOccurrencesOfString:basePath withString:@""]];
			}
		}
		[standardUserDefaults setObject:finderViewControllerPaths forKey:@"finderViewControllerPaths"];
		
		
		// SPOTLIGHT 
		SpotlightViewController *spotlightViewController = [[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0];	
		[standardUserDefaults setObject:spotlightViewController.searchTextField.text forKey:@"spotlightSearchText"];

		NSMutableArray *spotlightViewControllerPaths = [NSMutableArray array];
		NSMutableArray *spotlightViews = [NSMutableArray arrayWithArray:[[tabBarController.viewControllers objectAtIndex:1] viewControllers]];
		[spotlightViews removeObjectAtIndex:0];
		if ([spotlightViews count] > 0) {
			for (FinderViewController *f in spotlightViews) {
				[spotlightViewControllerPaths addObject:[f.path stringByReplacingOccurrencesOfString:basePath withString:@""]];
			}
		}
		[standardUserDefaults setObject:spotlightViewControllerPaths forKey:@"spotlightViewControllerPaths"];
		
		
		// FINDER + FILE VIEW CONTROLLER
		FileViewController *fileViewController = (FileViewController *)[[tabBarController selectedViewController] modalViewController];
		if (fileViewController != nil) {
			// we're just going to save the path to the file... and if it's a special king then we'll save some meta information.
			// for the song it'll be the position
			// for a document also the position.
			[standardUserDefaults setObject:fileViewController.file.absolutePath forKey:@"openFilePath"];
			[standardUserDefaults setObject:[NSNumber numberWithInt:[fileViewController.fileView getPosition]] forKey:@"openFilePosition"];
			
			// Now we just need to get the current position as well.
			
		} else {
			[standardUserDefaults removeObjectForKey:@"openFilePath"];
			[standardUserDefaults removeObjectForKey:@"openFilePosition"];
		}
		
		
		
		
		[standardUserDefaults synchronize];
	}
}






@end
