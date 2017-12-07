//
//  AppDelegate.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>

@class LoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain) NSString *strDeviceToken;

+(AppDelegate*)sharedDelegate;
@property (strong, nonatomic) LoginViewController *viewController;

@property (nonatomic,retain) NSString *sessionId;
@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *mobilePhoneNum;
@property (nonatomic,retain) NSString *emailAddress;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *language;
@property (nonatomic,retain) NSString *profileUrl;

@property NSInteger serviceType; // 1:Delivery 2:Catering 3:Reservation 4:Pickup


@property (nonatomic,retain) NSArray *lstCity;
@property (nonatomic,retain) NSArray *lstFood;
@property (nonatomic,retain) NSArray *lstCityIds;
@property (nonatomic,retain) NSArray *lstFoodIds;


@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, retain) NSString *userid;

@property (nonatomic, retain) NSMutableArray *availableSwippingCellsById;

//2:Monday 3:Tuesday 4:Wednesday 5:Thursday 6:Friday 7:Saturday 1:Sunday
@property NSInteger dayType;
@property (nonatomic, retain) NSString *currentTime;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)saveLoginData;
- (BOOL)loadLoginData;
- (void)deleteLoginData;

- (void)goToMainView;
- (void)goToSplash;
- (NSString *)platformType;

- (NSString *)getFloatToString:(CGFloat)val;
- (NSString *)getIntToStringForPoint:(NSInteger)val;
- (NSInteger)secondOfTheDay:(NSDate*)time;
@end

