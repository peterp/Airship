//
//  AudioViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "AudioViewController.h"


@implementation AudioViewController

@synthesize audioPlayer;

@synthesize playPauseButton;
@synthesize volumeViewHolder;

@synthesize timeTotalLabel;
@synthesize timeLeftLabel;
@synthesize songSeekSlider;


- (void)dealloc 
{
	self.audioPlayer = nil;
	
	self.playPauseButton = nil;
	self.volumeViewHolder = nil;
	
	
	self.timeTotalLabel = nil;
	self.timeLeftLabel = nil;
	self.songSeekSlider = nil;


	[super dealloc];
}
- (void)viewDidLoad
{
	// load navigation + toolbar
	[super viewDidLoad];

	[self.activityIndicator stopAnimating];
	[self.activityIndicator removeFromSuperview];
	self.activityIndicator = nil;

	
	
	// remove timer that hides "navigation bar" automatically.
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBarsAfterDelay) object:nil];

//
//	toolbar.frame = CGRectMake(0, 362, 320, 118);
//	
//	// remove and re-add, possible?
//	[toolbar addSubview:playPauseButton];
//	playPauseButton.frame = CGRectMake(140, 15, 40, 30);
//	[toolbar addSubview:volumeViewHolder];
//	volumeViewHolder.frame = CGRectMake(25, 64, 270, 23);
//	
//	
//	
//	// check to see if we can read the ID3 tags...
//	[self getID3Tags];
//
//	
//	
//	// MARGLE.
//	UILabel *titleMainLabel = (UILabel *)[navigationBar.topItem.titleView viewWithTag:1001];
//	titleMainLabel.text = @"Margle";
//	
	

	
	
	// audio session category
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
	
	

	// need to add our own thingums.
	NSError *outError;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:storageItem.absolutePath] error:&outError];
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
	
	[audioPlayer play];
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




- (void)unloadViewController;
{
	[updateTimeIntervalTimer invalidate];
	updateTimeIntervalTimer = nil;
	[super unloadViewController];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	NSLog(@"%@", [error description]);
}


- (void)getID3Tags;
{
	AudioFileID fileID = nil;
  OSStatus err = noErr;
	
	err = AudioFileOpenURL((CFURLRef)[NSURL fileURLWithPath:storageItem.absolutePath], kAudioFileReadPermission, 0, &fileID);
  if( err != noErr ) {
		NSLog( @"AudioFileOpenURL failed" );
	}
	
	UInt32 id3DataSize = 0;
  char *rawID3Tag = NULL;

  err = AudioFileGetPropertyInfo( fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL );
  if (err != noErr) {
		NSLog(@"AudioFileGetPropertyInfo failed for ID3 tag");
  }
	
	NSLog(@"id3 data size is %d bytes", id3DataSize);

	rawID3Tag = (char *) malloc( id3DataSize );
	if (rawID3Tag == NULL) {
		NSLog(@"could not allocate %d bytes of memory for ID3 tag", id3DataSize);
	}
	
	
		
	CFDictionaryRef piDict = nil;
	UInt32 piDataSize = sizeof(piDict);

	err = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
	if (err != noErr) {
		NSLog( @"AudioFileGetProperty failed for property info dictionary" );
	}
	
  NSLog( @"property info: %@", (NSDictionary*)piDict );
	
	
	CFRelease(piDict);
  free(rawID3Tag);
	
}



@end
