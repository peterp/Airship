//
//  DocumentController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/08/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileController.h"
#import "AFWebView.h"


@interface DocumentController : FileController {
	IBOutlet AFWebView *webView;
}

@property (nonatomic, retain) IBOutlet AFWebView *webView;

- (void)openFile:(DirectoryItem *)file;





@end
