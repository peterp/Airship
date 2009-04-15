//
//  StorageHTTPConnection.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"HTTPConnection.h"


@interface StorageHTTPConnection : HTTPConnection {
	
	BOOL fileUpload;
	BOOL fileUploadHeader;
	int  fileUploadDataStartIndex;
	NSMutableArray* multipartData;
	//BOOL postHeaderOK;
}

// dealing with getting query variables....
- (NSMutableDictionary *)getQueryVariables:(NSString *)query escapePercentages:(BOOL)escape;
- (NSObject *)responseWithString:(NSString *)responseString;


// dealing with files...
- (NSString *)getRelativePath:(NSString *)path;
- (NSString *)getDirectoryItems:(NSString *)path;


@end
