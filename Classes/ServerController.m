//
//  ServerController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/10.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <ifaddrs.h>
#import <netinet/in.h>
#import <sys/socket.h>

#import "ServerController.h"
#import "StorageHTTPConnection.h"
#import "Reachability.h"



@implementation ServerController


@synthesize httpAddressLabel;
@synthesize httpStatusLabel;


- (void)dealloc 
{
	self.httpAddressLabel = nil;
	self.httpStatusLabel = nil;

	[http release];
  [super dealloc];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
			self.title = @"Sharing";
			
			
			// Copy WWWRoot Docs
			NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
			[self copyWWWDataToPath:documentPath];
					
					
			// Reachability
			[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
			wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
			[wifiReach startNotifer];
			[self updateInterfaceWithReachability:wifiReach];



			// Setup & Start HTTP server
			http = [HTTPServer new];
			[http setType:@"_http._tcp."];
			[http setConnectionClass:[StorageHTTPConnection class]];
			[http setDocumentRoot:[NSURL fileURLWithPath:documentPath]];
			[http setPort:8000];
			NSError *httpError;
			httpRunning = [http start:&httpError];
    }
		
		
		
    return self;
}


- (void)viewDidLoad 
{



//	httpAddressLabel.text = [NSString stringWithFormat:@"http://%@:%d", [self ipAddress], [http port]];
//	
//	if (httpRunning == YES) {
//		httpStatusLabel.text = @"On";
//	} else {
//		httpStatusLabel.text = @"Off, it should be on?";
//	}
	
	
	[super viewDidLoad];
}



- (NSString *)ipAddress
{
	struct ifaddrs *addrs;
	
	BOOL success = (getifaddrs(&addrs) == 0);
	if (success) {
	
		const struct ifaddrs *cursor = addrs;
		while (cursor != NULL) {
		
			NSMutableString* ip;
			if (cursor->ifa_addr->sa_family == AF_INET) {
				
				const struct sockaddr_in* dlAddr = (const struct sockaddr_in*)cursor->ifa_addr;
				const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;
				ip = [[NSMutableString new] autorelease];
				for (int i = 0; i < 4; i++) 
				{
					if (i != 0) {
						[ip appendFormat:@"."];
					}
					[ip appendFormat:@"%d", base[i]];
				}
				
				// We don't want the loopback.
				if ([ip isEqualToString:@"127.0.0.1"] == FALSE) {
					return ip;
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	
	}

	return @"";
}








- (void)copyWWWDataToPath:(NSString *)documentPath
{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	
	if (![fileManager fileExistsAtPath:[documentPath stringByAppendingPathComponent:@"wwwroot"]]) {
		NSError *error;
		[fileManager copyItemAtPath:[resourcePath stringByAppendingPathComponent:@"wwwroot"] toPath:[documentPath stringByAppendingPathComponent:@"wwwroot"] error:&error];
	//	NSLog(@"error: %@", error);
	}
//	
//	// Create document path.
	if (![fileManager fileExistsAtPath:[documentPath stringByAppendingPathComponent:@"Files"]]) {
	
		[fileManager createDirectoryAtPath:[documentPath stringByAppendingPathComponent:@"Files"] attributes:nil];
	}
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}








#pragma mark Reachability code.


- (void)reachabilityChanged:(NSNotification *)note;
{
	Reachability *currentReach = [note object];
	[self updateInterfaceWithReachability:currentReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)currentReach;
{
	NetworkStatus networkStatus = [currentReach currentReachabilityStatus];
  BOOL connectionRequired= [currentReach connectionRequired];
  

	switch (networkStatus)
	{
		case NotReachable:
		{
			self.tabBarItem.badgeValue = @"!";

			//Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
			connectionRequired= NO;  
			break;
		}
					
		case ReachableViaWWAN:
		{
			self.tabBarItem.badgeValue = @"?";
			break;
		}
		
		case ReachableViaWiFi:
		{
			self.tabBarItem.badgeValue = nil;
			// update IP address.
			
			break;
		}
	}
}




@end
