//
//  RootViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize webView;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// setup the web view.
	
	NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000/index_iphone.html"];
	[webView loadRequest:[NSURLRequest requestWithURL:url 
										  cachePolicy:NSURLRequestUseProtocolCachePolicy 
									  timeoutInterval:20.0]];
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


- (void)dealloc {
	[webView release];
    [super dealloc];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */



@end
