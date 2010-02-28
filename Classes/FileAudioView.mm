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

@synthesize levelMeterBackground;
@synthesize levelMeter;
//@synthesize levelMeterGlare;

@synthesize playPauseButton;
@synthesize songSeekSlider;

@synthesize timePlayedLabel;
@synthesize timeLeftLabel;

@synthesize volumeViewContainer;
@synthesize volumeView;
@synthesize volumeLabelMinus;
@synthesize volumeLabelPlus;




- (void)dealloc;
{
	self.audioPlayer = nil;
	
	self.levelMeter = nil;
	self.levelMeterBackground = nil;
//	self.levelMeterGlare = nil;
	
	self.playPauseButton = nil;

	self.songSeekSlider = nil;
	self.timePlayedLabel = nil;
	self.timeLeftLabel = nil;
	
	self.volumeViewContainer = nil;
	self.volumeView = nil;
	self.volumeLabelMinus = nil;
	self.volumeLabelPlus = nil;

	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame;
{
	if (self = [super initWithFrame:frame]) {
		
		
		// Set Audio Session
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

		
		UIImageView *viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_fileViewBackground.png"]];
		viewBackground.frame = frame;
		viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self insertSubview:viewBackground atIndex:0];
		[viewBackground release];
		
		
		// Level Meter
		self.levelMeterBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:levelMeterBackground];
		[levelMeterBackground release];

//		self.levelMeterGlare = [[UIImageView alloc] initWithFrame:CGRectZero];
//		[levelMeterBackground addSubview:levelMeterGlare];
//		[levelMeterGlare release];
		
		
		
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
		[playPauseButton setImage:[UIImage imageNamed:@"ui_buttonPauseHighlight.png"] forState:UIControlStateHighlighted];
		[self addSubview:playPauseButton];
		[playPauseButton release];
		
		
		// Volume
		self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
//		volumeView.backgroundColor = [UIColor whiteColor];
		[self addSubview:volumeView];
		[volumeView release];
		
		// Volume customisation
		for (UIView *view in volumeView.subviews) {
			if ([[view class] isSubclassOfClass:[UISlider class]]) {
				UISlider *volumeSlider = (UISlider*)view;
				[volumeSlider setMinimumTrackImage:songSeekSlider.currentMinimumTrackImage forState:UIControlStateNormal];
				[volumeSlider setMaximumTrackImage:songSeekSlider.currentMaximumTrackImage forState:UIControlStateNormal];
				[volumeSlider setThumbImage:songSeekSlider.currentThumbImage forState:UIControlStateNormal];
			}
		}
		
		
		self.volumeLabelMinus = [[UILabel alloc] initWithFrame:CGRectZero];
		volumeLabelMinus.textColor = [UIColor colorWithRed:61/255.0 green:62/255.0 blue:81/255.0 alpha:1];
		volumeLabelMinus.text = @"-";
		volumeLabelMinus.backgroundColor = [UIColor clearColor];
		volumeLabelMinus.adjustsFontSizeToFitWidth = YES;
		volumeLabelMinus.font = [UIFont boldSystemFontOfSize:13];
		volumeLabelMinus.textAlignment = UITextAlignmentCenter;
	//	volumeLabelMinus.backgroundColor = [UIColor blackColor];
		[self addSubview:volumeLabelMinus];
		[volumeLabelMinus release];
		
		self.volumeLabelPlus = [[UILabel alloc] initWithFrame:CGRectZero];
		volumeLabelPlus.textColor = [UIColor colorWithRed:61/255.0 green:62/255.0 blue:81/255.0 alpha:1];
		volumeLabelPlus.text = @"+";
		volumeLabelPlus.backgroundColor = [UIColor clearColor];
		volumeLabelPlus.adjustsFontSizeToFitWidth = YES;
		volumeLabelPlus.font = [UIFont boldSystemFontOfSize:13];
		volumeLabelPlus.textAlignment = UITextAlignmentCenter;
//		volumeLabelPlus.backgroundColor = [UIColor blackColor];
		[self addSubview:volumeLabelPlus];
		[volumeLabelPlus release];
		
		

		
	}
	return self;
}


