//
//  LocalDBManager.m
//  ginko
//
//  Created by STAR on 11/13/15.
//  Copyright © 2015 com.xchangewithme. All rights reserved.
//

#import "LocalDBManager.h"
#import "AppDelegate.h"

@implementation LocalDBManager {
    NSManagedObjectContext *managedObjectContext;
}


+ (LocalDBManager *)sharedManager {
    static LocalDBManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        managedObjectContext = [AppDelegate sharedDelegate].managedObjectContext;
    }
    
    return self;
}

+ (NSString *)getCachedFileNameFromRemotePath:(NSString *)url {
    NSString *localFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[url lastPathComponent]];
    
    return localFilePath;
}

+ (NSString *)checkCachedFileExist:(NSString *)url {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *localFilePath = [LocalDBManager getCachedFileNameFromRemotePath:url];
    
    if ([fileManager fileExistsAtPath:localFilePath])
        return localFilePath;
    
    return nil;
}

+ (void)saveImage:(UIImage *)image forRemotePath:(NSString *)url {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    [LocalDBManager saveData:data forRemotePath:url];
}

+ (void)saveData:(NSData *)data forRemotePath:(NSString *)url {
    [data writeToFile:[LocalDBManager getCachedFileNameFromRemotePath:url] atomically:YES];
}

@end