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
		
		UIImageView *viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_fileViewBackground.png"]];
		viewBackground.frame = frame;
		viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self insertSubview:viewBackground atIndex:0];
		[viewBackground release];
		
		

		
		// Set Audio Session
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

		// Metering
//		self.levelMeter = [[CALevelMeter alloc] initWithFrame:CGRectMake(10, 89, 300, 60)];
//		[self addSubview:levelMeter];
//		[levelMeter release];
		
		
		
		// Sliders
		
		self.songSeekSlider = [[UISlider alloc] initWithFrame:CGRectZero];
		[songSeekSlider addTarget:self action:@selector(songSeekSliderEditingDidBegin:) forControlEvents:UIControlEventTouchDown];
		[songSeekSlider addTarget:self action:@selector(songSeekSliderEditingDidEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
		[songSeekSlider addTarget:self action:@selector(songSeekSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
		[songSeekSlider setMinimumTrackImage:[[UIImage imageNamed:@"ui_sliderTrack.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:0] forState:UIControlStateNormal];
		[songSeekSlider setMaximumTrackImage:[[UIImage imageNamed:@"ui_sliderTrack.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:0] forState:UIControlStateNormal];
		[songSeekSlider setThumbImage:[UIImage imageNamed:@"ui_sliderThumb.png"] forState:UIControlStateNormal];
		[self addSubview:songSeekSlider];
		[songSeekSlider release];

		self.timeLeftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		timeLeftLabel.textColor = [UIColor colorWithRed:61/255.0 green:62/255.0 blue:81/255.0 alpha:1];
		timeLeftLabel.text = @"-00:00";
		timeLeftLabel.backgroundColor = [UIColor clearColor];
		timeLeftLabel.adjustsFontSizeToFitWidth = YES;
		timeLeftLabel.textAlignment = UITextAlignmentRight;
		timeLeftLabel.font = [UIFont systemFontOfSize:12];
		
		self.timePlayedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		timePlayedLabel.textColor = [UIColor colorWithRed:61/255.0 green:62/255.0 blue:81/255.0 alpha:1];
		timePlayedLabel.text = @"00:00";
		timePlayedLabel.backgroundColor = [UIColor clearColor];
		timePlayedLabel.adjustsFontSizeToFitWidth = YES;
		timePlayedLabel.font = [UIFont systemFontOfSize:12];
		[self addSubview:timePlayedLabel];
		[timePlayedLabel release];
		
		[self addSubview:timeLeftLabel];
		[timeLeftLabel release];
		

		// playPauseButton;
		self.playPauseButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[playPauseButton addTarget:self action:@selector(playPauseButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		[playPauseButton setImage:[UIImage imageNamed:@"ui_buttonPause.png"] forState:UIControlStateNormal];
		[self addSubview:playPauseButton];
		[playPauseButton release];
		
		
		// Volume
		self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
		volumeView.backgroundColor = [UIColor whiteColor];
		[self addSubview:volumeView];
		[volumeView release];
		
		// Volume customisation
		
		}
	return self;
}


- (void)layoutSubviews;
{
	
	
	CGRect levelMeterRect = CGRectMake(10, 89, 300, 60);
	CGRect songSeekSliderRect = CGRectMake(60, 170, 200, 20);
	CGRect timeLeftLabelRect = CGRectMake(10, 170, 45, 16);
	CGRect timePlayedLabelRect = CGRectMake(265, 170, 45, 16);
	CGRect playPauseButtonRect = CGRectMake(125, 217, 70, 70);	
	CGRect volumeViewRect = CGRectMake(60, 370, 200, 20);
	

	
	if (self.frame.size.height == 320) {
		
		levelMeterRect = CGRectMake(20, 64, 440, 60);
		songSeekSliderRect = CGRectMake(60, 140, 360, 20);
		timeLeftLabelRect = CGRectMake(10, 140, 45, 16);
		timePlayedLabelRect = CGRectMake(425, 140, 45, 16);
		playPauseButtonRect = CGRectMake(205, 170, 70, 70);
		volumeViewRect = CGRectMake(90, 260, 300, 20);
	}
	
	[levelMeter setPlayer:nil];
	[levelMeter removeFromSuperview];
	self.levelMeter = nil;
	
	
	songSeekSlider.frame = songSeekSliderRect;
	timeLeftLabel.frame = timeLeftLabelRect;
	timePlayedLabel.frame = timePlayedLabelRect;
	playPauseButton.frame = playPauseButtonRect;
	volumeView.frame = volumeViewRect;
	
	
	self.levelMeter = [[CALevelMeter alloc] initWithFrame:levelMeterRect];
	[levelMeter setPlayer:audioPlayer];
	[self addSubview:levelMeter];
	[levelMeter release];
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
			songSeekSlider.minimumValue = 0;
			songSeekSlider.maximumValue = audioPlayer.duration;

			[audioPlayer play];
			[self updateViewForAudioPlayerState];
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
	if (updateTimeTimer) {
		[updateTimeTimer invalidate];
	}


	if (audioPlayer.playing == YES) {
	
		[playPauseButton setImage:[UIImage imageNamed:@"ui_buttonPause.png"] forState:UIControlStateNormal];
		[levelMeter setPlayer:audioPlayer];
		updateTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateViewForTimeState) userInfo:nil repeats:YES];
		
	} else {
		
		[playPauseButton setImage:[UIImage imageNamed:@"ui_buttonPlay.png"] forState:UIControlStateNormal];
		[levelMeter setPlayer:nil];
		updateTimeTimer = nil;
	}
}

- (void)updateViewForTimeState;
{
	// We're not dragging...
	if (updateTimeTimer != nil) {
		songSeekSlider.value = audioPlayer.currentTime;
	}
	
	NSLog(@"playing from: %f", audioPlayer.currentTime);

	timePlayedLabel.text = [self secondsToHoursMinutesAndSeconds:songSeekSlider.value];
	timeLeftLabel.text = [NSString stringWithFormat:@"-%@", [self secondsToHoursMinutesAndSeconds:audioPlayer.duration - songSeekSlider.value]];
}




#pragma mark -
#pragma mark AVAudioPlayer delegate methods


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
	// Update timers.
	[self updateViewForTimeState];
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
	
	[self updateViewForTimeState];


	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeAudioPlayerCurrentTime) object:nil];
	[self performSelector:@selector(changeAudioPlayerCurrentTime) withObject:nil afterDelay:.5];
}




- (void)changeAudioPlayerCurrentTime;
{
	NSLog(@"please play from: %f", songSeekSlider.value);

	[audioPlayer pause];
	[audioPlayer setCurrentTime:songSeekSlider.value];
	[audioPlayer prepareToPlay];
	[audioPlayer play];
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



@end
