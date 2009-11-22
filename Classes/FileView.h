//
//  FileView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/19.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FileViewDelegate <NSObject>
@optional

	- (void)fileViewDidOpenFileAs:(int)kind;
	- (void)fileViewDidStartLoading;
	- (void)fileViewDidStopLoading;
@end



@interface FileView : UIView {

		id <FileViewDelegate> delegate;


}

@property (nonatomic, retain) id <FileViewDelegate> delegate;


- (void)loadFileAtPath:(NSString *)path;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

- (void)didStartLoading;
- (void)didStopLoading;


@end
