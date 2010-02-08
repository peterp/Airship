//
//  FileUnknownView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/21.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileView.h"

@interface FileUnknownView : FileView {


	UIImageView *explinationBackground;
	UILabel *explinationLabel;
	
	UIButton *openAudioButton;
	UIButton *openDocumentButton;
	UIButton *openImageButton;
	UIButton *openVideoButton;

	UILabel *openAudioLabel;
	UILabel *openDocumentLabel;
	UILabel *openImageLabel;
	UILabel *openVideoLabel;
	
	int openAsKind;
}

@property (nonatomic, retain) UIImageView *explinationBackground;
@property (nonatomic, retain) UILabel *explinationLabel;

@property (nonatomic, retain) UIButton *openAudioButton;
@property (nonatomic, retain) UIButton *openDocumentButton;
@property (nonatomic, retain) UIButton *openImageButton;
@property (nonatomic, retain) UIButton *openVideoButton;

@property (nonatomic, retain) UILabel *openAudioLabel;
@property (nonatomic, retain) UILabel *openDocumentLabel;
@property (nonatomic, retain) UILabel *openImageLabel;
@property (nonatomic, retain) UILabel *openVideoLabel;




- (void)openAsAudio;
- (void)openAsDocument;
- (void)openAsImage;
- (void)openAsVideo;


@end
