//
//  AudioViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/15.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#import "GenericFileViewController.h"


@interface AudioViewController : GenericFileViewController <AVAudioPlayerDelegate> {


	AVAudioPlayer *audioPlayer;

	MPVolumeView *volumeView;
	IBOutlet UIView	*volumeViewHolder;
	IBOutlet UIButton *playPauseButton;
	
	
	NSTimer *updateTimeIntervalTimer;
	IBOutlet UILabel *timeTotalLabel;
	IBOutlet UILabel *timeLeftLabel;
	IBOutlet UISlider *songSeekSlider;

}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (nonatomic, retain) IBOutlet UIView	*volumeViewHolder;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;


@property (nonatomic, retain) IBOutlet UILabel *timeTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, retain) IBOutlet UISlider *songSeekSlider;


- (IBAction)playPauseAudioPlayer;
- (void)getID3Tags;

- (IBAction)songSeekSliderEditingDidBegin;
- (IBAction)songSeekSliderEditingDidEnd:(id)sender;
- (IBAction)songSeekSliderValueChanged;
- (void)updateTimeIntervalViews;
- (NSString *)secondsToHoursMinutesAndSeconds:(long)seconds;


@end
