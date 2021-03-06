//
//  SharingViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2010/02/14.
//  Copyright 2010 appfactory. All rights reserved.
//

#import "SharingViewController.h"

// For self.WiFiIPAddress
#import <ifaddrs.h>
#import <netinet/in.h>
#import <sys/socket.h>


#import "Reachability.h"
#import "HTTPServer.h"
#import "StorageHTTPConnection.h"

#import "HelpViewController.h"



@implementation SharingViewController

- (void)dealloc 
{
	[super dealloc];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			self.title = @"Web Sharing";
			self.tabBarItem.image = [UIImage imageNamed:@"dock_sharing.png"];
			// Configure and start the webserver, check every 30 seconds to see if the
			// connection is still active.
			[self configureWebSharing];
			[self performSelector:@selector(checkConnectionAndUpdateInterface) withObject:nil afterDelay:2.5];
			checkConnectionInterval = 90;
    }
    return self;
}


- (void)showHelpModal:(id)sender;
{
	HelpViewController *helpViewController = [[HelpViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:helpViewController animated:YES];
	[helpViewController release];
}


- (void)viewDidLoad 
{
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:58/255.0 alpha:1];

	
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_sharingBackground.png"]];
	[self.view addSubview:backgroundImageView];
	[backgroundImageView release];
	
	
	UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 330, 60, 32)];
	[helpButton setBackgroundImage:[[UIImage imageNamed: @"ui_barButtonBlue.png"] stretchableImageWithLeftCapWidth:25.5 topCapHeight:0.0]  forState:UIControlStateNormal];
	[helpButton setTitle:@"Help" forState:UIControlStateNormal];
	[helpButton setTitleColor:[UIColor colorWithRed:168/255.0 green:169/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
	[helpButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
	[helpButton addTarget:self action:@selector(showHelpModal:) forControlEvents:UIControlEventTouchUpInside];
	helpButton.titleLabel.font = [UIFont systemFontOfSize:12.6];
	helpButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	[self.view addSubview:helpButton];
	[helpButton release];
	
	
	
	sharingStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 94)];
	sharingStatus.textAlignment = UITextAlignmentCenter;
	sharingStatus.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:161/255.0 alpha:1];
	sharingStatus.numberOfLines = 0;
	sharingStatus.backgroundColor = [UIColor clearColor];
	[self.view addSubview:sharingStatus];
	[sharingStatus release];
	
	ipAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, 300, 40)];
	ipAddress.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:150/255.0 alpha:1];
	ipAddress.font = [UIFont boldSystemFontOfSize:20];
	ipAddress.textAlignment = UITextAlignmentCenter;
	ipAddress.backgroundColor = [UIColor clearColor];
	ipAddress.shadowOffset = CGSizeMake(0, -1);
	ipAddress.shadowColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
	[self.view addSubview:ipAddress];
	[ipAddress release];
	
	[super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated;
{
	checkConnectionInterval = 5;
	[self checkConnectionAndUpdateInterface];
}

- (void)viewDidDisappear:(BOOL)animated;
{
	checkConnectionInterval = 90;
}



#pragma mark Reachability

- (void)checkConnectionAndUpdateInterface;
{
	
	Reachability *localWiFiReachable = [Reachability reachabilityForLocalWiFi];
	if ([localWiFiReachable isReachable]) {
	
		self.tabBarItem.badgeValue = nil;
		sharingStatus.text = @"Use the above address to access your Airship webpage";
		ipAddress.text = [NSString stringWithFormat:@"http://%@:8080", [self WiFiIPAddress]];
		
		if (httpServerIsRunning == NO) {
			NSError *httpError;
			httpServerIsRunning = [httpServer start:&httpError];
		}
		
	} else {
		
		self.tabBarItem.badgeValue = @"!";
		sharingStatus.text = @"You must connect to your Wi-Fi network to upload and download files on your Airship webpage";
		ipAddress.text = @"";
		
		if (httpServerIsRunning) {
			NSLog(@"stopping HTTP server.");
			[httpServer stop];
			httpServerIsRunning = NO;
		}
	}
	
	
	// Check to see if the connection is still valid;
	// Do this every 30 seconds when the view is not
	// active, and every 5 seconds when the view is active.
	[self performSelector:@selector(checkConnectionAndUpdateInterface) withObject:nil afterDelay:checkConnectionInterval];
}


- (NSString *)WiFiIPAddress;
{
	struct ifaddrs *addrs;
	
	BOOL success = (getifaddrs(&addrs) == 0);
	if (success == TRUE) {
		
		const struct ifaddrs *cursor = addrs;
		while (cursor != NULL) {
			
			NSMutableString *IP;
			if (cursor->ifa_addr->sa_family == AF_INET) {
				
				const struct sockaddr_in *dlAddr = (const struct sockaddr_in *)cursor->ifa_addr;
				const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;
				
				IP = [[NSMutableString new] autorelease];
				for (int i = 0; i < 4; i++) {
					if (i != 0) {
						[IP appendFormat:@"."];
					}
					[IP appendFormat:@"%d", base[i]];
				}
				
				// Don't return loopback interface, keep searching.
				if ([IP isEqualToString:@"127.0.0.1"] == FALSE) {
					freeifaddrs(addrs);
					return IP;
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	
	return @"";
}






#pragma mark HTTP Server
- (void)configureWebSharing;
{
	// Copy WWWRoot Docs
	NSString *documentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"];
	[self installWebSharingDocuments:documentRoot];
	
	httpServerIsRunning = NO;
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setName:@"airship"];
	[httpServer setConnectionClass:[StorageHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:documentRoot]];
	[httpServer setPort:8080];
}


- (void)installWebSharingDocuments:(NSString *)toPath;
{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fromPath = [[NSBundle mainBundle] resourcePath];

	// overwrite files everytime.
	NSError *error;	
	if ([fileManager fileExistsAtPath:[toPath stringByAppendingPathComponent:@"wwwroot"]]) {
		[[NSFileManager defaultManager] removeItemAtPath:[toPath stringByAppendingPathComponent:@"wwwroot"] error:&error];
	}
	[fileManager copyItemAtPath:[fromPath stringByAppendingPathComponent:@"wwwroot"] toPath:[toPath stringByAppendingPathComponent:@"wwwroot"] error:&error];
	
	if (![fileManager fileExistsAtPath:[toPath stringByAppendingPathComponent:@"Files"]]) {
		[fileManager createDirectoryAtPath:[toPath stringByAppendingPathComponent:@"Files"] withIntermediateDirectories:YES attributes:nil error:nil];
	}	
}



@end
