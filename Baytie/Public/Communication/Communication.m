//
//  Communication.m
//  ChatAndMapSample
//
//  Created by stepanekdavid on 2/12/16.
//  Copyright © 2016 stepanekdavid. All rights reserved.
//

#import "Communication.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>

//#define SERVER_URL                  @"https://aamassetinq.com/ginko"
//#define SERVER_URL                  @"http://payzlitch.bargainspecialists.com/payzlitch/social"
//#define SERVER_URL                  @"http://www.estatesalesinw.com/routetrade/V1"

//#define SERVER_URL                  @"http://payzlitch.bargainspecialists.com/payzlitch"

//#define SERVER_URL              @"http://mataam.net/api"
//#define SERVER_KEY              @"d2674fdde6321f01b6af860739fa4ade"

//#define SERVER_URL              @"http://35.162.120.123/api"
#define SERVER_URL              @"http://82.223.68.80/api"

#define WEBAPI_USERLOGIN                @"/login"
#define WEBAPI_USERS					@"/users"
#define WEBAPI_CHECKTOKEN               @"/check_token"
#define WEBAPI_DEVICE                   @"/devices"
#define WEBAPI_SENDSMSCODE              @"/users/send_sms_code"
#define WEBAPI_VERIFYSMSCODE            @"/users/verify_sms_code"

#define WEBAPI_USERPROFILEUPDATE        @"/users/profile"
#define WEBAPI_CHANGEMOBILENO           @"/users/change_mobile_no"
#define WEBAPI_USERSUBSCRIPTION         @"/users/subscription"
#define WEBAPI_CHANGEPASSWORD           @"/users/change_password"
#define WEBAPI_GETUSERSME               @"/users/me"
#define WEBAPI_USERSUPLOADIMAGE         @"/users/upload_image"
#define WEBAPI_USERSADDRESS             @"/users/address"
#define WEBAPI_USERLANGUAGE             @"/users/language"

//city, area, foodtype, cusines, category apis
#define WEBAPI_LOCATIONCITIES           @"/data/cities"
#define WEBAPI_LOCATIONAREAS            @"/data/areas"
#define WEBAPI_TYPECUISINES             @"/data/cuisines"
#define WEBAPI_TYPEFOODTYPE             @"/data/food_types"
#define WEBAPI_TYPERESTORCATEGORIES     @"/data/restro_categories"
#define WEBAPI_ADVERTISEMENTS           @"/data/advertisements"
#define WEBAPI_FAQS                     @"/data/faqs"

//RESTAURANT APIS
#define WEBAPI_GETRESTAURATNSFILTER     @"/restaurants"
#define WEBAPI_RESTAURANTSRATING        @"/restaurants/ratings"
#define WEBAPI_RESTAURANTSITEMCATEGORIES    @"/restaurants/item_categories"
#define WEBAPI_RESTAURANTSITEMS         @"/restaurants/items"
#define WEBAPI_RESTAURANTSPROMOTIONS    @"/restaurants/promotions"

//order cart
#define WEBAPI_RESTAURANTSORDERSCART    @"/orders/cart"
#define WEBAPI_GETORDERSPOINT           @"/orders/point"
#define WEBAPI_GETORDERSDISCOUNT        @"/orders/discount"
#define WEBAPI_GETORDERSSUM             @"/orders/sum"
#define WEBAPI_ORDERS                   @"/orders"
#define WEBAPI_ORDERSRESERVE            @"/orders/reserve"
#define WEBAPI_ORDERSTIMES              @"/orders/times"
#define WEBAPI_ORDERSMYPOINTS           @"/orders/my_points"


@implementation Communication

#pragma mark - Shared Functions
+ (Communication*)sharedManager
{
    __strong static Communication* sharedObject = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once( &onceToken, ^{
        sharedObject = [[Communication alloc]init];
    });
    
    return sharedObject ;
}

#pragma mark - SocialCommunication
- (id)init
{
    self = [super init];
    
    if( self )
    {
        
    }
    
    return self ;
}
- (void)sendToService:(NSDictionary*)_params
               action:(NSString*)_action
              success:(void (^)( id _responseObject))_success
              failure:(void (^)( NSError* _error))_failure
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL,_action];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager.requestSerializer setTimeoutInterval:180];
    
    [manager POST:strUrl parameters:_params success:^(AFHTTPRequestOperation *operation, id _responseObject){
        
        if( _success )
        {
            _success( _responseObject);
            NSLog(@"success data");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
        if( _failure )
        {
            NSLog(@"%@",_error.description);
            _failure( _error);
            
        }
    }];
}
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
                  mediaType:(NSInteger)_mediaType // 0: photo, 1: video
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure{


}
- (void)sendToServiceGet:(NSDictionary*)_params
                  action:(NSString*)_action
                 success:(void (^)( id _responseObject))_success
                 failure:(void (^)( NSError* _error))_failure
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL,_action];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager GET:strUrl parameters:_params success:^(AFHTTPRequestOperation *operation, id _responseObject){
        
        if( _success )
        {
            _success( _responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
        if( _failure )
        {
            NSLog(@"%@",_error.description);
            _failure( _error);
        }
    }];
}
- (void)sendToServicePut:(NSDictionary*)_params
                  action:(NSString*)_action
                 success:(void (^)( id _responseObject))_success
                 failure:(void (^)( NSError* _error))_failure
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL,_action];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager PUT:strUrl parameters:_params success:^(AFHTTPRequestOperation *operation, id _responseObject){
        
        if( _success )
        {
            _success( _responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
        if( _failure )
        {
            NSLog(@"%@",_error.description);
            _failure( _error);
            
        }
    }];
}
- (void)sendToServiceDelete:(NSDictionary*)_params
                  action:(NSString*)_action
                 success:(void (^)( id _responseObject))_success
                 failure:(void (^)( NSError* _error))_failure
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL,_action];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager setRequestSerializer:requestSerializer];
    
    [manager DELETE:strUrl parameters:_params success:^(AFHTTPRequestOperation *operation, id _responseObject){
        
        if( _success )
        {
            _success( _responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
        if( _failure )
        {
            NSLog(@"%@",_error.description);
            _failure( _error);
            
        }
    }];
}
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
                  mediaType:(NSInteger)_mediaType // 0: photo, 1: video
                       name:(NSString *)name
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL,serviceAPIURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager setRequestSerializer:requestSerializer];
    NSDate *currentime = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *imagefileName = [dateformatter stringFromDate:currentime];
    
    NSDictionary *parameters = _params;
    [manager POST:strUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (_media) {
            if (_mediaType == 0) {
                
                [formData appendPartWithFileData:_media
                                            name:name
                                        fileName:[NSString stringWithFormat:@"Jella-%@.jpg",imagefileName]
                                        mimeType:@"image/jpeg"];
            } else {
                [formData appendPartWithFileData:_media
                                            name:name
                                        fileName:name
                                        mimeType:@"video/quicktime"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Success ;
        if (_success) {
            _success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // Failture ;
        if (_failure) {
            _failure(error);
        }
        
    }];
}
- (void)sendToServiceJSON:(NSString *)action
                   params:(NSDictionary *)_params
                  success:(void (^)(id _responseObject))_success
                  failure:(void (^)(NSError *_error))_failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"gs4c0gcsc0g00c4w0kco8wo8scg488g0sgo04cwk" forHTTPHeaderField:@"X-API-KEY"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager POST:action parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Success ;
        if (_success)
        {
            _success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog( @"Error:%@", error.description);
        
        // Failture ;
        if (_failure)
        {
            _failure(error);
        }
    }];
}

