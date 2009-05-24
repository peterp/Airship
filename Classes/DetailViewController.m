//
//  DetailViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)openFile:(NSString *)atPath {
	
	
	aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	
	aWebView.scalesPageToFit = YES;
	
//	aWebView.autoresizesSubviews = YES;
//	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);


	
	NSURL *url = [NSURL fileURLWithPath:atPath];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	[aWebView loadRequest:request];
	
	[self.view addSubview:aWebView];
	[aWebView release];
	
//	//Create a URL object.
//NSURL *url = [NSURL URLWithString:urlAddress];
//
////URL Requst Object
//NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//
////load the URL into the web view.
//[aWebView loadRequest:requestObj];
//
////add the web view to the content view
//[self addSubview:aWebView];

	

	NSLog(@"%@", atPath);
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
    [super dealloc];
}


@end
