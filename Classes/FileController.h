//
//  FileController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectoryItem.h"


@interface FileController : UIViewController {


	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UIToolbar *toolBar;

	NSTimer *hideControlsTimer;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;


- (void)openFile:(DirectoryItem *)file;

- (IBAction)closeFile;


- (void)toggleControls;
- (void)hideControls:(NSTimer*)aTimer;


@end
