//
//  BasketPickUpViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView/RATreeView.h>
#import "SKSTableView.h"

@interface BasketPickUpViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    BOOL showKeyboard;
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIScrollView *itemEditScrolView;
    __weak IBOutlet UIButton *btnCheckCoupon;
    __weak IBOutlet UIButton *btnLoyaltyPoint;
    __weak IBOutlet UIButton *btnMataamPoints;
    __weak IBOutlet UIView *editItemView;
    __weak IBOutlet UILabel *lblRestroName;
    
    __weak IBOutlet UITextField *txtCouponCode;
    
    __weak IBOutlet UILabel *lblLoyaltyPoints;
    __weak IBOutlet UILabel *lblLoyalBalance;
    __weak IBOutlet UILabel *lblMataamPoints;
    __weak IBOutlet UILabel *lblMataamBalance;
    __weak IBOutlet UILabel *lblSubTotal;
    __weak IBOutlet UILabel *lblDiscount;
    __weak IBOutlet UILabel *lblGrandTotal;
    __weak IBOutlet UILabel *lblDeliveryCharges;
    
    __weak IBOutlet UITextView *txtViewOrderNotes;
    
    __weak IBOutlet UILabel *lblItemPriceToEdit;
    __weak IBOutlet UILabel *lblItemCountToEdit;
    __weak IBOutlet UITextField *txtSpecialRequestToEdit;
    
    __weak IBOutlet UITableView *pickupItemsTableView;
    __weak IBOutlet UITableView *itemTableView;
    
    __weak IBOutlet UIButton *btnRedeemCoupon;
    
    __weak IBOutlet UIView *categoryItemView;
    __weak IBOutlet UIButton *categoryItemDoneBtn;
    __weak IBOutlet UITableView *CategoryItemTableView;
    
    __weak IBOutlet UIView *moveView;
}
- (IBAction)onAddItems:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;

- (IBAction)onCheckCoupon:(id)sender;
- (IBAction)onLoyaltyPoints:(id)sender;
- (IBAction)onMataamPoints:(id)sender;

- (IBAction)onMinusToEdit:(id)sender;
- (IBAction)onPlusToEdit:(id)sender;

- (IBAction)onContinue:(id)sender;

- (IBAction)onEidtItemClose:(id)sender;
- (IBAction)onUpdateToEdit:(id)sender;

- (IBAction)onUserCoupon:(id)sender;
@property (nonatomic, retain) NSString *restroId;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *areaId;

- (IBAction)onCategoryItemViewClose:(id)sender;
- (IBAction)onCategoryItemViewDone:(id)sender;
@end
