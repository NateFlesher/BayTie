//
//  AppDelegate.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize sessionId, firstName, lastName, emailAddress, mobilePhoneNum,username,language,profileUrl;
@synthesize lstCity, lstFood;
@synthesize lstCityIds, lstFoodIds;

@synthesize access_token, userid, serviceType;

@synthesize strDeviceToken;

@synthesize dayType, currentTime;

@synthesize availableSwippingCellsById;
+(AppDelegate*)sharedDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];  
    }
    
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    UIImage *imgForBack = [ self imageWithColor:[UIColor colorWithRed:107.0f/255.0f green:190.0f/255.0f blue:27.0f/255.0f alpha:1.0f]];
    [navAppearance setBackgroundImage:imgForBack forBarMetrics:UIBarMetricsDefault];
    
    //    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:25.0f], NSFontAttributeName,
    //                                [UIColor colorWithRed:112/255.0f green:91/255.0f blue:131/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];
    //    [navAppearance setTitleTextAttributes:attributes];
    [navAppearance setTintColor:[UIColor whiteColor]];
    [navAppearance setBarTintColor:[UIColor colorWithRed:107.0f/255.0f green:190.0f/255.0f blue:27.0f/255.0f alpha:1.0f]];
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"iTunesMetadata.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        NSLog(@"From App Store!");
    }
    //NSLog(@"Route: %@", TEMP_IMAGE_PATH);
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        
//    }
//    else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
//    
    
    availableSwippingCellsById = [[NSMutableArray alloc] init];
    language = @"eng";
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    dayType = [comps weekday];
    
    NSDate *myDate = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mmaa"];
    currentTime = [dateFormat stringFromDate:myDate];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (NSString *)getFloatToString:(CGFloat)val{
    
    NSInteger tmpVal = floor(val);
    NSInteger remainder = [[NSString stringWithFormat:@"%f", val * 1000] integerValue] % 1000;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    NSString *fitRemainder = @"";
    if (remainder == 0) {
        fitRemainder = @"000";
    }else if (remainder > 0 && remainder < 10){
        fitRemainder = [NSString stringWithFormat:@"%ld00", (long)remainder];
    }else if (remainder > 10 && remainder < 100){
        fitRemainder = [NSString stringWithFormat:@"%ld0", (long)remainder];
    }else if (remainder > 100 && remainder < 1000){
        fitRemainder = [NSString stringWithFormat:@"%ld", (long)remainder];
    }
    
    NSString *print =[NSString stringWithFormat:@"KD %@.%@", [formatter stringFromNumber:[NSNumber numberWithInteger:tmpVal]], fitRemainder];
    return print;
}

- (NSString *)getIntToStringForPoint:(NSInteger)val{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *print =[NSString stringWithFormat:@"%@pt", [formatter stringFromNumber:[NSNumber numberWithInteger:val]]];
    return print;
}
- (NSInteger)secondOfTheDay:(NSDate*)time
{
    NSCalendar* curCalendar = [NSCalendar currentCalendar];
    const unsigned units    = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* comps = [curCalendar components:units fromDate:time];
    NSInteger hour = [comps hour];
    NSInteger min  = [comps minute];
    NSInteger sec  = [comps second];
    
    return ((hour * 60) + min) * 60 + sec;
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)saveLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:[AppDelegate sharedDelegate].sessionId forKey:@"sessionId"];
    [userDefaults setObject:[AppDelegate sharedDelegate].firstName forKey:@"firstName"];
    [userDefaults setObject:[AppDelegate sharedDelegate].lastName forKey:@"lastName"];
    [userDefaults setObject:[AppDelegate sharedDelegate].mobilePhoneNum forKey:@"mobilePhoneNum"];
    [userDefaults setObject:[AppDelegate sharedDelegate].emailAddress forKey:@"emailAddress"];
    //[userDefaults setObject:[AppDelegate sharedDelegate].username forKey:@"username"];
    
    [userDefaults setObject:[AppDelegate sharedDelegate].access_token forKey:@"access_token"];
    [userDefaults setObject:[AppDelegate sharedDelegate].userid forKey:@"userid"];
    [userDefaults setObject:[AppDelegate sharedDelegate].language forKey:@"language"];
    [userDefaults setObject:[AppDelegate sharedDelegate].profileUrl forKey:@"profileUrl"];
    [userDefaults synchronize];
}

