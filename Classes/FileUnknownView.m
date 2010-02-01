//
//  FileUnknownView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/21.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileUnknownView.h"
#import "File.h"

@implementation FileUnknownView

@synthesize explinationBackground;
@synthesize explinationLabel;
@synthesize warningLabel;
	
@synthesize openAudioButton;
@synthesize openDocumentButton;
@synthesize openImageButton;
@synthesize openVideoButton;

- (void)dealloc;
{
	self.explinationBackground = nil;
	self.explinationLabel = nil;
	self.warningLabel = nil;
	
	self.openAudioButton = nil;
	self.openDocumentButton = nil;
	self.openImageButton = nil;
	self.openVideoButton = nil;

	[super dealloc];
}




- (id)initWithFrame:(CGRect)frame;
{
	if (self = [super initWithFrame:frame]) {
		
		UIImageView *viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ui_fileViewBackground.png"]];
		viewBackground.frame = frame;
		viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self insertSubview:viewBackground atIndex:0];
		[viewBackground release];
		
		
		self.explinationBackground = [[UIView alloc] initWithFrame:CGRectZero];
		explinationBackground.backgroundColor = [UIColor colorWithRed:5/255.0 green:5/255.0 blue:13/255.0 alpha:.69];
		
		[self addSubview:explinationBackground];
		[explinationBackground release];
		
		
		self.explinationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		explinationLabel.numberOfLines = 0;
		explinationLabel.adjustsFontSizeToFitWidth = YES;
		explinationLabel.backgroundColor = [UIColor clearColor];
		explinationLabel.font = [UIFont boldSystemFontOfSize:16];
		explinationLabel.shadowColor = [UIColor blackColor];
		explinationLabel.shadowOffset = CGSizeMake(1,1);
		explinationLabel.textAlignment = UITextAlignmentCenter;
		explinationLabel.textColor = [UIColor  colorWithRed:147/255.0 green:147/255.0 blue:161/255.0 alpha:1];
		
		[explinationBackground addSubview:explinationLabel];
		[explinationLabel release];
		
		
		
		self.openAudioButton = [[UIButton alloc] init];
		openAudioButton.backgroundColor = [UIColor clearColor];
		[openAudioButton addTarget:self action:@selector(openAsAudio) forControlEvents:UIControlEventTouchUpInside];
		[openAudioButton setImage:[UIImage imageNamed:@"ui_openAudio.png"] forState:UIControlStateNormal];
		[self addSubview:openAudioButton];
		[openAudioButton release];
		
		
		self.openDocumentButton = [[UIButton alloc] init];
		openDocumentButton.backgroundColor = [UIColor clearColor];
		[openDocumentButton addTarget:self action:@selector(openAsDocument) forControlEvents:UIControlEventTouchUpInside];
		[openDocumentButton setImage:[UIImage imageNamed:@"ui_openDocument.png"] forState:UIControlStateNormal];
		[self addSubview:openDocumentButton];
		[openDocumentButton release];
		
		self.openImageButton = [[UIButton alloc] init];
		openImageButton.backgroundColor = [UIColor clearColor];
		[openImageButton addTarget:self action:@selector(openAsImage) forControlEvents:UIControlEventTouchUpInside];
		[openImageButton setImage:[UIImage imageNamed:@"ui_openImage.png"] forState:UIControlStateNormal];
		[self addSubview:openImageButton];
		[openImageButton release];
		
		
		self.openVideoButton = [[UIButton alloc] init];
		openVideoButton.backgroundColor = [UIColor clearColor];
		[openVideoButton addTarget:self action:@selector(openAsVideo) forControlEvents:UIControlEventTouchUpInside];
		[openVideoButton setImage:[UIImage imageNamed:@"ui_openVideo.png"] forState:UIControlStateNormal];
		[self addSubview:openVideoButton];
		[openVideoButton release];
  }

	return self;
}


- (void)loadFileAtPath:(NSString *)path;
{
	explinationLabel.text = [NSString stringWithFormat:@"Airship doesn't know how to display \"%@\".\n\nOpen file as...", [path lastPathComponent]];
	[self didStopLoading];
}



- (void)openAs:(int)kind;
{
	if ([self.delegate respondsToSelector:@selector(fileViewDidOpenFileAs:)]) {
	
		[self.delegate fileViewDidOpenFileAs:kind];
	}
}


- (void)openAsAudio;
{
	[self openAs:FILE_KIND_AUDIO];
}
- (void)openAsDocument;
{
	[self openAs:FILE_KIND_DOCUMENT];
}
- (void)openAsImage;
{
	[self openAs:FILE_KIND_IMAGE];
}
- (void)openAsVideo;
{
	[self openAs:FILE_KIND_VIDEO];
}


- (void)layoutSubviews;
{
	CGRect explinationBackgroundRect = CGRectMake(0, 64, 320, 100);
	CGRect explinationLabelRect = CGRectMake(15, 10, 290, 80);

	CGRect openAudioButtonRect = CGRectMake(15, 200, 61, 80);
	CGRect openDocumentButtonRect = CGRectMake(91, 200, 61, 80);
	CGRect openImageButtonRect = CGRectMake(167, 200, 61, 80);
	CGRect openVideoButtonRect = CGRectMake(244, 200, 61, 80);


	if (self.frame.size.height == 320) {
		explinationBackgroundRect = CGRectMake(0, 49, 480, 80);
		explinationLabelRect = CGRectMake(15, 10, 450, 60);
		
		openAudioButtonRect = CGRectMake(50, 170, 61, 80);
		openDocumentButtonRect = CGRectMake(156, 170, 61, 80);
		openImageButtonRect = CGRectMake(262, 170, 61, 80);
		openVideoButtonRect = CGRectMake(369, 170, 61, 80);
	}
	
	
	explinationBackground.frame = explinationBackgroundRect;
	explinationLabel.frame = explinationLabelRect;
	openAudioButton.frame = openAudioButtonRect;
	openDocumentButton.frame = openDocumentButtonRect;
	openImageButton.frame = openImageButtonRect;
	openVideoButton.frame = openVideoButtonRect;
}








@end
