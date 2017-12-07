//
//  CateringCheckOutViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CateringCheckOutViewController : UIViewController{

    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIButton *btnCheckCash;
    __weak IBOutlet UIButton *btnCheckKnet;
    __weak IBOutlet UIButton *btnCheckCreditCard;
    __weak IBOutlet UIButton *btnCheckPayPal;
    
    __weak IBOutlet UILabel *lblRestroName;
    
    __weak IBOutlet UIButton *btnSavedAddressName;
    
    __weak IBOutlet UILabel *lblArea;
    __weak IBOutlet UILabel *lblBlock;
    __weak IBOutlet UILabel *lblStreet;
    __weak IBOutlet UILabel *lblBuilding;
    __weak IBOutlet UILabel *lblFloor;
    __weak IBOutlet UILabel *lblAppartment;
    __weak IBOutlet UILabel *lblMobileNumber;
    
    __weak IBOutlet UITextView *txtViewDirection;
    
    __weak IBOutlet UIButton *btnDateForPlain;
    __weak IBOutlet UILabel *lblTimeFor;
    __weak IBOutlet UILabel *lblDayOfWeek;
    __weak IBOutlet UILabel *lblDateFor;
    
    __weak IBOutlet UILabel *lblTotal;
    __weak IBOutlet UILabel *lblDiscount;
    __weak IBOutlet UILabel *lblDeliveryCharges;
    __weak IBOutlet UILabel *lblGrandTotal;
    
    __weak IBOutlet UIDatePicker *dateTimePick;
    __weak IBOutlet UIView *updateDateTimeView;
    
    __weak IBOutlet UITableView *CateringAddressLocationTableView;
}
- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onAddressEdit:(id)sender;
- (IBAction)onSavedAddressName:(id)sender;

- (IBAction)onCheckCash:(id)sender;
- (IBAction)onCheckKnet:(id)sender;
- (IBAction)onCheckCreditCard:(id)sender;

- (IBAction)onCheckOut:(id)sender;

- (IBAction)onViewDateTime:(id)sender;
- (IBAction)onViewDateTimeClose:(id)sender;
- (IBAction)onUpdateDateTime:(id)sender;
- (IBAction)onCheckDatetime:(id)sender;

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
