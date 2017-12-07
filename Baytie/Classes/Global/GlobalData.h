//
//  GlobalData.h
//  ReactChat
//
//  Created by mobidev on 5/16/14.
//  Copyright (c) 2012 mobidev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject

@property (nonatomic, strong) UIColor *appColor;
@property (nonatomic) int statusBarOffset;
@property (nonatomic) BOOL isFirstStart;

@property (nonatomic, strong) NSString *sessionID;
//@property (nonatomic, strong) NSString *userID;
@property (nonatomic) BOOL isCBValid;

//setup contact builder
@property (nonatomic, strong) NSString *scbEmail;
@property (nonatomic, strong) NSString *scbPassword;
@property (nonatomic) int scbValidType;

//importer class
@property (nonatomic, retain) NSMutableArray *arrSyncContacts;

//ml class
//@property (nonatomic) BOOL isFromMenu;
@property (nonatomic) BOOL cbIsFromMenu;

@property (nonatomic, strong) UIImage *imgHomeProflePhoto;
@property (nonatomic, strong) UIImage *imgWorkProflePhoto;

@property (nonatomic, strong) NSString *strHomeProfilePhoto;
@property (nonatomic, strong) NSString *strWorkProfilePhoto;

@property (nonatomic, strong) NSString *strEntityPhoto;
@property (nonatomic, strong) NSString *strAddEntityPhoto;

+ (id) sharedData;

- (void)loadInitData;

-(BOOL) readBoolEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(BOOL)defaults;
-(float) readFloatEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(float)defaults;
-(int) readIntEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(int)defaults;
-(double) readDoubleEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(double)defaults;
-(NSString *) readEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(NSString *)defaults;
- (NSDictionary *)readDictionaryEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(NSDictionary *)defaults;

- (NSString *)convertDateToString:(NSDate *)aDate format:(NSString *)format;
- (NSString *)getCurrentDate:(NSString *)format;
- (NSString *)getCurrentDateAndTime:(NSString *)format;

#define DATE_FORMAT @"MM-dd-yyyy HH:mm:ss"
#define TEMP_IMAGE_PATH [NSTemporaryDirectory() stringByAppendingString:@"/image.jpg"]

@end
