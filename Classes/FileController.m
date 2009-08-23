//
//  FileController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileController.h"


@implementation FileController


@synthesize navigationBar, toolBar;


- (void)dealloc
{
	self.navigationBar = nil;
	self.toolBar = nil;
	[super dealloc];
}

- (void)openFile:(DirectoryItem *)file
{
	// has to be implemented by child controller...
}


- (void)viewDidLoad 
{
	[super viewDidLoad];
	[self toggleControls];
}



- (void)toggleControls
{
	float alpha = 1.0f;
	if (navigationBar.alpha > 0) {
		alpha = 0.0f;
		[hideControlsTimer invalidate];
	} else {
		hideControlsTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(hideControls:) userInfo:nil repeats:NO];
	}

	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	navigationBar.alpha = alpha;
	toolBar.alpha = alpha;
	[UIView commitAnimations];
}




- (void)hideControls:(NSTimer*)aTimer
{
	if (navigationBar.alpha > 0) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationDuration:0.2];
		navigationBar.alpha = 0;
		toolBar.alpha = 0;
		[UIView commitAnimations];
	}
}


- (IBAction)closeFile
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.



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
