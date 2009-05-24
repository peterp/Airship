//
//  DirectoryTableViewController.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/05/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DirectoryTableViewController : UITableViewController {

	NSString *relativePath;
	NSString *absolutePath;
	
	NSMutableArray *directoryContents;
}

@property (nonatomic, retain) NSString *relativePath;
@property (nonatomic, retain) NSString *absolutePath;
@property (nonatomic, retain) NSMutableArray *directoryContents;


@end
