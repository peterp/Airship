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


	UILabel *explinationLabel;
	UILabel *warningLabel;
	
	UIButton *openAudioButton;
	UIButton *openDocumentButton;
	UIButton *openImageButton;
	UIButton *openVideoButton;
	
	int openAsKind;
}



@property (nonatomic, retain) UILabel *explinationLabel;
@property (nonatomic, retain) UILabel *warningLabel;

@property (nonatomic, retain) UIButton *openAudioButton;
@property (nonatomic, retain) UIButton *openDocumentButton;
@property (nonatomic, retain) UIButton *openImageButton;
@property (nonatomic, retain) UIButton *openVideoButton;



- (void)openAsAudio;
- (void)openAsDocument;
- (void)openAsImage;
- (void)openAsVideo;


@end
