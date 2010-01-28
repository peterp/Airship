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

@synthesize explinationLabel;
@synthesize warningLabel;
	
@synthesize openAudioButton;
@synthesize openDocumentButton;
@synthesize openImageButton;
@synthesize openVideoButton;

- (void)dealloc;
{
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
	

		self.explinationLabel = [[UILabel alloc] init];

		explinationLabel.textAlignment = UITextAlignmentCenter;
		explinationLabel.numberOfLines = 0;
		explinationLabel.font = [UIFont systemFontOfSize:16];
		explinationLabel.textColor = [UIColor blackColor];
		explinationLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:explinationLabel];
		[explinationLabel release];
		
		
		
		self.openAudioButton = [[UIButton alloc] init];
		openAudioButton.backgroundColor = [UIColor blackColor];
		[openAudioButton addTarget:self action:@selector(openAsAudio) forControlEvents:UIControlEventTouchUpInside];
		[openAudioButton setTitle:@"A" forState:UIControlStateNormal];
		[self addSubview:openAudioButton];
		[openAudioButton release];
		
		
		self.openDocumentButton = [[UIButton alloc] init];
		openDocumentButton.backgroundColor = [UIColor blackColor];
		[openDocumentButton addTarget:self action:@selector(openAsDocument) forControlEvents:UIControlEventTouchUpInside];
		[openDocumentButton setTitle:@"D" forState:UIControlStateNormal];
		[self addSubview:openDocumentButton];
		[openDocumentButton release];
		
		self.openImageButton = [[UIButton alloc] init];
		openImageButton.backgroundColor = [UIColor blackColor];
		[openImageButton addTarget:self action:@selector(openAsImage) forControlEvents:UIControlEventTouchUpInside];
		[openImageButton setTitle:@"I" forState:UIControlStateNormal];
		[self addSubview:openImageButton];
		[openImageButton release];
		
		
		self.openVideoButton = [[UIButton alloc] init];
		openVideoButton.backgroundColor = [UIColor blackColor];
		[openVideoButton addTarget:self action:@selector(openAsVideo) forControlEvents:UIControlEventTouchUpInside];
		[openVideoButton setTitle:@"V" forState:UIControlStateNormal];
		[self addSubview:openVideoButton];
		[openVideoButton release];
  }

	return self;
}


- (void)loadFileAtPath:(NSString *)path;
{
	explinationLabel.text = [NSString stringWithFormat:@"airship doesn't know how to display the file\n\"%@\".", [path lastPathComponent]];
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

	CGRect explinationLabelRect = CGRectMake(5, 64, self.frame.size.width - 10, 52);

	CGRect openAudioButtonRect = CGRectMake(30, 140, 100, 100);
	CGRect openDocumentButtonRect = CGRectMake(190, 140, 100, 100);
	CGRect openImageButtonRect = CGRectMake(30, 300, 100, 100);
	CGRect openVideoButtonRect = CGRectMake(190, 300, 100, 100);


	if (self.frame.size.height == 320) {
		explinationLabelRect.origin.y = 55;

		openAudioButtonRect = CGRectMake(30, 150, 82.5, 82.5);
		openDocumentButtonRect = CGRectMake(142.5, 150, 82.5, 82.5);
		openImageButtonRect = CGRectMake(255, 150, 82.5, 82.5);
		openVideoButtonRect = CGRectMake(367.5, 150, 82.5, 82.5);
	}
	
	explinationLabel.frame = explinationLabelRect;
	openAudioButton.frame = openAudioButtonRect;
	openDocumentButton.frame = openDocumentButtonRect;
	openImageButton.frame = openImageButtonRect;
	openVideoButton.frame = openVideoButtonRect;
}








@end
