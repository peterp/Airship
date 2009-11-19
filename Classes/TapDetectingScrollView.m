//
//  TapDetectingScrollView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TapDetectingScrollView.h"


@implementation TapDetectingScrollView

@synthesize tapDetectingDelegate;

- (void)dealloc;
{
	
	self.tapDetectingDelegate = nil;

	[super dealloc];
	
	
}

- (id)initWithFrame:(CGRect)frame;
{
	return [super initWithFrame:frame];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	if (!self.dragging) {
		//[self.nextResponder touchesEnded:touches withEvent:event]; 
		if ([self.tapDetectingDelegate respondsToSelector:@selector(TapDetectingScrollViewWasTapped:)]) {
			[self.tapDetectingDelegate TapDetectingScrollViewWasTapped:self];
		}
	} else {
		
		[super touchesEnded:touches withEvent:event];
		
		
			
	}
}

@end
