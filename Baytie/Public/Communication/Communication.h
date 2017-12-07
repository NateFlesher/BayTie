//
//  Communication.h
//  ChatAndMapSample
//
//  Created by stepanekdavid on 2/12/16.
//  Copyright © 2016 stepanekdavid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface Communication : AFHTTPSessionManager<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}
+ (Communication*)sharedManager ;
- (void)sendToService:(NSDictionary*)_params
               action:(NSString*)_action
              success:(void (^)(id _responseObject))_success
              failure:(void (^)(NSError* _error))_failure ;
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
                  mediaType:(NSInteger)_mediaType // 0: photo, 1: video
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure;

//user apis
- (void)UserLogin:(NSString*)_driverPhoneNum
        driverPwd:(NSString*)_driverPwd
         deviceID:(NSString*)_deviceID
       deviceType:(NSString*)_deviceType
        successed:(void (^)( id _responseObject))_success
          failure:(void (^)( NSError* _error))_failure;
- (void)SignUP:(NSString*)_mobileNumber
     firstName:(NSString *)_firstName
     lastName:(NSString *)_lastName
  userPassword:(NSString*)_userPassword
     userEmail:(NSString*)_userEmail
      deviceID:(NSString*)_deviceID
    deviceType:(NSString*)_deviceType
     successed:(void (^)( id _responseObject))_success
       failure:(void (^)( NSError* _error))_failure;
- (void)SendSMScode:(NSString*)_userId
     mobileNum:(NSString *)_mobileNum
     successed:(void (^)( id _responseObject))_success
       failure:(void (^)( NSError* _error))_failure;
- (void)VerifySMScode:(NSString*)_userId
            mobileNum:(NSString *)_mobileNum
                 code:(NSString *)_code
          successed:(void (^)( id _responseObject))_success
              failure:(void (^)( NSError* _error))_failure;
- (void)CheckSession:(NSString *)_accesstoken
           successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure;
- (void)registerDevice:(NSString *)_accesstoken
              deviceid:(NSString*)_deviceId
            devicetype:(NSString*)_deviceType
           devicetoken:(NSString*)_deviceToken
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure;
- (void)GetUsersMe:(NSString *)_accesstoken
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure;
- (void)UploadProfieImage:(NSString*)_accesstoken
                    image:(NSData*)_image
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure;
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
                failure:(void (^)( NSError* _error))_failure;
- (void)GetUserAddress:(NSString *)_accesstoken
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure;
- (void)SetLanguage:(NSString *)_accesstoken
           language:(NSString *)_language
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure;
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
       failure:(void (^)( NSError* _error))_failure;

- (void)ChangeMobileNo:(NSString*)_accessToken
           oldMobileNo:(NSString *)_oldMobileNo
           newMobileNo:(NSString *)_newMobileNo
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure;
- (void)ChangePassword:(NSString*)_accessToken
           oldPassword:(NSString *)_oldPassword
           newPassword:(NSString *)_newPassword
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure;
- (void)UpdateSubscription:(NSString*)_accessToken
              notification:(BOOL)_notification
                    smsSub:(BOOL)_smsSub
                  emailSub:(BOOL)_emailSub
                 successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure;



//city, area, foodtype, cusines, category apis
- (void)GetAreaList:(NSString *)_accessToken
            keyWord:(NSString *)_keyWord
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure;
- (void)GetCityList:(NSString *)_accessToken
            keyWord:(NSString *)_keyWord
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure;
- (void)GetCuisineList:(NSString *)_accessToken
               keyWord:(NSString *)_keyWord
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure;
- (void)GetFoodType:(NSString *)_accessToken
            keyWord:(NSString *)_keyWord
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure;
- (void)GetRestroCategory:(NSString *)_accessToken
                  keyWord:(NSString *)_keyWord
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure;
- (void)GetAdvertisements:(NSString *)_accessToken
                     kind:(NSInteger)_kind
                     page:(NSInteger)_page
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure;
- (void)GetFAQS:(NSString *)_accessToken
           page:(NSInteger)_page
      successed:(void (^)( id _responseObject))_success
        failure:(void (^)( NSError* _error))_failure;
//restaurant apis
- (void)FindRestrestaurants:(NSString *)_accesstoken
                 restroArea:(NSInteger)_restroArea
                   cuisines:(NSString *)_cuisines
                  foodTypes:(NSString *)_foodTypes
           restroCategories:(NSString *)_restroCategories
                serviceType:(NSInteger)_serviceType
                  successed:(void (^)( id _responseObject))_success
                    failure:(void (^)( NSError* _error))_failure;
- (void)FindRestrestaurantsForReserve:(NSString *)_accesstoken
                           restroArea:(NSInteger)_restroArea
                             cuisines:(NSString *)_cuisines
                            foodTypes:(NSString *)_foodTypes
                     restroCategories:(NSString *)_restroCategories
                          serviceType:(NSInteger)_serviceType
                          reserveTime:(NSString *)_reserveTime
                         peopleNumber:(NSInteger)_peopleNumber
                            successed:(void (^)( id _responseObject))_success
                              failure:(void (^)( NSError* _error))_failure;