//user apis
- (void)UserLogin:(NSString*)_driverPhoneNum
        driverPwd:(NSString*)_driverPwd
         deviceID:(NSString*)_deviceID
       deviceType:(NSString*)_deviceType
        successed:(void (^)( id _responseObject))_success
          failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject : _driverPhoneNum     forKey : @"mobile_no"];
    [params setObject : _driverPwd          forKey : @"password"];
    //[params setObject:@"0"                  forKey:@"ttl"];
    //[params setObject:_deviceID			forKey:@"device_token"];
    //[params setObject:_deviceType			forKey:@"UDID"];
    
    [self sendToService:params action:WEBAPI_USERLOGIN success:_success failure:_failure ];
}
- (void)SignUP:(NSString*)_mobileNumber
     firstName:(NSString *)_firstName
      lastName:(NSString *)_lastName
  userPassword:(NSString*)_userPassword
     userEmail:(NSString*)_userEmail
      deviceID:(NSString*)_deviceID
    deviceType:(NSString*)_deviceType
     successed:(void (^)( id _responseObject))_success
       failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    //NSString *nsKey = SERVER_KEY;
    
    [params setObject:_mobileNumber				forKey:@"mobile_no"];
    [params setObject:_firstName         forKey:@"f_name"];
    [params setObject:_lastName         forKey:@"l_name"];
    [params setObject:_userPassword			forKey:@"password"];
    [params setObject:_userEmail			forKey:@"email"];
    //[params setObject:_deviceID			forKey:@"device_token"];
    //[params setObject:_deviceType			forKey:@"UDID"];
    
    [self sendToService:params action:WEBAPI_USERS success:_success failure:_failure ];
}
- (void)SendSMScode:(NSString*)_userId
          mobileNum:(NSString *)_mobileNum
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject:_mobileNum				forKey:@"mobile_no"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_SENDSMSCODE, _userId] success:_success failure:_failure ];
}
- (void)VerifySMScode:(NSString*)_userId
            mobileNum:(NSString *)_mobileNum
                 code:(NSString *)_code
            successed:(void (^)( id _responseObject))_success
              failure:(void (^)( NSError* _error))_failure{
    
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject:_mobileNum        forKey:@"mobile_no"];
    [params setObject:_code				forKey:@"code"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_VERIFYSMSCODE, _userId] success:_success failure:_failure ];
}
- (void)CheckSession:(NSString *)_accesstoken
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure {
    NSDictionary *params = @{@"access_token": _accesstoken};
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_CHECKTOKEN,_accesstoken] success:_success failure:_failure ];
}

- (void)registerDevice:(NSString *)_accesstoken
              deviceid:(NSString*)_deviceId
            devicetype:(NSString*)_deviceType
           devicetoken:(NSString*)_deviceToken
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure {
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject : _deviceId     forKey : @"device_id"];
    [params setObject : _deviceType   forKey : @"device_type"];
    [params setObject : _deviceToken   forKey : @"device_token"];
    //[params setObject : @(1)   forKey : @"dev_mode"];
    [params setObject : @(0)   forKey : @"dev_mode"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_DEVICE, _accesstoken]success:_success failure:_failure ];
    
}

