//
//  StorageViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileManager;


@interface StorageViewController : UITableViewController {
	FileManager *fileManager;
}

@end
