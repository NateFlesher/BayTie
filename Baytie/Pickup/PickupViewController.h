//
//  PickupViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface PickupViewController : UIViewController<SKSTableViewDelegate>
{

    IBOutlet UIView *navView;
    __weak IBOutlet UIButton *btnPickupFoodSelected;
    __weak IBOutlet UIView *pickupFoodSelectedView;
    __weak IBOutlet UIView *pickupCitySelectedView;
    __weak IBOutlet UIButton *btnPickUpCity;
    __weak IBOutlet UIButton *btnFindRestroSub;
    
    __weak IBOutlet UISearchBar *citySearchBar;
    __weak IBOutlet UISearchBar *foodSearchBar;
    
    
}
- (IBAction)onDoneFoodCaregory:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onFindRestaurants:(id)sender;
- (IBAction)onPickupFoodSelectedView:(id)sender;
- (IBAction)onPickupFoodViewClose:(id)sender;
- (IBAction)onPickupCityViewClose:(id)sender;
- (IBAction)onPickupCitySelectedView:(id)sender;
@end
