    //
//  HelpViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2010/03/02.
//  Copyright 2010 appfactory. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Help";
	UIImageView *helpBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_helpBackground.png"]];
	[self.view addSubview:helpBackground];
	[helpBackground release];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
