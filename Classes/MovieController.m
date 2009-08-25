//
//  MovieController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MovieController.h"





@implementation MovieController


- (void)dealloc 
{
	[super dealloc];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:directoryItem.path]];
	moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
	moviePlayer.movieControlMode = MPMovieControlModeDefault;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
	[moviePlayer play];
}

-(void)moviePlayerFinishedCallback:(NSNotification*)aNotification 
{
	MPMoviePlayerController *moviePlayer = aNotification.object;
	[[NSNotificationCenter defaultCenter] removeObserver:aNotification];
	[moviePlayer stop];
	[moviePlayer release];
	// This might change at some stage, since we want to display these modally.
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}



@end