- (void)FindRestrestaurantsForCatering:(NSString *)_accesstoken
                            restroArea:(NSInteger)_restroArea
                              cuisines:(NSString *)_cuisines
                             foodTypes:(NSString *)_foodTypes
                      restroCategories:(NSString *)_restroCategories
                           serviceType:(NSInteger)_serviceType
                           reserveDate:(NSString *)_reserveDate
                             successed:(void (^)( id _responseObject))_success
                               failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantInfos:(NSString *)_accesstoken
                  restroId:(NSInteger)_restro_id
                locationId:(NSInteger)_locationId
               serviceType:(NSInteger)_serviceType
                 successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantsRating:(NSString *)_accesstoken
                  locationId:(NSInteger)_locationId
                    restroId:(NSInteger)_restroId
                   successed:(void (^)( id _responseObject))_success
                     failure:(void (^)( NSError* _error))_failure;
- (void)SetRestaurantsRating:(NSString *)_accesstoken
                  locationId:(NSInteger)_locationId
                   starValue:(NSInteger)_starValue
                    restroId:(NSInteger)_restroId
                         msg:(NSString *)_msg
                   successed:(void (^)( id _responseObject))_success
                     failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantsItemCategories:(NSString *)_accesstoken
                          locationId:(NSInteger)_locationId
                           serviceId:(NSInteger)_serviceId
                           successed:(void (^)( id _responseObject))_success
                             failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantsAllFood:(NSString *)_accesstoken
                          categoryId:(NSInteger)_categoryId
                           successed:(void (^)( id _responseObject))_success
                             failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantsFoodItem:(NSString *)_accesstoken
                   foodItemId:(NSInteger)_foodItemId
                    successed:(void (^)( id _responseObject))_success
                      failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantsPromotions:(NSString *)_accesstoken
                        restroId:(NSInteger)_restroId
                      locationId:(NSInteger)_locationId
                       serviceId:(NSInteger)_serviceId
                       successed:(void (^)( id _responseObject))_success
                         failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantsAreas:(NSString *)_accesstoken
                        restroId:(NSInteger)_restroId
                      locationId:(NSInteger)_locationId
                       serviceId:(NSInteger)_serviceId
                       successed:(void (^)( id _responseObject))_success
                         failure:(void (^)( NSError* _error))_failure;


//order apis
- (void)SetOrdersCart:(NSString *)_accesstoken
          serviceType:(NSInteger)_serviceType
            productId:(NSInteger)_productId
             quantity:(NSInteger)_quantity
         variationIds:(NSString *)_variationIds
       spacialRequest:(NSString *)_spacialRequest
            successed:(void (^)( id _responseObject))_success
              failure:(void (^)( NSError* _error))_failure;
- (void)GetFetchAllOrdersCart:(NSString *)_accesstoken
                  serviceType:(NSInteger)_serviceType
                     restroId:(NSInteger)_restroId
                   locationId:(NSInteger)_locationId
                    successed:(void (^)( id _responseObject))_success
                      failure:(void (^)( NSError* _error))_failure;
- (void)PutCurrentItemToEdit:(NSString *)_accesstoken
                      cartId:(NSInteger)_cartId
                 serviceType:(NSInteger)_serviceType
                   productId:(NSInteger)_productId
                    quantity:(NSInteger)_quantity
                variationIds:(NSString *)_variationIds
              spacialRequest:(NSString *)_spacialRequest
                   successed:(void (^)( id _responseObject))_success
                     failure:(void (^)( NSError* _error))_failure;
- (void)DeleteCurrentItem:(NSString *)_accesstoken
                   cartId:(NSInteger)_cartId
              serviceType:(NSInteger)_serviceType
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure;
- (void)GetOrdersSum:(NSString *)_accesstoken
            restroId:(NSInteger)_restroId
          locationId:(NSInteger)_locationId
              areaId:(NSInteger)_areaId
         serviceType:(NSInteger)_serviceType
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure;
- (void)GetOrdersPoint:(NSString *)_accesstoken
              restroId:(NSInteger)_restroId
            locationId:(NSInteger)_locationId
           serviceType:(NSInteger)_serviceType
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure;
- (void)GetOrdersDiscount:(NSString *)_accesstoken
                 restroId:(NSInteger)_restroId
               locationId:(NSInteger)_locationId
              serviceType:(NSInteger)_serviceType
               redeemType:(NSInteger)_redeemType
               couponCode:(NSString *)_couponCode
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure;
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
          failure:(void (^)( NSError* _error))_failure;
- (void)SetOrdersReserve:(NSString *)_accesstoken
             serviceType:(NSInteger)_serviceType
                restroId:(NSInteger)_restroId
              locationId:(NSInteger)_locationId
             reserveDate:(NSString *)_reserveDate
             reserveTime:(NSString*)_reserveTime
            peopleNumber:(NSInteger)_peopleNumber
               successed:(void (^)( id _responseObject))_success
                 failure:(void (^)( NSError* _error))_failure;
