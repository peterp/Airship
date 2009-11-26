//
//  FileVideoView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/25.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileVideoView.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation FileVideoView


@synthesize playButton;
@synthesize moviePlayerController;
@synthesize moviePath;


- (void)dealloc;
{
	self.playButton = nil;
	self.moviePlayerController = nil;
	self.moviePath = nil;

	[super dealloc];
}



- (id)initWithFrame:(CGRect)frame;
{
	if (self = [super initWithFrame:frame]) {

		self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(138, 300, 44, 44)];
		[playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
		playButton.backgroundColor = [UIColor grayColor];
		[self addSubview:playButton];
		[playButton release];
	}
	return self;
}

- (void)loadFileAtPath:(NSString *)path;
{
	self.moviePath = path;
	
	[self didStopLoading];
}


- (void)playVideo:(UIButton *)sender;
{
	self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
	moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
	moviePlayerController.movieControlMode = MPMovieControlModeDefault;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
	
	[moviePlayerController play];
}

- (void)moviePlayerFinishedCallback:(NSNotification*)notification;
{
	[[NSNotificationCenter defaultCenter] removeObserver:notification];
	[moviePlayerController stop];
	[moviePlayerController release];
}



@end
