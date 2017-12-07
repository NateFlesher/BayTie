//
//  DeliveryCheckOutViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryCheckOutViewController : UIViewController{

    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIButton *btnAddressName;
    __weak IBOutlet UIButton *checkPayCash;
    __weak IBOutlet UIButton *checkPayKnet;
    __weak IBOutlet UIButton *checkPayCreditCard;
    
    __weak IBOutlet UIButton *btnDateTime;
    
    __weak IBOutlet UILabel *lblArea;
    __weak IBOutlet UILabel *lblBlock;
    __weak IBOutlet UILabel *lblStreet;
    __weak IBOutlet UILabel *lblBuildingNo;
    __weak IBOutlet UILabel *lblFloor;
    __weak IBOutlet UILabel *lblAppart;
    __weak IBOutlet UILabel *lblUserMobileNum;
    __weak IBOutlet UITextView *txtViewDirection;
    __weak IBOutlet UILabel *lblTotal;
    __weak IBOutlet UILabel *lblDiscount;
    __weak IBOutlet UILabel *lblDeliveryCharge;
    __weak IBOutlet UILabel *lblGrandTotal;
    
    __weak IBOutlet UILabel *lblTimeForPlannedOrder;
    __weak IBOutlet UILabel *lbldayOfweekForPlannedOrder;
    __weak IBOutlet UILabel *lblDateForPlannedOrder;
    
    __weak IBOutlet UIView *updateDateView;
    __weak IBOutlet UIDatePicker *getDateTime;
    __weak IBOutlet UITableView *SelectedAddressTableView;
    __weak IBOutlet UILabel *restroName;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onEdit:(id)sender;
- (IBAction)onAddressName:(id)sender;

- (IBAction)onCheckPayCash:(id)sender;
- (IBAction)onCheckPayKnet:(id)sender;
- (IBAction)onCheckPayCreditCard:(id)sender;

- (IBAction)onChckedDateTime:(id)sender;
- (IBAction)onUpdateDateTimeView:(id)sender;
- (IBAction)onCloseDateTimeView:(id)sender;
- (IBAction)onUPdateDateTime:(id)sender;

- (IBAction)onCheckOut:(id)sender;
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