- (void)GetOrdersTimes:(NSString *)_accesstoken
             serviceType:(NSInteger)_serviceType
                restroId:(NSInteger)_restroId
              locationId:(NSInteger)_locationId
             reserveTime:(NSString *)_reserveTime
            peopleNumber:(NSInteger)_peopleNumber
               successed:(void (^)( id _responseObject))_success
                 failure:(void (^)( NSError* _error))_failure;
- (void)GetMyOrders:(NSString *)_accesstoken
        serviceType:(NSInteger)_serviceType
           restroId:(NSInteger)_restroId
          successed:(void (^)( id _responseObject))_success
            failure:(void (^)( NSError* _error))_failure;
- (void)GetMyReservations:(NSString *)_accesstoken
                 restroId:(NSInteger)_restroId
               locationId:(NSInteger)_locationId
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure;
- (void)GetOrdersMyPoints:(NSString *)_accesstoken
              serviceType:(NSInteger)_serviceType
                pointType:(NSInteger)_pointType
                successed:(void (^)( id _responseObject))_success
                  failure:(void (^)( NSError* _error))_failure;
- (void)CancelCurrentOrder:(NSString *)_accesstoken
               serviceType:(NSInteger)_serviceType
                   orderId:(NSInteger)_orderId
                 successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure;
- (void)AcceptCurrentOrder:(NSString *)_accesstoken
               serviceType:(NSInteger)_serviceType
                   orderId:(NSInteger)_orderId
                 successed:(void (^)( id _responseObject))_success
                   failure:(void (^)( NSError* _error))_failure;
- (void)GetCurrentOrderDetails:(NSString *)_accesstoken
                   serviceType:(NSInteger)_serviceType
                       orderId:(NSInteger)_orderId
                     successed:(void (^)( id _responseObject))_success
                       failure:(void (^)( NSError* _error))_failure;
- (void)GetCurrentReservationDetails:(NSString *)_accesstoken
                       reservationId:(NSInteger)_reservationId
                           successed:(void (^)( id _responseObject))_success
                             failure:(void (^)( NSError* _error))_failure;








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
             failure:(void (^)( NSError* _error))_failure;
- (void)AddOrder:(NSString*)_sessionID
    customerName:(NSString *)_customerName
      invoiceNum:(NSString*)_invoiceNum
       dateOrder:(NSString*)_dateOrder
           items:(NSString*)_items
      totalPrice:(NSString*)_totalPrice
        GSTPrice:(NSString*)_GSTPrice
       successed:(void (^)( id _responseObject))_success
         failure:(void (^)( NSError* _error))_failure;
- (void) SetUpdateLocation:(NSString *)_sessionid
                 longitude:(NSString *)_longitude
                  latitude:(NSString *)_latitude
                 successed:(void (^)(id _responseObject))_success
                   failure:(void (^)(NSError *))_failure;

- (void)GetContacts:(NSString *)_sessionid
          successed:(void (^)(id _responseObject))_success
            failure:(void (^)(NSError *))_failure;
- (void)GetLocationUser:(NSString *)_sessionid
          successed:(void (^)(id _responseObject))_success
            failure:(void (^)(NSError *))_failure;
- (void) GetCustomers:(NSString *)_sessionid
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure;
- (void) GetOrders:(NSString *)_sessionid
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure;
- (void) GetOneOrder:(NSString *)_sessionid
          invoiceNum:(NSString *)_invoiceNum
            successed:(void (^)(id))_success
              failure:(void (^)(NSError *))_failure;
- (void)uploadProfilePhoto:(NSString *)sessionID
                   imgData:(NSData *)imgData
                 successed:(void (^)(id responseObject)) success
                   failure:(void (^)(NSError* error)) failure;
- (void)uploadWallPaperPhoto:(NSString *)sessionID
                     imgData:(NSData *)imgData
                   successed:(void (^)(id responseObject)) success
                     failure:(void (^)(NSError* error)) failure;
- (void)updateUserProfile:(NSString *)_sessionID
                firstName:(NSString *)_firstName
                 lastName:(NSString *)_lastName
                 latitude:(NSString *)_latitude
                longitude:(NSString *)_longitude
                      sex:(NSString *)_sex
                interests:(NSString *)_interests
                      age:(NSString *)_age
                successed:(void (^)(id responseObject)) success
                  failure:(void (^)(NSError* error)) failure;

//some of initial data retrival url
- (void)GetCustomerList:(NSString *)_keyWord
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure;
- (void)GetCarreersList:(NSString *)_keyWord
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure;
- (void)GetSeocategory:(NSString *)_keyWord
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure;
- (void)GetRestaurantList:(NSString *)_keyWord
             successed:(void (^)( id _responseObject))_success
               failure:(void (^)( NSError* _error))_failure;
- (void)GetRestroRating:(NSString *)_restro_id
             star_value:(NSString *)_starValue
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure;
- (void)GetFoodTypes:(NSString *)_foodTitle
              successed:(void (^)( id _responseObject))_success
                failure:(void (^)( NSError* _error))_failure;





- (void)Logout:(NSString *)_sessionID
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure;


- (void)GetUserInfos:(NSString *)_userId
           successed:(void (^)( id _responseObject))_success
             failure:(void (^)( NSError* _error))_failure;
@end

