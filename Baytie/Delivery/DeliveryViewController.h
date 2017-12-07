//
//  DeliveryViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView/RATreeView.h>
#import "SKSTableView.h"

@interface DeliveryViewController : UIViewController<SKSTableViewDelegate>{
    IBOutlet UIView *navView;
    __weak IBOutlet UIView *citySelectedView;
    
    __weak IBOutlet UIView *foodSelectedView;
    
    __weak IBOutlet UIButton *btnCityArea;
    __weak IBOutlet UIButton *btnCuisineFood;
    
    __weak IBOutlet UIButton *btnFindResGreenSub;
    __weak IBOutlet UISearchBar *CityAreaSearchBar;
    __weak IBOutlet UISearchBar *foodSearchBar;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onFindRestaurantsForDelivery:(id)sender;


- (IBAction)onCitySelected:(id)sender;
- (IBAction)onFoodCuisine:(id)sender;
- (IBAction)onCloseCityView:(id)sender;
- (IBAction)onCloseFoodView:(id)sender;

- (IBAction)onDoneFoodCaregory:(id)sender;
@end
