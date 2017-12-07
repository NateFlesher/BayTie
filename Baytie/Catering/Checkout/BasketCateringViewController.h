//
//  BasketCateringViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView/RATreeView.h>
#import "SKSTableView.h"
@interface BasketCateringViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    BOOL showKeyboard;
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIScrollView *addItemScrollView;
    __weak IBOutlet UIView *addIemView;
    __weak IBOutlet UILabel *lblRestroName;
    
    __weak IBOutlet UITableView *itemTableView;
    
    __weak IBOutlet UIButton *checkRedeemCoupon;
    __weak IBOutlet UIButton *checkLoyalityPoints;
    __weak IBOutlet UIButton *checkMataamPoints;
    
    __weak IBOutlet UITextField *txtCouponCode;
    
    __weak IBOutlet UILabel *lblLoyaltyPoint;
    __weak IBOutlet UILabel *lblLoyaltyBalance;
    __weak IBOutlet UILabel *lblMataamPoint;
    __weak IBOutlet UILabel *lblMataamBlance;
    
    __weak IBOutlet UILabel *lblSubTotal;
    __weak IBOutlet UILabel *lblDiscount;
    __weak IBOutlet UILabel *lblDeliveryCharges;
    __weak IBOutlet UILabel *lblGrandTotal;
    
    __weak IBOutlet UITextView *txtViewOrderNotes;
    
    __weak IBOutlet UILabel *lblPriceToEdit;
    __weak IBOutlet UILabel *lblQty;
    
    __weak IBOutlet UITextField *txtSpecialRequest;
    
    __weak IBOutlet UIButton *btnRedeemCoupon;
    __weak IBOutlet UIView *moveView;
    
}
- (IBAction)onAddItem:(id)sender;
- (IBAction)onUserCoupon:(id)sender;

- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;

- (IBAction)onCheckRedeem:(id)sender;
- (IBAction)onCheckLoyality:(id)sender;
- (IBAction)onCheckMataam:(id)sender;

- (IBAction)onContinue:(id)sender;

- (IBAction)onEditItemCloseView:(id)sender;

- (IBAction)onMinusQty:(id)sender;
- (IBAction)onPlusQty:(id)sender;

- (IBAction)onUpdateItemToEdit:(id)sender;
- (IBAction)onAddItems:(id)sender;

@property (nonatomic, retain) NSString *restroId;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *areaId;
@end
