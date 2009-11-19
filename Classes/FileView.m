//
//  FileView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/11/19.
//  Copyright 2009 appfactory. All rights reserved.
//

#import "FileView.h"


@implementation FileView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}

- (void)loadFileAtPath:(NSString *)path;
{
	// This should never be called...
}
- (void)didRotateInterfaceOrientation;
{
	// This should never be called...
}



@end
