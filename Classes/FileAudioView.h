//
//  FileAudioView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/21.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileView.h"

#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@class CALevelMeter;



@interface FileAudioView : FileView <AVAudioPlayerDelegate> {

	
	AVAudioPlayer *audioPlayer;
	
	UIImageView *levelMeterBackground;
	CALevelMeter *levelMeter;
//	UIImageView *levelMeterGlare;

	UISlider *songSeekSlider;
	NSTimer *updateTimeTimer;
	UILabel *timePlayedLabel;
	UILabel *timeLeftLabel;
	BOOL ignoreSongSeekSliderValueChange;
	
	UIButton *playPauseButton;
	
	
	
	UIView	*volumeViewContainer;
	MPVolumeView *volumeView;
	UILabel *volumeLabelMinus;
	UILabel *volumeLabelPlus;
	
	
	
}


@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (nonatomic, retain) UIImageView *levelMeterBackground;
@property (nonatomic, retain) CALevelMeter *levelMeter;
//@property (nonatomic, retain) UIImageView *levelMeterGlare;

@property (nonatomic, retain) UISlider *songSeekSlider;
@property (nonatomic, retain) UILabel *timePlayedLabel;
@property (nonatomic, retain) UILabel *timeLeftLabel;

@property (nonatomic, retain) UIButton *playPauseButton;

@property (nonatomic, retain) UIView *volumeViewContainer;
@property (nonatomic, retain) MPVolumeView *volumeView;
@property (nonatomic, retain) UILabel *volumeLabelMinus;
@property (nonatomic, retain) UILabel *volumeLabelPlus;




- (void)updateViewForAudioPlayerState;
- (void)updateViewForTimeState;
- (NSString *)secondsToHoursMinutesAndSeconds:(long)seconds;

- (void)songSeekSliderEditingDidBegin:(id)sender;
- (void)songSeekSliderEditingDidEnd:(id)sender;
- (void)songSeekSliderValueDidChange:(id)sender;
- (void)changeAudioPlayerCurrentTime;



@end
