//
//  AudioController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/09/05.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FileController.h"


@interface AudioController : FileController <AVAudioPlayerDelegate> {

	AVAudioPlayer *audioPlayer;

	MPVolumeView *volumeView;
	UIView *volumeViewSlider;
	IBOutlet UIView	*volumeViewHolder;


	IBOutlet UIButton *playPauseButton;
	
	
	NSTimer *updateTimeIntervalTimer;
	IBOutlet UILabel *timeTotalLabel;
	IBOutlet UILabel *timeLeftLabel;
	IBOutlet UISlider *songSeekSlider;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UILabel *timeTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, retain) IBOutlet UISlider *songSeekSlider;

- (IBAction)playPauseAudioPlayer;


- (IBAction)songSeekSliderEditingDidBegin;
- (IBAction)songSeekSliderEditingDidEnd:(id)sender;
- (IBAction)songSeekSliderValueChanged;
- (void)updateTimeIntervalViews;
- (NSString *)secondsToHoursMinutesAndSeconds:(long)seconds;




@end
