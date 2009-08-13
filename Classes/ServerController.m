//
//  ServerController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ServerController.h"


#import "HTTPServer.h"
#import "StorageHTTPConnection.h"


#import <ifaddrs.h>
#import <netinet/in.h>
#import <sys/socket.h>


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
		
			self.title = @"Status";
		
			NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
			[self copyWWWDataToPath:documentPath];
			
			
			
					
			
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
	httpAddressLabel.text = [NSString stringWithFormat:@"http://%@:%d", [self ipAddress], [http port]];
	
	if (httpRunning == YES) {
		httpStatusLabel.text = @"On";
	} else {
		httpStatusLabel.text = @"Off, it should be on?";
	}
	
	
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
	if (![fileManager fileExistsAtPath:[documentPath stringByAppendingPathComponent:@"Storage"]]) {
	
		[fileManager createDirectoryAtPath:[documentPath stringByAppendingPathComponent:@"Storage"] attributes:nil];
	}
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}





@end
