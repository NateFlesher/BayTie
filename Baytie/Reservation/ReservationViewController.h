//
//  ReservationViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface ReservationViewController : UIViewController<SKSTableViewDelegate>{

    IBOutlet UIView *navView;
    __weak IBOutlet UIView *reservationCitySelectedView;
    __weak IBOutlet UIView *reservationFoodSelectedView;
    __weak IBOutlet UIView *reservationDateTimeView;
    __weak IBOutlet UIButton *btnReservationFoodSelectedView;
    __weak IBOutlet UIButton *btnReservationCitySelectedView;
    
    
    __weak IBOutlet UILabel *lblCountReservation;
    
    __weak IBOutlet UIButton *btnReservationDateTime;
    __weak IBOutlet UIDatePicker *dateTimePick;
    
    __weak IBOutlet UILabel *lblDayOfWeekReservation;
    __weak IBOutlet UILabel *lblTimeForReservation;
    __weak IBOutlet UILabel *lblDateForReservation;
    
    __weak IBOutlet UISearchBar *citySearchBar;
    __weak IBOutlet UISearchBar *foodSearchBar;
    
}
- (IBAction)onMinusReservation:(id)sender;
- (IBAction)onPlusReservation:(id)sender;
- (IBAction)onReservationFoodSelectedView:(id)sender;
- (IBAction)onReservationCitySelectedView:(id)sender;

- (IBAction)onback:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onFindRestaurants:(id)sender;
- (IBAction)onReservationFoodSelectedViewClose:(id)sender;
- (IBAction)onReservationCitySelectedViewClose:(id)sender;

- (IBAction)onReservationDateTimeView:(id)sender;
- (IBAction)onReservationDateTimeClose:(id)sender;
- (IBAction)onReservationDateTimeDone:(id)sender;

- (IBAction)onDoneFoodCategory:(id)sender;
@end
