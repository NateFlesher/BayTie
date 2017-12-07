//
//  HomeViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "HomeViewController.h"
#import "MainMenuViewController.h"
#import "DeliveryViewController.h"
#import "PickupViewController.h"
#import "ReservationViewController.h"
#import "CateringViewController.h"

#import "Communication.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface HomeViewController (){
    
    NSMutableArray *arrayCityAndArea;
    NSMutableArray *arryFoodCuisineRes;
    
    NSMutableArray *arrayCityAndAreaIds;
    NSMutableArray *arryFoodCuisineResIds;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self getCityAreaDict];
    [self getCuisineFoodRestaurantCategory];
}
- (void)getCityAreaDict{
    [[Communication sharedManager] GetCityList:APPDELEGATE.access_token keyWord:@"" successed:^(id _responseObject) {
        if ([_responseObject[@"code"] integerValue] == 0) {
            arrayCityAndArea = [[NSMutableArray alloc] init];
            arrayCityAndAreaIds = [[NSMutableArray alloc] init];
            for (NSDictionary *dictCity in [_responseObject objectForKey:@"resource"]) {
                NSMutableArray *oneCity = [[NSMutableArray alloc] init];
                NSMutableArray *oneCityId = [[NSMutableArray alloc] init];
                [oneCity addObject:[dictCity objectForKey:@"city_name"]];
                [oneCityId addObject:[dictCity objectForKey:@"id"]];
                [arrayCityAndArea addObject:oneCity];
                [arrayCityAndAreaIds addObject:oneCityId];
            }
            [[Communication sharedManager] GetAreaList:APPDELEGATE.access_token keyWord:@"" successed:^(id _responseObject) {
                if ([_responseObject[@"code"] integerValue] == 0) {
                    
                    for (int i = 0 ; i < [arrayCityAndAreaIds count] ; i ++) {
                        NSMutableArray *initCityArea = [arrayCityAndArea objectAtIndex:i];
                        NSMutableArray *initCityAreaIds = [arrayCityAndAreaIds objectAtIndex:i];
                        for (NSDictionary *dictArea in  [_responseObject objectForKey:@"resource"]) {
                            
                            if ([[dictArea objectForKey:@"city_id"] isEqualToString:[initCityAreaIds objectAtIndex:0]]) {
                                [initCityArea addObject:[dictArea objectForKey:@"name"]];
                                [initCityAreaIds addObject:[dictArea objectForKey:@"id"]];
                            }
                        }
                        
                        //[initCityArea setObject:oneArea forKey:@"area"];
                        NSArray *arr = [initCityArea copy];
                        NSArray *arrIds = [initCityAreaIds copy];
                        [arrayCityAndArea replaceObjectAtIndex:i withObject:arr];
                        [arrayCityAndAreaIds replaceObjectAtIndex:i withObject:arrIds];
                    }
                    
                    [AppDelegate sharedDelegate].lstCity =[arrayCityAndArea copy];
                    [AppDelegate sharedDelegate].lstCityIds =[arrayCityAndAreaIds copy];
                }
            } failure:^(NSError *_error) {
                
                
            }];
        }
    } failure:^(NSError *_error) {
        
        
    }];
}

