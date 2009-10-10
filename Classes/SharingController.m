//
//  SharingController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/09/25.
//  Copyright 2009 appfactory. All rights reserved.
//


// For self.WiFiIPAddress
#import <ifaddrs.h>
#import <netinet/in.h>
#import <sys/socket.h>


#import "SharingController.h"




@implementation SharingController





- (void)dealloc 
{
	[localWiFiReachable dealloc];
	[httpServer release];

	[super dealloc];
}


- (id)initWithStyle:(UITableViewStyle)style 
{
    if (self = [super initWithStyle:style]) {
		
			self.title = @"Sharing";
			
		
			// Reachability
			localWiFiReachable = FALSE;
			[self initReachability];
			
			// Web Sharing
			httpServerOn = FALSE;
			[self performSelector:@selector(startWebSharing) withObject:nil afterDelay:1];
    }
    return self;
}



- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	
	
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
//{
//	return FALSE;
//}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	// Web Sharing
	
	// Wi-Fi
	
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return section == 0 ? 1 : 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	return section == 0 ? nil : @"Wi-Fi";
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section; 
{
	if (section == 0) {
		if (localWiFiConnected) {
			return [NSString stringWithFormat:@"Web sharing is available at this address:\nhttp://%@:%d", [self WiFiIPAddress], 8000];
		} else {
			return @"Web sharing requires a Wi-Fi connection.";
		}
	}
	return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"] autorelease];
	}
	
	switch (indexPath.section) {
		case 0: {
			switch (indexPath.row) {
				case 0: {
					cell.textLabel.text = @"Web Sharing";
				
					cell.detailTextLabel.text = @"On";
					break;
				}
				case 1: {
					cell.textLabel.text = @"Address";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"http://%@:%d", [self WiFiIPAddress], 8000];
					break;
				}
			}
		
			
			break;
		}
			
		case 1: {
			switch (indexPath.row) {
				case 0: {
					cell.textLabel.text = @"Connected to Network";
					cell.detailTextLabel.text = localWiFiConnected ? @"Yes" : @"No";
					break;
				}
				case 1: {
					cell.textLabel.text = @"IP Address";
					cell.detailTextLabel.text = localWiFiConnected ? [self WiFiIPAddress] : @"None";
					break;
				}
			}
			break;
		}
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





#pragma mark Reachability

- (void)initReachability;
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	localWiFiReachable = [[Reachability reachabilityForLocalWiFi] retain];
	[localWiFiReachable startNotifer];
	[self updateInterfaceWithReachability:localWiFiReachable];
}


- (void)reachabilityChanged:(NSNotification *)notification;
{
	Reachability *currentReach = [notification object];
	[self updateInterfaceWithReachability:currentReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)currentReach;
{
	switch ([currentReach currentReachabilityStatus]) {
		
		case NotReachable:
		{
			NSLog(@"Not reachable");
			self.tabBarItem.badgeValue = @"!";
			localWiFiConnected = FALSE;
			break;
		}
					
		case ReachableViaWWAN:
		{
			self.tabBarItem.badgeValue = @"?";
			localWiFiConnected = FALSE;
			break;
		}
		
		case ReachableViaWiFi:
		{
			self.tabBarItem.badgeValue = nil;
			localWiFiConnected = TRUE;
			break;
		}
	}
	
	[self.tableView reloadData];
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

	return nil;
}






#pragma mark HTTP Server
- (void)startWebSharing;
{
	// Init
	
	// Copy WWWRoot Docs
	NSString *documentRoot = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	[self installWebSharingDocuments:documentRoot];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[StorageHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:documentRoot]];
	[httpServer setPort:8000];
	// Start
	NSError *httpError;
	httpServerOn = [httpServer start:&httpError];

}


- (void)installWebSharingDocuments:(NSString *)toPath;
{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fromPath = [[NSBundle mainBundle] resourcePath];
	
	if (![fileManager fileExistsAtPath:[toPath stringByAppendingPathComponent:@"wwwroot"]]) {
		NSError *error;
		[fileManager copyItemAtPath:[fromPath stringByAppendingPathComponent:@"wwwroot"] toPath:[toPath stringByAppendingPathComponent:@"wwwroot"] error:&error];
	}

	if (![fileManager fileExistsAtPath:[toPath stringByAppendingPathComponent:@"Files"]]) {
		[fileManager createDirectoryAtPath:[toPath stringByAppendingPathComponent:@"Files"] attributes:nil];
	}

}



@end

