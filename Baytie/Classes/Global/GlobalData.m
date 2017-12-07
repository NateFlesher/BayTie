//
//  GlobalData.m
//  ReactChat
//
//  Created by mobidev on 5/16/14.
//  Copyright (c) 2012 mobidev. All rights reserved.
//

#import "GlobalData.h"
#import "Global.h"

GlobalData *_globalData = nil;

@implementation GlobalData
@synthesize appColor = _appColor;
@synthesize statusBarOffset = _statusBarOffset;
@synthesize isFirstStart = _isFirstStart;

@synthesize sessionID = _sessionID;
@synthesize isCBValid = _isCBValid;

@synthesize scbEmail = _scbEmail;
@synthesize scbPassword = _scbPassword;
@synthesize scbValidType = _scbValidType;

// importer class
@synthesize arrSyncContacts = _arrSyncContacts;

//ml class
//@synthesize isFromMenu = _isFromMenu;
@synthesize cbIsFromMenu = _cbIsFromMenu;

+(id) sharedData
{
	@synchronized(self)
    {
        if (_globalData == nil)
        {
            _globalData = [[self alloc] init]; // assignment not done here
        }		
	}
	
	return _globalData;
}

//==================================================================================

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_globalData == nil)
        {
			_globalData = [super allocWithZone:zone];
			
			return _globalData;
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}

//==================================================================================

-(id) init
{
	if ((self = [super init])) {
		// @todo
	}
	
	return self;
}

//==================================================================================

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void) loadInitData
{
    _appColor = [UIColor colorWithRed:119.0f/255.0f green:97.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _isFirstStart = [self readBoolEntry:config key:@"firststart" defaults:YES];
    _isCBValid = [self readBoolEntry:config key:@"cbvalid" defaults:YES];
    
    //importer class
    _arrSyncContacts = [[NSMutableArray alloc] init];
    
    //ml class
//    _isFromMenu = NO;
    _cbIsFromMenu = NO;
}

- (void)setIsFirstStart:(BOOL)isFirstStart
{
    if (_isFirstStart == isFirstStart) {
        return;
    }
    _isFirstStart = isFirstStart;
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setBool:isFirstStart forKey:@"firststart"];
    [config synchronize];
}

- (void)setIsCBValid:(BOOL)isCBValid
{
    if (_isCBValid == isCBValid) {
        return;
    }
    _isCBValid = isCBValid;
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setBool:isCBValid forKey:@"cbvalid"];
    [config synchronize];
}

#pragma mark - Config Manager -
-(BOOL) readBoolEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(BOOL)defaults
{
    if (key == nil)
        return defaults;
    
    NSString *str = [config objectForKey:key];
    
    if (str == nil) {
        return defaults;
    } else {
        return str.boolValue;
    }
    
    return defaults;
}

-(float) readFloatEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(float)defaults
{
    if (key == nil)
        return defaults;
    
    NSString *str = [config objectForKey:key];
    
    if (str == nil) {
        return defaults;
    } else {
        return str.floatValue;
    }
    
    return defaults;
}

-(int) readIntEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(int)defaults
{
    if (key == nil)
        return defaults;
    
    NSString *str = [config objectForKey:key];
    
    if (str == nil) {
        return defaults;
    } else {
        return str.intValue;
    }
    
    return defaults;
}

-(double) readDoubleEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(double)defaults
{
    if (key == nil)
        return defaults;
    
    NSString *str = [config objectForKey:key];
    
    if (str == nil) {
        return defaults;
    } else {
        return str.doubleValue;
    }
    
    return defaults;
}

-(NSString *) readEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(NSString *)defaults
{
    if (key == nil)
        return defaults;
    
    NSString *str = [config objectForKey:key];
    
    if (str == nil) {
        return defaults;
    } else {
        return str;
    }
    
    return defaults;
}

- (NSDictionary *)readDictionaryEntry:(NSUserDefaults *)config key:(NSString *) key defaults:(NSDictionary *)defaults
{
    if (key == nil)
        return defaults;
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[config objectForKey:key]];
    
    if (dic == nil) {
        return defaults;
    } else {
        return dic;
    }
    
    return defaults;
}

- (NSString *)convertDateToString:(NSDate *)aDate format:(NSString *)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if (!format)
        [formatter setDateFormat:@"MMM dd, yyyy"];
    else
        [formatter setDateFormat:format];
    
    return [formatter stringFromDate:aDate];
}

- (NSString *)getCurrentDate:(NSString *)format
{
    NSDate* date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if (!format)
        [formatter setDateFormat:@"MMM dd, yyyy"];
    else
        [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

- (NSString *)getCurrentDateAndTime:(NSString *)format
{
    NSDate* date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if (!format)
        [formatter setDateFormat:@"MMM dd, yyyy"];
    else
        [formatter setDateFormat:format];
    
    NSString* str = [formatter stringFromDate:date];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    
    NSString *currentDateAndTime = [NSString stringWithFormat:@"%@ %@",str,currentTime];
    return currentDateAndTime;
}

@end