- (BOOL)loadLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"access_token"]) {
        //[AppDelegate sharedDelegate].sessionId = [userDefaults objectForKey:@"sessionId"];
        [AppDelegate sharedDelegate].firstName = [userDefaults objectForKey:@"firstName"];
        [AppDelegate sharedDelegate].lastName = [userDefaults objectForKey:@"lastName"];
        [AppDelegate sharedDelegate].mobilePhoneNum = [userDefaults objectForKey:@"mobilePhoneNum"];
        [AppDelegate sharedDelegate].emailAddress = [userDefaults objectForKey:@"emailAddress"];
        //[AppDelegate sharedDelegate].username = [userDefaults objectForKey:@"username"];
        
        [AppDelegate sharedDelegate].access_token = [userDefaults objectForKey:@"access_token"];
        [AppDelegate sharedDelegate].userid = [userDefaults objectForKey:@"userid"];
        [AppDelegate sharedDelegate].language = [userDefaults objectForKey:@"language"];
        [AppDelegate sharedDelegate].profileUrl = [userDefaults objectForKey:@"profileUrl"];
        return YES;
    }
    return NO;
}

- (void)deleteLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   // [userDefaults removeObjectForKey:@"sessionId"];
    [userDefaults removeObjectForKey:@"firstName"];
    [userDefaults removeObjectForKey:@"lastName"];
    [userDefaults removeObjectForKey:@"mobilePhoneNum"];
    [userDefaults removeObjectForKey:@"emailAddress"];
    //[userDefaults removeObjectForKey:@"username"];
    
    [userDefaults removeObjectForKey:@"access_token"];
    [userDefaults removeObjectForKey:@"userid"];
    [userDefaults removeObjectForKey:@"language"];
    [userDefaults removeObjectForKey:@"profileUrl"];
    [userDefaults synchronize];
}
- (void)goToMainView
{
    HomeViewController * viewcontroller = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [controller.navigationBar setTranslucent:NO];
    self.window.rootViewController = controller;
}
-(void)goToSplash{
    LoginViewController *viewcontroller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [controller.navigationBar setTranslucent:NO];
    self.window.rootViewController = controller;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"userinfo----%@",notification.request.content.userInfo);
    
    [self HandlePushNotification:notification.request.content.userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler
{
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
    NSLog(@"%@", response.notification.request.content.userInfo);
    
    [self HandlePushNotification:response.notification.request.content.userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"here");
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //Wang class
    strDeviceToken = [[[[deviceToken description]
                        stringByReplacingOccurrencesOfString: @"<" withString: @""]
                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                      stringByReplacingOccurrencesOfString: @" " withString: @""];
    //Wang class end
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}
- (void)showNotification:(NSString *)msg isChat:(BOOL)isChat isRequest:(BOOL)isRequest isEntityChat:(BOOL)isEntityChat
{
    if (msg && ![msg isEqualToString:@""]) {
        [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
        
        [JCNotificationCenter
         enqueueNotificationWithTitle:@""
         message:msg
         tapHandler:^{
             if (isChat)
                 NSLog(@"");
             else if (isRequest)
                 NSLog(@"");
             else if (isEntityChat)
                 NSLog(@"");
         }];
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
    
    // iOS 10 will handle notifications through other methods
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"10.0" ) )
    {
        NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
        // set a member variable to tell the new delegate that this is background
        //return;
    }
    NSLog(@"userinfo----%@",userInfo);
    [self HandlePushNotification:userInfo];
    
    
    //}];
}
- (void)HandlePushNotification:(NSDictionary *)userInfo{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    if ([AppDelegate sharedDelegate].sessionId == nil)
        return;
    
    NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *type = [userInfo objectForKey:@"type"];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Baytie.Baytie" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Baytie" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Baytie.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSString *) platformType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 CDMA";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (Cellular)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (Cellular)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (Cellular)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (Cellular)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (Cellular)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (Cellular)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (Cellular)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (Cellular)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return @"Unknown";
}

@end
