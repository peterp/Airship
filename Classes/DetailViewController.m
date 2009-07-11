//
//  DetailViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "DirectoryItem.h"


@implementation DetailViewController

@synthesize file;
@synthesize webView;

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void) dealloc
{
	self.file = nil;
	self.webView = nil;
	
	[super dealloc];
}



- (void)openFile:(DirectoryItem *)item 
{
	self.file = item;
	self.title = file.name;
	
	
	if ([file.type isEqualToString:@"document"]) {
		// Document file, open with UIWebView
		self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
		webView.scalesPageToFit = YES;

		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:file.path]]];
		[self.view addSubview:webView];
		[webView release];
	}
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



@end