- (void)GetUsersMe:(NSString *)_accesstoken
         successed:(void (^)( id _responseObject))_success
           failure:(void (^)( NSError* _error))_failure{
    NSDictionary *params = @{@"access_token": _accesstoken};
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_GETUSERSME,_accesstoken] success:_success failure:_failure ];
}
- (void)UploadProfieImage:(NSString*)_accesstoken
                    image:(NSData*)_image
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure{
    NSDictionary *params = @{@"access_token": _accesstoken};

    [self sendToServiceByPOST:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_USERSUPLOADIMAGE,_accesstoken] params:params media:_image mediaType:0 name:@"profile_pic" success:_success failure:_failure];
}
- (void)SaveUserAddress:(NSString *)_accesstoken
              addressId:(NSString *)_addressId
            addressName:(NSString*)_addressName
                 cityId:(NSString*)_cityId
                 areaId:(NSString*)_areaId
                 street:(NSString*)_street
                  block:(NSString*)_block
                  house:(NSString*)_house
                  floor:(NSString*)_floor
             appartment:(NSString*)_appartment
        extraDirections:(NSString*)_extraDirections
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    if ([_addressId integerValue] != 0) {
        [params setObject:@([_addressId integerValue])        forKey:@"id"];
    }
    [params setObject:_addressName        forKey:@"address_name"];
    [params setObject:@([_cityId integerValue])        forKey:@"city_id"];
    [params setObject:@([_areaId integerValue])        forKey:@"area_id"];
    [params setObject:_street        forKey:@"street"];
    [params setObject:_block        forKey:@"block"];
    [params setObject:_house        forKey:@"house"];
    [params setObject:_floor        forKey:@"floor"];
    [params setObject:_appartment        forKey:@"appartment"];
    [params setObject:_extraDirections        forKey:@"extra_directions"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_USERSADDRESS,_accesstoken] success:_success failure:_failure ];
}
- (void)GetUserAddress:(NSString *)_accesstoken
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure{
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_USERSADDRESS,_accesstoken] success:_success failure:_failure ];
}
- (void)SetLanguage:(NSString *)_accesstoken
           language:(NSString *)_language
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject:_language        forKey:@"language"];
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_USERLANGUAGE,_accesstoken] success:_success failure:_failure ];
}


//menu apis
- (void)UpdateProfile:(NSString*)_accessToken
            firstName:(NSString *)_firstName
             lastName:(NSString *)_lastName
            userEmail:(NSString*)_userEmail
           homeNumber:(NSString*)_homeNumber
         mobileNumber:(NSString*)_mobileNumber
               gender:(NSInteger)_gender
            birthdate:(NSString*)_birthdate
            successed:(void (^)( id _responseObject))_success
              failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject:_firstName        forKey:@"f_name"];
    [params setObject:_lastName        forKey:@"l_name"];
    [params setObject:_userEmail        forKey:@"email"];
    [params setObject:_mobileNumber        forKey:@"mobile_no"];
    [params setObject:_homeNumber        forKey:@"home_number"];
    [params setObject:@(_gender)        forKey:@"gender"];
    [params setObject:_birthdate        forKey:@"birthdate"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_USERPROFILEUPDATE,_accessToken] success:_success failure:_failure ];
}

- (void)ChangeMobileNo:(NSString*)_accessToken
            oldMobileNo:(NSString *)_oldMobileNo
             newMobileNo:(NSString *)_newMobileNo
            successed:(void (^)( id _responseObject))_success
              failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject:_oldMobileNo        forKey:@"old_mobile_no"];
    [params setObject:_newMobileNo        forKey:@"new_mobile_no"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_CHANGEMOBILENO,_accessToken] success:_success failure:_failure ];
}
- (void)ChangePassword:(NSString*)_accessToken
           oldPassword:(NSString *)_oldPassword
           newPassword:(NSString *)_newPassword
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject:_oldPassword        forKey:@"old_password"];
    [params setObject:_newPassword        forKey:@"new_password"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_CHANGEPASSWORD,_accessToken] success:_success failure:_failure ];
}
- (void)UpdateSubscription:(NSString*)_accessToken
              notification:(BOOL)_notification
                    smsSub:(BOOL)_smsSub
                  emailSub:(BOOL)_emailSub
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    [params setObject:_notification?@"true":@"false"        forKey:@"old_mobile_no"];
    [params setObject:_smsSub?@"true":@"false"        forKey:@"new_mobile_no"];
    [params setObject:_emailSub?@"true":@"false"        forKey:@"new_mobile_no"];
    
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_USERSUBSCRIPTION,_accessToken] success:_success failure:_failure ];
}

//city, area, foodtype, cusines, category apis
- (void)GetCityList:(NSString *)_accessToken
            keyWord:(NSString *)_keyWord
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_LOCATIONCITIES,_accessToken] success:_success failure:_failure];
}
- (void)GetAreaList:(NSString *)_accessToken
            keyWord:(NSString *)_keyWord
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_LOCATIONAREAS,_accessToken] success:_success failure:_failure];
}
- (void)GetCuisineList:(NSString *)_accessToken
               keyWord:(NSString *)_keyWord
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_TYPECUISINES,_accessToken] success:_success failure:_failure];
}
- (void)GetFoodType:(NSString *)_accessToken
            keyWord:(NSString *)_keyWord
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_TYPEFOODTYPE,_accessToken] success:_success failure:_failure];
}
- (void)GetRestroCategory:(NSString *)_accessToken
                  keyWord:(NSString *)_keyWord
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_TYPERESTORCATEGORIES,_accessToken] success:_success failure:_failure];
}
- (void)GetAdvertisements:(NSString *)_accessToken
                     kind:(NSInteger)_kind
                     page:(NSInteger)_page
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure{
    
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@",WEBAPI_ADVERTISEMENTS] success:_success failure:_failure];
}
- (void)GetFAQS:(NSString *)_accessToken
           page:(NSInteger)_page
      successed:(void (^)( id _responseObject))_success
        failure:(void (^)( NSError* _error))_failure{
    
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@",WEBAPI_FAQS] success:_success failure:_failure];
}


