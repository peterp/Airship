//
//  FileAudioView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/21.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileAudioView.h"

#import "CALevelMeter.h"


@implementation FileAudioView

@synthesize audioPlayer;
@synthesize levelMeter;

@synthesize playPauseButton;
@synthesize volumeViewContainer;
@synthesize volumeView;
@synthesize songSeekSlider;



@synthesize timePlayedLabel;
@synthesize timeLeftLabel;



- (void)dealloc;
{
	self.audioPlayer = nil;
	self.levelMeter = nil;
	
	self.playPauseButton = nil;
	self.volumeViewContainer = nil;
	self.volumeView = nil;
	self.songSeekSlider = nil;
	
	self.timePlayedLabel = nil;
	self.timeLeftLabel = nil;
	


	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame;
{
	if (self = [super initWithFrame:frame]) {
		
		// Set Audio Session
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

		// Metering
		self.levelMeter = [[CALevelMeter alloc] initWithFrame:CGRectMake(30, 130, 260, 60)];
		[self addSubview:levelMeter];
		[levelMeter release];
		
		
		// playPauseButton;
		self.playPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(138, 300, 44, 44)];
		[playPauseButton addTarget:self action:@selector(playPauseButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		playPauseButton.backgroundColor = [UIColor whiteColor];
		[self addSubview:playPauseButton];
		[playPauseButton release];
		
		
		// Volume
		
		
		self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(25, 376, 270, 30)];
		[self addSubview:volumeView];
		[volumeView release];
	}
	return self;
}


- (void)loadFileAtPath:(NSString *)path;
{
		// Create the audio player
		self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
		audioPlayer.delegate = self;
		audioPlayer.volume = 1;
		audioPlayer.meteringEnabled = YES;
	
		if (audioPlayer == nil) {
			
			NSLog(@"error playing...");
			
			// Provide some sort of error message.
		} else {
			[audioPlayer prepareToPlay];
			[audioPlayer play];
			
			[self updateViewForAudioPlayerState];
			
			
			
		}
		
		[self didStopLoading];
}

- (void)removeFromSuperview;
{
	[audioPlayer stop];
	[levelMeter setPlayer:nil];
	
	[updateTimer invalidate];
	updateTimer = nil;
	
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];

	[super removeFromSuperview];
}







- (void)playPauseButtonPushed:(id)sender;
{
	if (audioPlayer.playing == YES) {
		[audioPlayer pause];
	} else {
		// might need to check for an error here...
		[audioPlayer play];
	}
	
	[self updateViewForAudioPlayerState];
}

- (void)updateViewForAudioPlayerState;
{
	
	if (updateTimer)
		[updateTimer invalidate];


	if (audioPlayer.playing == YES) {
	
		[playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
		[levelMeter setPlayer:audioPlayer];
		
		updateTimer = nil;
	
	} else {

		[playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
		[levelMeter setPlayer:nil];
		
		// Start timer... to update the scrollbar and time.
	}
}



- (NSString *)secondsToHoursMinutesAndSeconds:(long)seconds;
{
	div_t r = div(seconds, (60 * 60));
	NSString *formattedTime = @"";
	int hours = r.quot;
	if (hours > 0) {
		seconds = r.rem;
		formattedTime = [NSString stringWithFormat:@"%0.2d:", hours];
	}
	r = div(seconds, 60);
	int minutes = r.quot;
	seconds = r.rem;

	return [formattedTime stringByAppendingFormat:@"%0.2d:%0.2d", minutes, seconds];
}



#pragma mark -
#pragma mark AVAudioPlayer delegate methods


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
	[self updateViewForAudioPlayerState];
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
	NSLog(@"ERROR IN DECODE: %@\n", error); 
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
	// object is paused automatically, just need to update UI.
	[self updateViewForAudioPlayerState];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player;
{
	[audioPlayer play];
	[self updateViewForAudioPlayerState];
}






@end
