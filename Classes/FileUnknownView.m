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


@synthesize openAudioLabel;
@synthesize openDocumentLabel;
@synthesize openImageLabel;
@synthesize openVideoLabel;

- (void)dealloc;
{
	self.explinationBackground = nil;
	self.explinationLabel = nil;
	self.warningLabel = nil;
	
	self.openAudioButton = nil;
	self.openDocumentButton = nil;
	self.openImageButton = nil;
	self.openVideoButton = nil;
	
	self.openAudioLabel = nil;
	self.openDocumentLabel = nil;
	self.openImageLabel = nil;
	self.openVideoLabel = nil;

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
		[openAudioButton setImage:[UIImage imageNamed:@"ui_buttonAudio.png"] forState:UIControlStateNormal];
		[openAudioButton setImage:[UIImage imageNamed:@"ui_buttonAudioHighlight.png"] forState:UIControlStateHighlighted];
		[self addSubview:openAudioButton];
		[openAudioButton release];
		
		self.openDocumentButton = [[UIButton alloc] init];
		openDocumentButton.backgroundColor = [UIColor clearColor];
		[openDocumentButton addTarget:self action:@selector(openAsDocument) forControlEvents:UIControlEventTouchUpInside];
		[openDocumentButton setImage:[UIImage imageNamed:@"ui_buttonDocument.png"] forState:UIControlStateNormal];
		[openDocumentButton setImage:[UIImage imageNamed:@"ui_buttonDocumentHighlight.png"] forState:UIControlStateHighlighted];
		[self addSubview:openDocumentButton];
		[openDocumentButton release];
		
		self.openImageButton = [[UIButton alloc] init];
		openImageButton.backgroundColor = [UIColor clearColor];
		[openImageButton addTarget:self action:@selector(openAsImage) forControlEvents:UIControlEventTouchUpInside];
		[openImageButton setImage:[UIImage imageNamed:@"ui_buttonImage.png"] forState:UIControlStateNormal];
		[openImageButton setImage:[UIImage imageNamed:@"ui_buttonImageHighlight.png"] forState:UIControlStateHighlighted];
		[self addSubview:openImageButton];
		[openImageButton release];
		
		
		self.openVideoButton = [[UIButton alloc] init];
		openVideoButton.backgroundColor = [UIColor clearColor];
		[openVideoButton addTarget:self action:@selector(openAsVideo) forControlEvents:UIControlEventTouchUpInside];
		[openVideoButton setImage:[UIImage imageNamed:@"ui_buttonVideo.png"] forState:UIControlStateNormal];
		[openVideoButton setImage:[UIImage imageNamed:@"ui_buttonVideoHighlight.png"] forState:UIControlStateHighlighted];
		[self addSubview:openVideoButton];
		[openVideoButton release];
		
		
		self.openAudioLabel = [[UILabel alloc] init];
		openAudioLabel.text = @"Audio";
		openAudioLabel.font = [UIFont systemFontOfSize:12];
		openAudioLabel.textAlignment = UITextAlignmentCenter;
		openAudioLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:openAudioLabel];
		
		self.openDocumentLabel = [[UILabel alloc] init];
		openDocumentLabel.text = @"Document";
		openDocumentLabel.font = [UIFont systemFontOfSize:12];
		openDocumentLabel.textAlignment = UITextAlignmentCenter;
		openDocumentLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:openDocumentLabel];
		
		self.openImageLabel = [[UILabel alloc] init];
		openImageLabel.text = @"Image";
		openImageLabel.font = [UIFont systemFontOfSize:12];
		openImageLabel.textAlignment = UITextAlignmentCenter;
		openImageLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:openImageLabel];
		
		self.openVideoLabel = [[UILabel alloc] init];
		openVideoLabel.text = @"Video";
		openVideoLabel.font = [UIFont systemFontOfSize:12];
		openVideoLabel.textAlignment = UITextAlignmentCenter;
		openVideoLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:openVideoLabel];
		
		
  }

	return self;
}


- (void)loadFileAtPath:(NSString *)path;
{
	explinationLabel.text = [NSString stringWithFormat:@"Airship doesn't know how to open \"%@\".\n\nTry to open file as...", [path lastPathComponent]];
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

	CGRect openAudioButtonRect = CGRectMake(15, 200, 65, 65);
	CGRect openDocumentButtonRect = CGRectMake(91, 200, 65, 65);
	CGRect openImageButtonRect = CGRectMake(167, 200, 65, 65);
	CGRect openVideoButtonRect = CGRectMake(244, 200, 65, 65);
	
	
	CGRect openAudioLabelRect = CGRectMake(15, 265, 65, 20);
	CGRect openDocumentLabelRect = CGRectMake(91, 265, 65, 20);
	CGRect openImageLabelRect = CGRectMake(167, 265, 65, 20);
	CGRect openVideoLabelRect = CGRectMake(244, 265, 65, 20);
	

	if (self.frame.size.height == 320) {
		explinationBackgroundRect = CGRectMake(0, 49, 480, 80);
		explinationLabelRect = CGRectMake(15, 10, 450, 60);
		
		openAudioButtonRect = CGRectMake(50, 170, 65, 65);
		openDocumentButtonRect = CGRectMake(156, 170, 65, 65);
		openImageButtonRect = CGRectMake(262, 170, 65, 65);
		openVideoButtonRect = CGRectMake(369, 170, 65, 65);
		
		
		openAudioLabelRect = CGRectMake(50, 235, 65, 20);
		openDocumentLabelRect = CGRectMake(156, 235, 65, 20);
		openImageLabelRect = CGRectMake(262, 235, 65, 20);
		openVideoLabelRect = CGRectMake(369, 235, 65, 20);
		
	}
	
	
	explinationBackground.frame = explinationBackgroundRect;
	explinationLabel.frame = explinationLabelRect;
	openAudioButton.frame = openAudioButtonRect;
	openDocumentButton.frame = openDocumentButtonRect;
	openImageButton.frame = openImageButtonRect;
	openVideoButton.frame = openVideoButtonRect;
	
	
	openAudioLabel.frame = openAudioLabelRect;
	openDocumentLabel.frame = openDocumentLabelRect;
	openImageLabel.frame = openImageLabelRect;
	openVideoLabel.frame = openVideoLabelRect;
}








@end