//restaurant apis
- (void)FindRestrestaurants:(NSString *)_accesstoken
                 restroArea:(NSInteger)_restroArea
                   cuisines:(NSString *)_cuisines
                  foodTypes:(NSString *)_foodTypes
           restroCategories:(NSString *)_restroCategories
                serviceType:(NSInteger)_serviceType
                  successed:(void (^)( id _responseObject))_success
                    failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    //[params setObject : _restroCity         forKey : @"restro_city"] ;
    [params setObject : @(_restroArea)         forKey : @"area"] ;
    [params setObject : _cuisines           forKey : @"cuisines"] ;
    [params setObject : _foodTypes          forKey : @"food_types"] ;
    [params setObject : _restroCategories   forKey : @"restro_categories"] ;
    [params setObject : @(_serviceType)        forKey : @"service_type"] ;
    
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&area=%ld&cuisines=%@&food_types=%@&restro_categories=%@&service_type=%ld",WEBAPI_GETRESTAURATNSFILTER,_accesstoken, (long)_restroArea, _cuisines, _foodTypes, _restroCategories, (long)_serviceType] success:_success failure:_failure ];
}
- (void)FindRestrestaurantsForReserve:(NSString *)_accesstoken
                           restroArea:(NSInteger)_restroArea
                             cuisines:(NSString *)_cuisines
                            foodTypes:(NSString *)_foodTypes
                     restroCategories:(NSString *)_restroCategories
                          serviceType:(NSInteger)_serviceType
                          reserveTime:(NSString *)_reserveTime
                          peopleNumber:(NSInteger)_peopleNumber
                  successed:(void (^)( id _responseObject))_success
                    failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    //[params setObject : _restroCity         forKey : @"restro_city"] ;
    [params setObject : @(_restroArea)         forKey : @"area"] ;
    [params setObject : _cuisines           forKey : @"cuisines"] ;
    [params setObject : _foodTypes          forKey : @"food_types"] ;
    [params setObject : _restroCategories   forKey : @"restro_categories"] ;
    [params setObject : @(_serviceType)        forKey : @"service_type"] ;
    [params setObject : _reserveTime        forKey : @"reserve_time"] ;
    [params setObject : @(_peopleNumber)        forKey : @"people_number"] ;
    
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&area=%ld&cuisines=%@&food_types=%@&restro_categories=%@&service_type=%ld&reserve_time=%@&people_number=%ld",WEBAPI_GETRESTAURATNSFILTER,_accesstoken, (long)_restroArea, _cuisines, _foodTypes, _restroCategories, (long)_serviceType, _reserveTime, (long)_peopleNumber] success:_success failure:_failure ];
}
- (void)FindRestrestaurantsForCatering:(NSString *)_accesstoken
                           restroArea:(NSInteger)_restroArea
                             cuisines:(NSString *)_cuisines
                            foodTypes:(NSString *)_foodTypes
                     restroCategories:(NSString *)_restroCategories
                          serviceType:(NSInteger)_serviceType
                          reserveDate:(NSString *)_reserveDate
                            successed:(void (^)( id _responseObject))_success
                              failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    //[params setObject : _restroCity         forKey : @"restro_city"] ;
    [params setObject : @(_restroArea)         forKey : @"area"] ;
    [params setObject : _cuisines           forKey : @"cuisines"] ;
    [params setObject : _foodTypes          forKey : @"food_types"] ;
    [params setObject : _restroCategories   forKey : @"restro_categories"] ;
    [params setObject : @(_serviceType)        forKey : @"service_type"] ;
    [params setObject : _reserveDate        forKey : @"reserve_time"] ;
    
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&area=%ld&cuisines=%@&food_types=%@&restro_categories=%@&service_type=%ld&reserve_time=%@",WEBAPI_GETRESTAURATNSFILTER,_accesstoken, (long)_restroArea, _cuisines, _foodTypes, _restroCategories, (long)_serviceType, _reserveDate] success:_success failure:_failure ];
}
- (void)GetRestaurantInfos:(NSString *)_accesstoken
                  restroId:(NSInteger)_restro_id
                locationId:(NSInteger)_locationId
               serviceType:(NSInteger)_serviceType
                 successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_restro_id)         forKey : @"id"] ;
    [params setObject : @(_locationId)         forKey : @"location_id"] ;
    [params setObject : @(_serviceType)         forKey : @"service_type"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@/%ld?access_token=%@&location_id=%ld&service_type=%ld",WEBAPI_GETRESTAURATNSFILTER,(long)_restro_id,_accesstoken,(long)_locationId, (long)_serviceType] success:_success failure:_failure];
}
- (void)GetRestaurantsRating:(NSString *)_accesstoken
                  locationId:(NSInteger)_locationId
                  restroId:(NSInteger)_restroId
                   successed:(void (^)( id _responseObject))_success
                     failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_locationId)         forKey : @"location_id"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@/%ld/ratings?access_token=%@&location_id=%ld",WEBAPI_GETRESTAURATNSFILTER,(long)_restroId,_accesstoken, (long)_locationId] success:_success failure:_failure];
}
- (void)SetRestaurantsRating:(NSString *)_accesstoken
                  locationId:(NSInteger)_locationId
                   starValue:(NSInteger)_starValue
                    restroId:(NSInteger)_restroId
                         msg:(NSString *)_msg
                   successed:(void (^)( id _responseObject))_success
                     failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_locationId)         forKey : @"location_id"] ;
    [params setObject : @(_starValue)         forKey : @"star_value"] ;
    [params setObject : _msg         forKey : @"msg"] ;
    [self sendToService:params action:[NSString stringWithFormat:@"%@/%ld/ratings?access_token=%@",WEBAPI_GETRESTAURATNSFILTER,(long)_restroId, _accesstoken] success:_success failure:_failure];
}
- (void)GetRestaurantsItemCategories:(NSString *)_accesstoken
                          locationId:(NSInteger)_locationId
                          serviceId:(NSInteger)_serviceId
                   successed:(void (^)( id _responseObject))_success
                     failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_locationId)         forKey : @"location_id"] ;
    [params setObject : @(_serviceId)         forKey : @"service_id"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&location_id=%ld&service_id=%ld",WEBAPI_RESTAURANTSITEMCATEGORIES,_accesstoken, (long)_locationId, (long)_serviceId] success:_success failure:_failure];
}
- (void)GetRestaurantsAllFood:(NSString *)_accesstoken
                   categoryId:(NSInteger)_categoryId
                    successed:(void (^)( id _responseObject))_success
                      failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_categoryId)         forKey : @"category_id"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&category_id=%ld",WEBAPI_RESTAURANTSITEMS,_accesstoken, (long)_categoryId] success:_success failure:_failure];
}
- (void)GetRestaurantsFoodItem:(NSString *)_accesstoken
                    foodItemId:(NSInteger)_foodItemId
                     successed:(void (^)( id _responseObject))_success
                       failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_foodItemId)         forKey : @"id"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@/%@?access_token=%@",WEBAPI_RESTAURANTSITEMS,[NSString stringWithFormat:@"%ld",(long)_foodItemId], _accesstoken] success:_success failure:_failure];
}
- (void)GetRestaurantsPromotions:(NSString *)_accesstoken
                        restroId:(NSInteger)_restroId
                      locationId:(NSInteger)_locationId
                       serviceId:(NSInteger)_serviceId
                       successed:(void (^)( id _responseObject))_success
                         failure:(void (^)( NSError* _error))_failure{
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_RESTAURANTSPROMOTIONS, _accesstoken] success:_success failure:_failure];
}
- (void)GetRestaurantsAreas:(NSString *)_accesstoken
                   restroId:(NSInteger)_restroId
                 locationId:(NSInteger)_locationId
                  serviceId:(NSInteger)_serviceId
                  successed:(void (^)( id _responseObject))_success
                    failure:(void (^)( NSError* _error))_failure{
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@/%ld/areas?access_token=%@&location_id=%ld&service_id=%ld",WEBAPI_GETRESTAURATNSFILTER, (long)_restroId, _accesstoken, (long)_locationId, (long)_serviceId] success:_success failure:_failure];
}


