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
@synthesize playLabel;
@synthesize moviePlayerController;
@synthesize moviePath;


- (void)dealloc;
{
	self.playButton = nil;
	self.playLabel = nil;
	self.moviePlayerController = nil;
	self.moviePath = nil;

	[super dealloc];
}



- (id)initWithFrame:(CGRect)frame;
{
	if (self = [super initWithFrame:frame]) {
		
		UIImageView *viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_fileViewBackground.png"]];
		viewBackground.frame = frame;
		viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self insertSubview:viewBackground atIndex:0];
		[viewBackground release];

		self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(125, 280, 70, 70)];
		[playButton setImage:[UIImage imageNamed:@"ui_buttonPlay.png"] forState:UIControlStateNormal];
		[playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
		playButton.backgroundColor = [UIColor clearColor];
		[self addSubview:playButton];
		[playButton release];
		
		
		self.playLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 350, 140, 30)];
		playLabel.text = @"PLAY VIDEO";
		playLabel.textAlignment = UITextAlignmentCenter;
		playLabel.backgroundColor = [UIColor clearColor];
		playLabel.textColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:46/255.0 alpha:1];
		playLabel.font = [UIFont systemFontOfSize:16];
		[self addSubview:playLabel];
		[playLabel release];
		
	}
	return self;
}


- (void)layoutSubviews;
{
	CGRect playButtonRect = CGRectMake(125, 280, 70, 70);
	CGRect playLabelRect = CGRectMake(90, 350, 140, 30);

	if (self.frame.size.height == 320) {
		
		playButtonRect = CGRectMake(205, 170, 70, 70);
		playLabelRect = CGRectMake(170, 240, 140, 30);
		
	}

	playButton.frame = playButtonRect;
	playLabel.frame = playLabelRect;
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
