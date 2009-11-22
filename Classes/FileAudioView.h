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
	CALevelMeter *levelMeter;
	NSTimer *updateMeteringInterfaceTimer;

	UIView	*volumeViewContainer;
	MPVolumeView *volumeView;
	UIButton *playPauseButton;
	UISlider *songSeekSlider;
	
	
	
	NSTimer *updateTimer;
	UILabel *timePlayedLabel;
	UILabel *timeLeftLabel;
	
}


@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) CALevelMeter *levelMeter;

@property (nonatomic, retain) UIView *volumeViewContainer;
@property (nonatomic, retain) MPVolumeView *volumeView;
@property (nonatomic, retain) UIButton *playPauseButton;
@property (nonatomic, retain) UISlider *songSeekSlider;


@property (nonatomic, retain) UILabel *timePlayedLabel;
@property (nonatomic, retain) UILabel *timeLeftLabel;


- (void)updateViewForAudioPlayerState;

- (NSString *)secondsToHoursMinutesAndSeconds:(long)seconds;


@end