//order apis
- (void)SetOrdersCart:(NSString *)_accesstoken
          serviceType:(NSInteger)_serviceType
            productId:(NSInteger)_productId
             quantity:(NSInteger)_quantity
         variationIds:(NSString *)_variationIds
       spacialRequest:(NSString *)_spacialRequest
            successed:(void (^)( id _responseObject))_success
              failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_productId)         forKey : @"product_id"] ;
    [params setObject : @(_quantity)         forKey : @"quantity"] ;
    [params setObject : _variationIds         forKey : @"variation_ids"] ;
    [params setObject : _spacialRequest         forKey : @"spacial_request"] ;
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@&service_type=%ld",WEBAPI_RESTAURANTSORDERSCART,_accesstoken,(long)_serviceType] success:_success failure:_failure];
}
- (void)GetFetchAllOrdersCart:(NSString *)_accesstoken
                  serviceType:(NSInteger)_serviceType
                     restroId:(NSInteger)_restroId
                   locationId:(NSInteger)_locationId
                    successed:(void (^)( id _responseObject))_success
                      failure:(void (^)( NSError* _error))_failure{
    
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_serviceType)         forKey : @"service_type"] ;
    [params setObject : @(_restroId)         forKey : @"restro_id"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&service_type=%ld&restro_id=%ld&location_id=%ld",WEBAPI_RESTAURANTSORDERSCART,_accesstoken,(long)_serviceType, (long)_restroId, (long)_locationId] success:_success failure:_failure];
}
- (void)PutCurrentItemToEdit:(NSString *)_accesstoken
                      cartId:(NSInteger)_cartId
                 serviceType:(NSInteger)_serviceType
                   productId:(NSInteger)_productId
                    quantity:(NSInteger)_quantity
                variationIds:(NSString *)_variationIds
              spacialRequest:(NSString *)_spacialRequest
                   successed:(void (^)( id _responseObject))_success
                     failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_productId)      forKey : @"product_id"];
    [params setObject : @(_quantity)         forKey : @"quantity"];
    [params setObject : _variationIds         forKey : @"variation_ids"];
    [params setObject : _spacialRequest        forKey : @"spacial_request"];
     [self sendToServicePut:params action:[NSString stringWithFormat:@"%@/%ld?access_token=%@&service_type=%ld",WEBAPI_RESTAURANTSORDERSCART,(long)_cartId,_accesstoken,(long)_serviceType] success:_success failure:_failure];
}
- (void)DeleteCurrentItem:(NSString *)_accesstoken
                   cartId:(NSInteger)_cartId
              serviceType:(NSInteger)_serviceType
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure{
    [self sendToServiceDelete:nil action:[NSString stringWithFormat:@"%@/%ld?access_token=%@&service_type=%ld",WEBAPI_RESTAURANTSORDERSCART,(long)_cartId, _accesstoken,(long)_serviceType] success:_success failure:_failure];
}
- (void)GetOrdersSum:(NSString *)_accesstoken
            restroId:(NSInteger)_restroId
          locationId:(NSInteger)_locationId
              areaId:(NSInteger)_areaId
         serviceType:(NSInteger)_serviceType
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_serviceType)         forKey : @"service_type"] ;
    [params setObject : @(_restroId)         forKey : @"restro_id"] ;
    [params setObject : @(_areaId)         forKey : @"area_id"] ;
    [params setObject : @(_locationId)         forKey : @"location_id"] ;
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@&service_type=%ld&restro_id=%ld&location_id=%ld&area_id=%ld",WEBAPI_GETORDERSSUM,_accesstoken,(long)_serviceType, (long)_restroId, (long)_locationId ,(long)_areaId] success:_success failure:_failure];
}
- (void)GetOrdersPoint:(NSString *)_accesstoken
              restroId:(NSInteger)_restroId
            locationId:(NSInteger)_locationId
           serviceType:(NSInteger)_serviceType
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_serviceType)         forKey : @"service_type"] ;
    [params setObject : @(_restroId)         forKey : @"restro_id"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&service_type=%ld&restro_id=%ld&location_id=%ld",WEBAPI_GETORDERSPOINT,_accesstoken,(long)_serviceType, (long)_restroId, (long)_locationId] success:_success failure:_failure];
}
- (void)GetOrdersDiscount:(NSString *)_accesstoken
                 restroId:(NSInteger)_restroId
               locationId:(NSInteger)_locationId
              serviceType:(NSInteger)_serviceType
               redeemType:(NSInteger)_redeemType
               couponCode:(NSString *)_couponCode
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_serviceType)         forKey : @"service_type"] ;
    [params setObject : @(_restroId)         forKey : @"restro_id"] ;
    [params setObject : @(_locationId)         forKey : @"location_id"] ;
    [params setObject : @(_redeemType)         forKey : @"redeem_type"] ;
    [params setObject : _couponCode         forKey : @"coupon_code"] ;
    [self sendToServiceGet:params action:[NSString stringWithFormat:@"%@?access_token=%@&redeem_type=%ld&service_type=%ld&restro_id=%ld&location_id=%ld&coupon_code=%@",WEBAPI_GETORDERSDISCOUNT,_accesstoken,(long)_redeemType,(long)_serviceType, (long)_restroId,(long)_locationId,_couponCode] success:_success failure:_failure];
}
- (void)SetOrders:(NSString *)_accesstoken
      serviceType:(NSInteger)_serviceType
           areaId:(NSInteger)_areaId
         restroId:(NSInteger)_restroId
       locationId:(NSInteger)_locationId
       redeemType:(NSInteger)_redeemType
       couponCode:(NSString*)_couponCode
     scheduleDate:(NSString*)_scheduleDate
     scheduleTime:(NSString*)_scheduleTime
    paymentMethod:(NSInteger)_paymentMethod
        addressId:(NSInteger)_addressId
   extraDirection:(NSString*)_extraDirection
        successed:(void (^)( id _responseObject))_success
          failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_redeemType)          forKey : @"redeem_type"] ;
    [params setObject : _couponCode             forKey : @"coupon_code"] ;
    [params setObject : _scheduleDate           forKey : @"schedule_date"] ;
    [params setObject : _scheduleTime           forKey : @"schedule_time"] ;
    [params setObject : @(_paymentMethod)       forKey : @"payment_method"] ;
    [params setObject : @(_addressId)           forKey : @"address_id"] ;
    [params setObject : _extraDirection         forKey : @"extra_direction"] ;
    if (_areaId == 0) {
        [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@&service_type=%ld&restro_id=%ld&location_id=%ld",WEBAPI_ORDERS, _accesstoken, (long)_serviceType, (long)_restroId, (long)_locationId] success:_success failure:_failure];
    }else{
        [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@&service_type=%ld&area_id=%ld&restro_id=%ld&location_id=%ld",WEBAPI_ORDERS, _accesstoken, (long)_serviceType, (long)_areaId, (long)_restroId, (long)_locationId] success:_success failure:_failure];
    }
}
- (void)SetOrdersReserve:(NSString *)_accesstoken
             serviceType:(NSInteger)_serviceType
                restroId:(NSInteger)_restroId
              locationId:(NSInteger)_locationId
             reserveDate:(NSString *)_reserveDate
             reserveTime:(NSString*)_reserveTime
            peopleNumber:(NSInteger)_peopleNumber
               successed:(void (^)( id _responseObject))_success
                 failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : @(_restroId)          forKey : @"restro_id"] ;
    [params setObject : @(_locationId )            forKey : @"location_id"] ;
    [params setObject : _reserveDate           forKey : @"reserve_date"] ;
    [params setObject : _reserveTime           forKey : @"reserve_time"] ;
    [params setObject : @(_peopleNumber)       forKey : @"people_number"] ;
    [self sendToService:params action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_ORDERSRESERVE, _accesstoken] success:_success failure:_failure];

}
- (void)GetOrdersTimes:(NSString *)_accesstoken
           serviceType:(NSInteger)_serviceType
              restroId:(NSInteger)_restroId
            locationId:(NSInteger)_locationId
           reserveTime:(NSString *)_reserveTime
          peopleNumber:(NSInteger)_peopleNumber
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure{
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@&restro_id=%ld&location_id=%ld&reserve_time=%@&people_number=%ld",WEBAPI_ORDERSTIMES, _accesstoken, (long)_restroId, (long)_locationId, _reserveTime, (long)_peopleNumber] success:_success failure:_failure];
}
- (void)GetMyOrders:(NSString *)_accesstoken
           serviceType:(NSInteger)_serviceType
              restroId:(NSInteger)_restroId
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure{
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_ORDERS, _accesstoken] success:_success failure:_failure];
}
- (void)GetMyReservations:(NSString *)_accesstoken
                 restroId:(NSInteger)_restroId
               locationId:(NSInteger)_locationId
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure{
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_ORDERSRESERVE, _accesstoken] success:_success failure:_failure];
}
- (void)GetOrdersMyPoints:(NSString *)_accesstoken
              serviceType:(NSInteger)_serviceType
                pointType:(NSInteger)_pointType
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure{
    if (_serviceType == 0) {
        [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@",WEBAPI_ORDERSMYPOINTS, _accesstoken] success:_success failure:_failure];
    }else{
        [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@?access_token=%@&service_type=%ld",WEBAPI_ORDERSMYPOINTS, _accesstoken, (long)_serviceType] success:_success failure:_failure];
    }
}
- (void)CancelCurrentOrder:(NSString *)_accesstoken
        serviceType:(NSInteger)_serviceType
           orderId:(NSInteger)_orderId
          successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _accesstoken          forKey : @"access_token"] ;
    [params setObject : @(_orderId )          forKey : @"id"] ;
    [params setObject : @(_serviceType )      forKey : @"service_type"] ;
    [self sendToService:params action:[NSString stringWithFormat:@"%@/%ld/cancel?access_token=%@&service_type=%ld",WEBAPI_ORDERS,(long)_orderId, _accesstoken, (long)_serviceType] success:_success failure:_failure];
}
- (void)AcceptCurrentOrder:(NSString *)_accesstoken
               serviceType:(NSInteger)_serviceType
                   orderId:(NSInteger)_orderId
                 successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _accesstoken          forKey : @"access_token"] ;
    [params setObject : @(_orderId )          forKey : @"id"] ;
    [params setObject : @(_serviceType )      forKey : @"service_type"] ;
    [self sendToService:params action:[NSString stringWithFormat:@"%@/%ld/accept?access_token=%@&service_type=%ld",WEBAPI_ORDERS,(long)_orderId, _accesstoken, (long)_serviceType] success:_success failure:_failure];
}
- (void)GetCurrentOrderDetails:(NSString *)_accesstoken
               serviceType:(NSInteger)_serviceType
                   orderId:(NSInteger)_orderId
                 successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _accesstoken          forKey : @"access_token"] ;
    [params setObject : @(_orderId )          forKey : @"id"] ;
    [params setObject : @(_serviceType )      forKey : @"service_type"] ;
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@/%ld/details?access_token=%@&service_type=%ld",WEBAPI_ORDERS,(long)_orderId, _accesstoken, (long)_serviceType] success:_success failure:_failure];
}
- (void)GetCurrentReservationDetails:(NSString *)_accesstoken
                       reservationId:(NSInteger)_reservationId
                     successed:(void (^)( id _responseObject))_success
                       failure:(void (^)( NSError* _error))_failure
{
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@/%ld?access_token=%@",WEBAPI_ORDERSRESERVE,(long)_reservationId, _accesstoken] success:_success failure:_failure];
}



