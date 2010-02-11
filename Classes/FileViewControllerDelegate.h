//
//  FileViewDelegate.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/25.
//  Copyright 2009 appfactory. All rights reserved.
//

@class FileViewController;


@protocol FileViewControllerDelegate <NSObject>
@optional
	- (void)fileViewControllerDidFinish:(FileViewController *)controller;
	- (void)fileViewControllerDidPaginate:(FileViewController *)controller toNextFile:(BOOL)nextFile;
	- (void)fileViewControllerDidDeleteFile:(FileViewController *)controller;
@end