- (void)layoutSubviews;
{
	CGRect levelMeterRect;
	[levelMeter setPlayer:nil];
	[levelMeter removeFromSuperview];
	self.levelMeter = nil;
	
	
	
	if (self.frame.size.width == 320) {
		
		levelMeterBackground.frame = CGRectMake(15, 89, 290, 50);
		levelMeterBackground.image = [UIImage imageNamed:@"ui_levelMeter290.png"];
//		levelMeterGlare.frame = CGRectMake(3, 3, 284, 44);
//		levelMeterGlare.image = [UIImage imageNamed:@"ui_levelMeter290Glare.png"];
		levelMeterRect = CGRectMake(5, 5, 280, 40);
		
		songSeekSlider.frame = CGRectMake(60, 170, 200, 20);
		timeLeftLabel.frame = CGRectMake(10, 170, 45, 16);
		timePlayedLabel.frame = CGRectMake(265, 170, 45, 16);
		
		playPauseButton.frame = CGRectMake(125, 217, 70, 70);
		volumeView.frame = CGRectMake(60, 370, 200, 20);
		volumeLabelMinus.frame = CGRectMake(60, 365, 10, 10);
		volumeLabelPlus.frame = CGRectMake(250, 365, 10, 10);
	} else {
		
		levelMeterBackground.frame = CGRectMake(20, 64, 440, 50);
		levelMeterBackground.image = [UIImage imageNamed:@"ui_levelMeter440.png"];
//		levelMeterGlare.frame = CGRectMake(3, 3, 434, 44);
//		levelMeterGlare.image = [UIImage imageNamed:@"ui_levelMeter440Glare.png"];
		levelMeterRect = CGRectMake(5, 5, 430, 40);
		
		songSeekSlider.frame = CGRectMake(60, 140, 360, 20);
		timeLeftLabel.frame = CGRectMake(10, 140, 45, 16);
		timePlayedLabel.frame = CGRectMake(425, 140, 45, 16);
		
		playPauseButton.frame = CGRectMake(205, 170, 70, 70);
		volumeView.frame = CGRectMake(90, 255, 300, 20);
		volumeLabelMinus.frame = CGRectMake(90, 250, 10, 10);
		volumeLabelPlus.frame = CGRectMake(380, 250, 10, 10);

	}
	
	self.levelMeter = [[CALevelMeter alloc] initWithFrame:levelMeterRect];
	[levelMeter setPlayer:audioPlayer];
	[levelMeterBackground addSubview:levelMeter];
//	[levelMeterBackground insertSubview:levelMeter belowSubview:levelMeterGlare];
	[levelMeter release];
}






- (void)loadFileAtPath:(NSString *)path;
{
	
	// if the audio play is not null? That means that something very bad has happened....
	// Should we pause for a second and try again later?

	if (self.audioPlayer != nil) {
		[self.audioPlayer stop];
		self.audioPlayer = nil;
	}
	
		// Create the audio player
		self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
		audioPlayer.delegate = self;
		audioPlayer.volume = 1;
		audioPlayer.meteringEnabled = YES;
	
		if (audioPlayer == nil) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"A problem occured whilst trying to play the audio file \"%@.\"", [path lastPathComponent]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
			
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
	[audioPlayer pause];
	[levelMeter setPlayer:nil];
	[audioPlayer stop];
	
	
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
		[playPauseButton setImage:[UIImage imageNamed:@"ui_buttonPauseHighlight.png"] forState:UIControlStateHighlighted];
		[levelMeter setPlayer:audioPlayer];
		updateTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateViewForTimeState) userInfo:nil repeats:YES];
		
	} else {
		
		[playPauseButton setImage:[UIImage imageNamed:@"ui_buttonPlay.png"] forState:UIControlStateNormal];
		[playPauseButton setImage:[UIImage imageNamed:@"ui_buttonPlayHighlight.png"] forState:UIControlStateHighlighted];
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
