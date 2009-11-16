//
//  AFWebView.m
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <objc/runtime.h>
#import "TapDetectingWebView.h"

#define DOUBLE_TAP_DELAY 0.35


@interface TapDetectingWebView ()
- (void)handleSingleTap;
- (void)handleDoubleTap;
//- (void)handleTwoFingerTap;
@end



@interface NSObject (UIWebViewTappingDelegate)
//- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
//- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event;


- (void)tapDetectingWebViewGotSingleTap:(TapDetectingWebView *)aWebView;
- (void)tapDetectingWebViewGotDoubleTap:(TapDetectingWebView *)aWebView;

@end



@implementation UIView (__TapHook)

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{


- (void)__touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self __touchesEnded:touches withEvent:event];
	
	id webView = [[self superview] superview];
	UITouch *touch = [touches anyObject];
 
 
	if ([touch tapCount] == 1) {
		// Single tap... pass on
		[webView performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
	} else if([touch tapCount] == 2) {
		// Doubletap, ignore...
		[NSObject cancelPreviousPerformRequestsWithTarget:webView selector:@selector(handleSingleTap) object:nil];
	}
	
	
//	- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
//	{
//	if (!self.dragging) {
//		[self.nextResponder touchesEnded:touches withEvent:event]; 
//	} else {
//		[super touchesEnded:touches withEvent:event];
//	}
//	}
	
	
}

@end

static BOOL hookInstalled = NO;

static void installHook()
{
	if (hookInstalled) return;
	
	hookInstalled = YES;
	
	Class klass = objc_getClass("UIWebDocumentView");
	Method targetMethod = class_getInstanceMethod(klass, @selector(touchesEnded:withEvent:));
	Method newMethod = class_getInstanceMethod(klass, @selector(__touchesEnded:withEvent:));
	method_exchangeImplementations(targetMethod, newMethod);
}

@implementation TapDetectingWebView





- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
		installHook();
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		installHook();
    }
    return self;
}




- (void)handleSingleTap
{
	if ([self.delegate respondsToSelector:@selector(tapDetectingWebViewGotSingleTap:)]) {
		[(NSObject *)self.delegate tapDetectingWebViewGotSingleTap:self];
	}
}

- (void)handleDoubleTap
{
//	if ([self.delegate respondsToSelector:@selector(tapDetectingWebViewGotDoubleTap:)]) {
//		[(NSObject *)self.delegate tapDetectingWebViewGotDoubleTap:self];
//	}
}

@end