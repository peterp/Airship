//
//  MediaViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/07/26.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DirectoryItem;

@interface MediaViewController : UIViewController {
}

- (void)openFile:(DirectoryItem *)file;

@end