-(void)getCuisineFoodRestaurantCategory{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[Communication sharedManager] GetCuisineList:APPDELEGATE.access_token keyWord:@"" successed:^(id _responseObject) {
        if ([_responseObject[@"code"] integerValue] == 0) {
            arryFoodCuisineRes = [[NSMutableArray alloc] init];
            arryFoodCuisineResIds = [[NSMutableArray alloc] init];
            
            NSMutableArray *initCuisine = [[NSMutableArray alloc] init];
            NSMutableArray *initCuisineIds = [[NSMutableArray alloc] init];
            [initCuisine addObject:@"CUISINE"];
            [initCuisineIds addObject:@"CUISINE"];
            [arryFoodCuisineRes addObject:initCuisine];
            [arryFoodCuisineResIds addObject:initCuisineIds];
            
            for (NSDictionary *oneCuisine in  [_responseObject objectForKey:@"resource"]) {
                [initCuisine addObject:[oneCuisine objectForKey:@"name"]];
                [initCuisineIds addObject:[oneCuisine objectForKey:@"id"]];
            }
            NSArray *arr = [initCuisine copy];
            NSArray *arrIds = [initCuisineIds copy];
            [arryFoodCuisineRes replaceObjectAtIndex:0 withObject:arr];
            [arryFoodCuisineResIds replaceObjectAtIndex:0 withObject:arrIds];
            
            
            [[Communication sharedManager] GetFoodType:APPDELEGATE.access_token keyWord:@"" successed:^(id _responseObject) {
                if ([_responseObject[@"code"] integerValue] == 0) {
                    
                    NSMutableArray *initFoodType = [[NSMutableArray alloc] init];
                    [initFoodType addObject:@"FOOD TYPE"];
                    NSMutableArray *initFoodTypeIds = [[NSMutableArray alloc] init];
                    [initFoodTypeIds addObject:@"FOOD TYPE"];
                    [arryFoodCuisineRes addObject:initFoodType];
                    [arryFoodCuisineResIds addObject:initFoodTypeIds];
                    
                    for (NSDictionary *oneFoodType in  [_responseObject objectForKey:@"resource"]) {
                        [initFoodType addObject:[oneFoodType objectForKey:@"food_title"]];
                        [initFoodTypeIds addObject:[oneFoodType objectForKey:@"id"]];
                    }
                    NSArray *arr = [initFoodType copy];
                    [arryFoodCuisineRes replaceObjectAtIndex:1 withObject:arr];
                    NSArray *arrIds = [initFoodTypeIds copy];
                    [arryFoodCuisineResIds replaceObjectAtIndex:1 withObject:arrIds];
                    
                    [[Communication sharedManager] GetRestroCategory:APPDELEGATE.access_token keyWord:@"" successed:^(id _responseObject) {
                        if ([_responseObject[@"code"] integerValue] == 0) {
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            NSMutableArray *initRestroCategory = [[NSMutableArray alloc] init];
                            [initRestroCategory addObject:@"RESTAURANT CATEGORY"];
                            NSMutableArray *initRestroCategoryIds = [[NSMutableArray alloc] init];
                            [initRestroCategoryIds addObject:@"RESTAURANT CATEGORY"];
                            [arryFoodCuisineRes addObject:initRestroCategory];
                            [arryFoodCuisineResIds addObject:initRestroCategoryIds];
                            
                            for (NSDictionary *oneRestroCategory in  [_responseObject objectForKey:@"resource"]) {
                                [initRestroCategory addObject:[oneRestroCategory objectForKey:@"name"]];
                                [initRestroCategoryIds addObject:[oneRestroCategory objectForKey:@"id"]];
                            }
                            NSArray *arr = [initRestroCategory copy];
                            [arryFoodCuisineRes replaceObjectAtIndex:2 withObject:arr];
                            NSArray *arrIds = [initRestroCategoryIds copy];
                            [arryFoodCuisineResIds replaceObjectAtIndex:2 withObject:arrIds];
                            
                            
                            [AppDelegate sharedDelegate].lstFood =[arryFoodCuisineRes copy];
                            [AppDelegate sharedDelegate].lstFoodIds =[arryFoodCuisineResIds copy];
                        }else{
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
                    } failure:^(NSError *_error) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                    }];
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            } failure:^(NSError *_error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *_error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}
- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onDeliveryView:(id)sender {
    APPDELEGATE.serviceType = 1;
    DeliveryViewController *viewcontroller = [[DeliveryViewController alloc] initWithNibName:@"DeliveryViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onPickupView:(id)sender {
    APPDELEGATE.serviceType = 4;
    //APPDELEGATE.serviceType = 1;//for testing
    PickupViewController *viewcontroller = [[PickupViewController alloc] initWithNibName:@"PickupViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onReservationView:(id)sender {
    APPDELEGATE.serviceType = 3;
    //APPDELEGATE.serviceType = 1;//for testing
    ReservationViewController *viewcontroller = [[ReservationViewController alloc] initWithNibName:@"ReservationViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onCateringView:(id)sender {
    APPDELEGATE.serviceType = 2;
    //APPDELEGATE.serviceType = 1;//for testing
    CateringViewController *viewcontroller = [[CateringViewController alloc] initWithNibName:@"CateringViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

@end
