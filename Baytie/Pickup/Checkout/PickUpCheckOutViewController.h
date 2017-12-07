//
//  PickUpCheckOutViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickUpCheckOutViewController : UIViewController{

    __weak IBOutlet UILabel *lblselectedRestroName;
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIButton *btnCheckCash;
    __weak IBOutlet UIButton *btnCheckKnet;
    __weak IBOutlet UIButton *btnCheckCreditCard;
    __weak IBOutlet UIButton *btnCheckPayPal;
    
    __weak IBOutlet UIButton *btnCheckDateTime;
    __weak IBOutlet UILabel *lblDayOfWeekToPlan;
    __weak IBOutlet UILabel *lblTimeToPlan;
    __weak IBOutlet UILabel *lblDateToPlan;
    __weak IBOutlet UIView *updateDateView;
    __weak IBOutlet UIDatePicker *dateTimePick;
    
    __weak IBOutlet UILabel *lblAddressForPickup;
    __weak IBOutlet UILabel *lblPhoneNumForPickup;
    
    
    __weak IBOutlet UILabel *lblTotal;
    __weak IBOutlet UILabel *lbldiscount;
    __weak IBOutlet UILabel *lblGrandTotal;
    __weak IBOutlet UIButton *btnChoosePickUpAddress;
    
}
- (IBAction)onUpdateDateViewClose:(id)sender;
- (IBAction)onUpdateDateTime:(id)sender;

- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;

- (IBAction)onCheckOut:(id)sender;


- (IBAction)onCheckCash:(id)sender;
- (IBAction)onCheckKnet:(id)sender;
- (IBAction)onCheckCreditCard:(id)sender;
- (IBAction)onCheckPayPal:(id)sender;
- (IBAction)onBtnCheckDateTime:(id)sender;

- (IBAction)onvDateTimeView:(id)sender;

- (IBAction)onPickUpAddress:(id)sender;




@property (nonatomic, retain) NSString *restroId;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *couponCode;
@property (nonatomic, retain) NSString *total;
@property (nonatomic, retain) NSString *discount;
@property (nonatomic, retain) NSString *deliveryCharges;
@property (nonatomic, retain) NSString *grandTotal;
@property NSInteger redeemType;

@end
