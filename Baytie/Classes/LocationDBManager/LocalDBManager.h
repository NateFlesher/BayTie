//
//  LocalDBManager.h
//  ginko
//
//  Created by STAR on 11/13/15.
//  Copyright © 2015 com.xchangewithme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSBubbleData;

@interface LocalDBManager : NSObject {
}

// Helper method for getting shared instance
+ (LocalDBManager *)sharedManager;
// Get target cached file name for given server file path
+ (NSString *)getCachedFileNameFromRemotePath:(NSString *)url;

// Return the path of cached file from given server file path, nil if not saved
+ (NSString *)checkCachedFileExist:(NSString *)url;

+ (void)saveImage:(UIImage *)image forRemotePath:(NSString *)url;

+ (void)saveData:(NSData *)data forRemotePath:(NSString *)url;


@end
