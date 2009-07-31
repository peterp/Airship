//
//  MediaViewController.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DirectoryItem.h"


@implementation MediaViewController

- (void)dealloc 
{
	[super dealloc];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
}


- (void)openFile:(DirectoryItem *)file
{
	// Init the movie player...
		MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:file.path]];
		moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
		moviePlayer.movieControlMode = MPMovieControlModeDefault;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
		[moviePlayer play];
}

// When the movie is done,release the controller. 
-(void)moviePlayerFinishedCallback:(NSNotification*)aNotification 
{
	MPMoviePlayerController *moviePlayer= [aNotification object];
	// must be some simpler code to remove this.
  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer]; 
	
	[moviePlayer stop];
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
