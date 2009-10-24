//
//  VideoViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "VideoViewController.h"


@implementation VideoViewController

- (void)viewDidLoad;
{
	// We don't need to add any of those other controls.
}

- (void)viewWillAppear:(BOOL)animated;
{
	MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:storageItem.absolutePath]];
	moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
	moviePlayer.movieControlMode = MPMovieControlModeDefault;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
	[moviePlayer play];
}

-(void)moviePlayerFinishedCallback:(NSNotification*)aNotification;
{
	MPMoviePlayerController *moviePlayer = aNotification.object;
	[[NSNotificationCenter defaultCenter] removeObserver:aNotification];
	[moviePlayer stop];
	[moviePlayer release];
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}


@end
