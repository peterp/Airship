//
//  AudioController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/09/05.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AudioController.h"






@implementation AudioController

@synthesize audioPlayer;
@synthesize playPauseButton;
@synthesize timeTotalLabel;
@synthesize timeLeftLabel;
@synthesize songSeekSlider;

- (void)dealloc 
{
	self.audioPlayer = nil;

	self.playPauseButton = nil;
	
	self.timeTotalLabel = nil;
	self.timeLeftLabel = nil;
	self.songSeekSlider = nil;

	[super dealloc];
}

- (void)viewDidLoad
{
	// load navigation + toolbar
	[super viewDidLoad];
	// remove timer that hides "navigation bar" automatically.
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToolBarsAfterDelay) object:nil];
	[activityIndicatorView stopAnimating];
	self.activityIndicatorView = nil;
	[toolBar removeFromSuperview];
	
	
	// check to see if we can read the ID3 tags...

	
	
	// MARGLE.
	UILabel *titleMainLabel = (UILabel *)[navigationBar.topItem.titleView viewWithTag:1001];
	titleMainLabel.text = @"Margle";
	
	

	
	
	// audio session category
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
	
	

	// need to add our own thingums.
	NSError *outError;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:directoryItem.path] error:&outError];
	audioPlayer.volume = 1;
  audioPlayer.delegate = self;
	
	if (audioPlayer == nil) {
		NSLog(@"%@", [outError description]);
	} else {
		[audioPlayer prepareToPlay];
		//[audioPlayer play];
	}
	
	
	volumeView = [[MPVolumeView alloc] initWithFrame:volumeViewHolder.bounds];
	[volumeView sizeToFit];
	[volumeViewHolder addSubview:volumeView];
	[volumeView release];
	
	
	// Find the volume view slider, match our seeking style to the volume view's slider.
	for (UIView *view in [volumeView subviews]) {
		if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {
		
			UISlider *volumeViewSlider = (UISlider *)view;
			[songSeekSlider setThumbImage:[volumeViewSlider thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
			[songSeekSlider setMaximumTrackImage:[volumeViewSlider maximumTrackImageForState:UIControlStateNormal] forState:UIControlStateNormal];
			[songSeekSlider setMinimumTrackImage:[volumeViewSlider minimumTrackImageForState:UIControlStateNormal] forState:UIControlStateNormal];
		}
 }
 
 

	
	songSeekSlider.minimumValue = 0;
	songSeekSlider.maximumValue = audioPlayer.duration;
	[self updateTimeIntervalViews];
	updateTimeIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeIntervalViews) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[audioPlayer stop];
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];

}


- (IBAction)playPauseAudioPlayer
{
	if (audioPlayer.playing) {
		[audioPlayer pause];
		playPauseButton.titleLabel.text = @"Pause";
	} else {

		[audioPlayer play];
		playPauseButton.titleLabel.text = @"Play";
	}
}

- (IBAction)songSeekSliderEditingDidBegin
{
	NSLog(@"begin");
	if (updateTimeIntervalTimer != nil) {
		[updateTimeIntervalTimer invalidate];
		updateTimeIntervalTimer = nil;
	}
}

- (IBAction)songSeekSliderEditingDidEnd:(id)sender
{
	NSLog(@"end");
	if (updateTimeIntervalTimer == nil) {
		updateTimeIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeIntervalViews) userInfo:nil repeats:YES];
	}
}

- (IBAction)songSeekSliderValueChanged;
{
	audioPlayer.currentTime = (int)songSeekSlider.value;
	timeTotalLabel.text = [self secondsToHoursMinutesAndSeconds:audioPlayer.currentTime];
	timeLeftLabel.text = [@"-" stringByAppendingString:[self secondsToHoursMinutesAndSeconds:audioPlayer.duration - audioPlayer.currentTime]];
}

- (void)updateTimeIntervalViews
{
	timeTotalLabel.text = [self secondsToHoursMinutesAndSeconds:audioPlayer.currentTime];
	timeLeftLabel.text = [@"-" stringByAppendingString:[self secondsToHoursMinutesAndSeconds:audioPlayer.duration - audioPlayer.currentTime]];
	songSeekSlider.value = audioPlayer.currentTime;
}

- (NSString *)secondsToHoursMinutesAndSeconds:(long)seconds
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








- (IBAction)unloadView
{
	[updateTimeIntervalTimer invalidate];
	updateTimeIntervalTimer = nil;
	[super unloadView];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	NSLog(@"%@", [error description]);
}




@end

















