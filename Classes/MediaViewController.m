//
//  MediaViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DirectoryItem.h"


@implementation MediaViewController

- (void)dealloc 
{
	[super dealloc];
}


- (void)openFile:(DirectoryItem *)file
{
	// Init the movie player...
	
	if ([file.type isEqualToString:@"video"]) {
		
		MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:file.path]];
		moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
		moviePlayer.movieControlMode = MPMovieControlModeDefault;
		
		// register the playback finished notification.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
		[moviePlayer play];
	} else if ([file.type isEqualToString:@"audio"]) {
	
		
		AVAudioPlayer *audioPlayer =  [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:file.path] error:NULL];
//		[audioPlayer setDelegate:self];
		[audioPlayer prepareToPlay];
		BOOL plays = [audioPlayer play];

	}
}

// When the movie is done,release the controller. 
-(void)moviePlayerFinishedCallback:(NSNotification*)aNotification 
{
	MPMoviePlayerController *moviePlayer= [aNotification object]; 
  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer]; 
  [moviePlayer release];
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


@end
