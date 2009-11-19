//
//  FileView.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/19.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileView : UIView {

}


- (void)loadFileAtPath:(NSString *)path;
- (void)didRotateInterfaceOrientation;


@end
