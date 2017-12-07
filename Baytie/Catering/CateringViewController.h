//
//  CateringViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface CateringViewController : UIViewController<SKSTableViewDelegate>
{
    IBOutlet UIView *navView;
    __weak IBOutlet UIView *cateringCitySelectedView;
    __weak IBOutlet UIView *cateringFoodSelectedView;
    __weak IBOutlet UIView *cateringDateTimeView;
    __weak IBOutlet UIButton *btnCateringCity;
    __weak IBOutlet UIButton *btnCateringFood;
    __weak IBOutlet UILabel *lblDayOfWeekToCatering;
    __weak IBOutlet UILabel *lblDateToCatering;
    __weak IBOutlet UIDatePicker *dateForCateringPick;
    __weak IBOutlet UIButton *btnFindRestroSub;
    
    __weak IBOutlet UISearchBar *citySearchBar;
    __weak IBOutlet UISearchBar *foodSearchBar;
    
    
}


- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onFindRestaurantsForDelivery:(id)sender;

- (IBAction)onCitySelectedView:(id)sender;
- (IBAction)onFoodSelectedView:(id)sender;

- (IBAction)onCityViewClose:(id)sender;
- (IBAction)onFoodViewClose:(id)sender;
- (IBAction)onDateTimeViewClose:(id)sender;
- (IBAction)onDateTimeDone:(id)sender;

- (IBAction)onSetDateTime:(id)sender;

- (IBAction)onDoneFoodCategory:(id)sender;
@end
