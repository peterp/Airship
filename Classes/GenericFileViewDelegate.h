//
//  GenericFileViewDelegate.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/10/25.
//  Copyright 2009 appfactory. All rights reserved.
//

@class GenericFileViewController;


@protocol GenericFileViewDelegate <NSObject>
@optional
	- (void)genericFileViewControllerDidFinish:(GenericFileViewController *)controller;
	- (void)genericFileViewControllerDidPaginate:(UINavigationController *)navigationController toNextFile:(BOOL)nextFile;
@end