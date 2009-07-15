//
//  StorageHTTPConnection.h
//  Humboldt
//
//  Created by Peter Pistorius on 2009/02/06.
//  Copyright 2009 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"HTTPConnection.h"
@class AFMultipartParser;


@interface StorageHTTPConnection : HTTPConnection {

	BOOL requestIsMultipart;
	AFMultipartParser *multipartParser;
	
	int start;
}


- (NSData *)directoryContentsAtURL:(NSString *)url;
- (NSMutableDictionary *)variablesForPostRequest;
- (NSData *)createDirectory:(NSString *)name atPath:(NSString *)path;
- (void)fileUploadComplete;




@end