- (void) AddCustomer:(NSString*)_sessionID
          customerID:(NSString*)_customerID
        businessName:(NSString*)_businessName
         tradingName:(NSString*)_tradingName
     deliveryAddress:(NSString*)_deliveryAddress
    customerPhoneNum:(NSString*)_customerPhoneNum
         customerFax:(NSString*)_customerFax
       postalAddress:(NSString*)_postalAddress
contactPersonForSales:(NSString*)_contactPersonForSales
contactPersonForAccounts:(NSString*)_contactPersonForAccounts
       customerEmail:(NSString*)_customerEmail
      typeOfBusiness:(NSString*)_typeOfBusiness
    dateIncorporated:(NSString*)_dateIncorporated
    registeredOffice:(NSString*)_registeredOffice
   namesAndAddresses:(NSString*)_namesAndAddresses
            isCredit:(NSString*)_isCredit
    creditReferences:(NSString*)_creditReferences
      signatureImage:(NSString*)_signatureImage
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    
    
    [params setObject:_sessionID                    forKey:@"sessionID" ];
    [params setObject:_customerID                   forKey:@"customerID"];
    [params setObject:_businessName                 forKey:@"businessName"];
    [params setObject:_tradingName                  forKey:@"tradingName"];
    [params setObject:_deliveryAddress              forKey:@"deliveryAddress"];
    [params setObject:_customerPhoneNum             forKey:@"customerPhoneNum"];
    [params setObject:_customerFax                  forKey:@"customerFax"];
    [params setObject:_postalAddress                forKey:@"postalAddress"];
    [params setObject:_contactPersonForSales        forKey:@"contactPersonForSales"];
    [params setObject:_contactPersonForAccounts     forKey:@"contactPersonForAccounts"];
    [params setObject:_customerEmail                forKey:@"customerEmail"];
    [params setObject:_typeOfBusiness               forKey:@"typeOfBusiness"];
    [params setObject:_dateIncorporated             forKey:@"dateIncorporated"];
    [params setObject:_registeredOffice             forKey:@"registeredOffice"];
    [params setObject:_namesAndAddresses            forKey:@"namesAndAddresses"];
    [params setObject:_isCredit                     forKey:@"isCredit"];
    [params setObject:_creditReferences             forKey:@"creditReferences"];
    [params setObject:_signatureImage               forKey:@"signatureImage"];
    
    
    NSString *actionsStr = [NSString stringWithFormat:@"%@?sessionID=%@&customerID=%@&businessName=%@&tradingName=%@&deliveryAddress=%@&customerPhoneNum=%@&customerFax=%@&postalAddress=%@&contactPersonForSales=%@&contactPersonForAccounts=%@&customerEmail=%@&typeOfBusiness=%@&dateIncorporated=%@&registeredOffice=%@&namesAndAddresses=%@&isCredit=%@&creditReferences=%@&signatureImage=%@", @"API_URL", _sessionID, _customerID, _businessName, _tradingName , _deliveryAddress, _customerPhoneNum, _customerFax, _postalAddress, _contactPersonForSales, _contactPersonForAccounts, _customerEmail, _typeOfBusiness, _dateIncorporated, _registeredOffice, _namesAndAddresses, _isCredit, _creditReferences, _signatureImage];
    
    [self sendToService:params action:actionsStr success:_success failure:_failure ];
}
- (void)AddOrder:(NSString*)_sessionID
      customerName:(NSString *)_customerName
      invoiceNum:(NSString*)_invoiceNum
       dateOrder:(NSString*)_dateOrder
           items:(NSString*)_items
      totalPrice:(NSString*)_totalPrice
        GSTPrice:(NSString*)_GSTPrice
       successed:(void (^)( id _responseObject))_success
         failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    
    [params setObject:_sessionID		forKey:@"sessionID"];
    [params setObject:_customerName       forKey:@"customerName"];
    [params setObject:_invoiceNum		forKey:@"invoiceNum"];
    [params setObject:_dateOrder             forKey:@"dateOrder"];
    [params setObject:_items			forKey:@"items"];
    [params setObject:_totalPrice       forKey:@"totalPrice"];
    [params setObject:_GSTPrice         forKey:@"GSTPrice"];
    NSString *actionsStr = [NSString stringWithFormat:@"%@?sessionID=%@&customerName=%@&invoiceNum=%@&dateOrder=%@&items=%@&totalPrice=%@&GSTPrice=%@", @"API_URL", _sessionID, _customerName, _invoiceNum,_dateOrder,_items, _totalPrice, _GSTPrice];
    
    [self sendToService:params action:actionsStr success:_success failure:_failure ];
}
- (void) SetUpdateLocation:(NSString *)_sessionid
                 longitude:(NSString *)_longitude
                  latitude:(NSString *)_latitude
                 successed:(void (^)(id _responseObject))_success
                   failure:(void (^)(NSError *))_failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _sessionid         forKey : @"sessionId"] ;
    [params setObject : _latitude          forKey : @"latitude"] ;
    [params setObject : _longitude			forKey : @"longitude"] ;
    
    [ self sendToService : params action : [NSString stringWithFormat:@"%@?sessionId=%@&latitude=%@&longitude=%@", @"API_URL", _sessionid, _latitude, _longitude] success : _success failure : _failure ];
}


