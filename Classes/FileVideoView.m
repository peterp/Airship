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
		
		
		explinationBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:explinationBackground];
		[explinationBackground release];
		
		explinationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		explinationLabel.numberOfLines = 0;
		explinationLabel.adjustsFontSizeToFitWidth = YES;
		explinationLabel.backgroundColor = [UIColor clearColor];
		explinationLabel.font = [UIFont boldSystemFontOfSize:16];
		explinationLabel.shadowColor = [UIColor blackColor];
		explinationLabel.shadowOffset = CGSizeMake(1,1);
		explinationLabel.textAlignment = UITextAlignmentCenter;
		explinationLabel.textColor = [UIColor  colorWithRed:147/255.0 green:147/255.0 blue:161/255.0 alpha:1];
		
		[explinationBackground addSubview:explinationLabel];
		[explinationLabel release];
		
		
		
		
		

		self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(125, 280, 70, 70)];
		[playButton setImage:[UIImage imageNamed:@"ui_buttonPlay.png"] forState:UIControlStateNormal];
		[playButton setImage:[UIImage imageNamed:@"ui_buttonPlayHighlight.png"] forState:UIControlStateHighlighted];
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
	
	CGRect explinationBackgroundRect = CGRectMake(0, 0, 320, 168);
	explinationBackground.image = [UIImage imageNamed:@"ui_extraInfo320.png"];
	CGRect explinationLabelRect = CGRectMake(15, 74, 290, 80);
	

	if (self.frame.size.height == 320) {
		
		playButtonRect = CGRectMake(205, 170, 70, 70);
		playLabelRect = CGRectMake(170, 240, 140, 30);
		
		explinationBackgroundRect = CGRectMake(0, 0, 480, 143);
		explinationBackground.image = [UIImage imageNamed:@"ui_extraInfo480.png"];
		explinationLabelRect = CGRectMake(15, 59, 450, 60);
		
		
	}

	playButton.frame = playButtonRect;
	playLabel.frame = playLabelRect;
	
	explinationBackground.frame = explinationBackgroundRect;
	explinationLabel.frame = explinationLabelRect;

}



- (void)loadFileAtPath:(NSString *)path;
{
	self.moviePath = path;
	
	explinationLabel.text = [NSString stringWithFormat:@"\"%@\" is a video.", [path lastPathComponent]];
	
	[self didStopLoading];
}


- (void)playVideo:(UIButton *)sender;
{
	self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
	moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
	moviePlayerController.backgroundColor = [UIColor clearColor];
	moviePlayerController.movieControlMode = MPMovieControlModeDefault;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];

	
	
	[moviePlayerController play];
}

- (void)moviePlayerFinishedCallback:(NSNotification*)notification;
{
	
	if ([[notification userInfo] valueForKey:@"error"] != nil) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"A problem occured whilst trying to play the video file \"%@.\"", [moviePath lastPathComponent]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}

	
	
	
	

	
	
	[[NSNotificationCenter defaultCenter] removeObserver:notification];
	[moviePlayerController stop];
	self.moviePlayerController = nil;
}



@end
