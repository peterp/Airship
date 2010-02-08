//
//  FileVideoView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/25.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileView.h"


@class MPMoviePlayerController;

@interface FileVideoView : FileView {
	UIButton *playButton;
	MPMoviePlayerController *moviePlayerController;
	NSString *moviePath;
	UILabel *playLabel;
	
	UIImageView *explinationBackground;
	UILabel *explinationLabel;
}

@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UILabel *playLabel;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, copy) NSString *moviePath;

- (void)playVideo:(UIButton *)sender;
- (void)moviePlayerFinishedCallback:(NSNotification*)notification;


@end