- (void)GetContacts:(NSString *)_sessionid
          successed:(void (^)(id _responseObject))_success
            failure:(void (^)(NSError *))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _sessionid         forKey : @"sessionId"] ;
    
    [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];
}
- (void) GetLocationUser:(NSString *)_sessionid
               successed:(void (^)(id))_success
                 failure:(void (^)(NSError *))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _sessionid         forKey : @"sessionId"] ;
    
    [ self sendToService : params action : [NSString stringWithFormat:@"%@?sessionId=%@", @"API_URL", _sessionid ] success : _success failure : _failure ];
}
- (void) GetCustomers:(NSString *)_sessionid
               successed:(void (^)(id))_success
                 failure:(void (^)(NSError *))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _sessionid         forKey : @"sessionID"] ;
    
    [ self sendToService : params action : [NSString stringWithFormat:@"%@?sessionID=%@", @"API_URL", _sessionid ] success : _success failure : _failure ];
}
- (void) GetOrders:(NSString *)_sessionid
         successed:(void (^)(id))_success
           failure:(void (^)(NSError *))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _sessionid         forKey : @"sessionID"] ;
    
    [ self sendToService : params action : [NSString stringWithFormat:@"%@?sessionID=%@", @"API_URL", _sessionid ] success : _success failure : _failure ];
}
- (void) GetOneOrder:(NSString *)_sessionid
          invoiceNum:(NSString *)_invoiceNum
           successed:(void (^)(id))_success
             failure:(void (^)(NSError *))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _sessionid         forKey : @"sessionID"] ;
    [params setObject : _invoiceNum         forKey : @"invoiceNum"] ;
    
    [ self sendToService : params action : [NSString stringWithFormat:@"%@?sessionID=%@&invoiceNum=%@", @"API_URL", _sessionid , _invoiceNum] success : _success failure : _failure ];
}

