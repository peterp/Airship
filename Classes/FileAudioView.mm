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
		self.levelMeter = [[CALevelMeter alloc] initWithFrame:CGRectMake(10, 150, 300, 60)];
		[self addSubview:levelMeter];
		[levelMeter release];
		
		
		// playPauseButton;
		self.playPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(138, 300, 44, 44)];
		[playPauseButton addTarget:self action:@selector(playPauseButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		playPauseButton.backgroundColor = [UIColor grayColor];
		[self addSubview:playPauseButton];
		[playPauseButton release];
		
		
		// Volume
		self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(25, 376, 270, 30)];
		[self addSubview:volumeView];
		[volumeView release];
		
		// Volume customisation
		
		
		// Seek bar + timers.
		self.timePlayedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 50, 20)];
		timePlayedLabel.textColor = [UIColor whiteColor];
		timePlayedLabel.adjustsFontSizeToFitWidth = YES;
		timePlayedLabel.font = [UIFont systemFontOfSize:12];
		timePlayedLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:timePlayedLabel];
		[timePlayedLabel release];
		
		
		self.timeLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 90, 50, 20)];
		timeLeftLabel.textAlignment = UITextAlignmentRight;
		timeLeftLabel.textColor = [UIColor whiteColor];
		timeLeftLabel.adjustsFontSizeToFitWidth = YES;
		timeLeftLabel.font = [UIFont systemFontOfSize:12];
		timeLeftLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:timeLeftLabel];
		[timeLeftLabel release];

		
		self.songSeekSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, 90, 200, 20)];
		songSeekSlider.minimumValue = 0;
		
		[songSeekSlider addTarget:self action:@selector(songSeekSliderEditingDidBegin:) forControlEvents:UIControlEventTouchDown];
		[songSeekSlider addTarget:self action:@selector(songSeekSliderEditingDidEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
		[songSeekSlider addTarget:self action:@selector(songSeekSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];

		[self addSubview:songSeekSlider];
		[songSeekSlider release];
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
			
			songSeekSlider.maximumValue = audioPlayer.duration;
			[self updateViewForTimeState];
			
			
			
		}
		
		[self didStopLoading];
}

- (void)removeFromSuperview;
{
	[audioPlayer stop];
	[levelMeter setPlayer:nil];
	
	[updateTimeTimer invalidate];
	updateTimeTimer = nil;
	
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
	
	if (updateTimeTimer)
		[updateTimeTimer invalidate];


	if (audioPlayer.playing == YES) {
	
		[playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
		[levelMeter setPlayer:audioPlayer];
		
		// Start timer... to update the scrollbar and time.
		updateTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateViewForTimeState) userInfo:nil repeats:YES];
	} else {

		[playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
		[levelMeter setPlayer:nil];
		updateTimeTimer = nil;
	}
}

- (void)updateViewForTimeState;
{
	timePlayedLabel.text = [self secondsToHoursMinutesAndSeconds:audioPlayer.currentTime];
	timeLeftLabel.text = [NSString stringWithFormat:@"-%@", [self secondsToHoursMinutesAndSeconds:audioPlayer.duration - audioPlayer.currentTime]];

	if (updateTimeTimer != nil) {
		songSeekSlider.value = audioPlayer.currentTime;
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


#pragma mark -
#pragma mark UISlider events

- (void)songSeekSliderEditingDidBegin:(id)sender;
{
	ignoreSongSeekSliderValueChange = NO;
	if (updateTimeTimer != nil) {
		[updateTimeTimer invalidate];
		updateTimeTimer = nil;
	}
}

- (void)songSeekSliderEditingDidEnd:(id)sender;
{
	ignoreSongSeekSliderValueChange = YES;
	
	if (updateTimeTimer == nil) {
		updateTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateViewForTimeState) userInfo:nil repeats:YES];
	}
}

- (void)songSeekSliderValueDidChange:(id)sender;
{
	if (ignoreSongSeekSliderValueChange == YES) {
		ignoreSongSeekSliderValueChange = NO;
		return;
	}
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeAudioPlayerCurrentTime) object:nil];
	[self performSelector:@selector(changeAudioPlayerCurrentTime) withObject:nil afterDelay:.5];
}

- (void)changeAudioPlayerCurrentTime;
{
	audioPlayer.currentTime = (int)songSeekSlider.value;
	[self updateViewForTimeState];
}


@end