- (void)uploadWallPaperPhoto:(NSString *)sessionID
                   imgData:(NSData *)imgData
                 successed:(void (^)(id responseObject)) success
                   failure:(void (^)(NSError* error)) failure
{
    NSString *action = [NSString stringWithFormat:@"%@%@?sessionId=%@", SERVER_URL, @"API_URL", sessionID];
    
    //set Parameters
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:sessionID     forKey:@"sessionId"];
    
    [self sendToServiceByPOST:action params:params media:imgData mediaType:0 name:@"file" success:success failure:failure];
}
- (void)updateUserProfile:(NSString *)_sessionID
                firstName:(NSString *)_firstName
                 lastName:(NSString *)_lastName
                 latitude:(NSString *)_latitude
                longitude:(NSString *)_longitude
                      sex:(NSString *)_sex
                interests:(NSString *)_interests
                      age:(NSString *)_age
                successed:(void (^)(id responseObject)) _success
                  failure:(void (^)(NSError* error)) _failure{
    NSMutableDictionary*    params  = [NSMutableDictionary dictionary];
    
    [params setObject:_sessionID	forKey:@"sessionId"];
    [params setObject:_firstName    forKey:@"firstName"];
    [params setObject:_lastName		forKey:@"LastName"];
    [params setObject:_latitude		forKey:@"latitude"];
    [params setObject:_longitude    forKey:@"longitude"];
    [params setObject:_sex          forKey:@"sex"];
    [params setObject:_interests    forKey:@"interests"];
    [params setObject:_age          forKey:@"age"];
    NSString *actionsStr = [NSString stringWithFormat:@"%@?sessionId=%@&firstName=%@&LastName=%@&latitude=%@&longitude=%@&sex=%@&interests=%@&age=%@", @"API_URL", _sessionID, _firstName, _lastName,_latitude,_longitude,_sex,_interests,_age];
    
    [self sendToService:params action:actionsStr success:_success failure:_failure ];
}

//some of initial data retrival url
- (void)GetCustomerList:(NSString *)_keyWord
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;

    [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];
   
}
- (void)GetCarreersList:(NSString *)_keyWord
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
    [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];
}



- (void)GetSeocategory:(NSString *)_keyWord
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
     [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];
}

- (void)GetRestaurantList:(NSString *)_keyWord
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _keyWord         forKey : @"keyword"] ;
    [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];

}

- (void)GetRestroRating:(NSString *)_restro_id
             star_value:(NSString *)_starValue
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _restro_id         forKey : @"restro_id"] ;
    [params setObject : _starValue         forKey : @"star_value"] ;
    [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];

}
- (void)GetFoodTypes:(NSString *)_foodTitle
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _foodTitle         forKey : @"food_title"] ;
    [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];

}
- (void)Logout:(NSString *)_sessionID
     successed:(void (^)( id _responseObject))_success
       failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _sessionID         forKey : @"session_id"] ;
    [self sendToServiceGet:params action:@"API_URL" success:_success failure:_failure];
}





- (void)GetUserInfos:(NSString *)_userId
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [params setObject : _userId         forKey : @"id"] ;
    [self sendToServiceGet:nil action:[NSString stringWithFormat:@"%@/%@?access_token=%@", WEBAPI_USERS, _userId,APPDELEGATE.access_token] success:_success failure:_failure];
}
@end
