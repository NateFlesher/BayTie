//
//  BasketFoodViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView/RATreeView.h>
#import "SKSTableView.h"

@interface BasketFoodViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
     BOOL showKeyboard;
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIScrollView *scrViewToEdit;
    
    
    __weak IBOutlet UITableView *itemTableView;
    
    __weak IBOutlet UIButton *btnCheckCoupon;
    __weak IBOutlet UIButton *btnLoyaltyPoint;
    __weak IBOutlet UIButton *btnMataamPoint;
    __weak IBOutlet UIView *updateItemView;
    
    
    __weak IBOutlet UITableView *deliveryItemsTableView;
    __weak IBOutlet UILabel *currentItemPriceToEdit;
    __weak IBOutlet UILabel *lblQtyToEdit;
    __weak IBOutlet UITextField *txtSpecalRequestToEdit;
    __weak IBOutlet UITextView *txtVieworderNotes;
    
    
    __weak IBOutlet UILabel *lblLoyaltyPoints;
    __weak IBOutlet UILabel *lblLoyalBalance;
    __weak IBOutlet UILabel *lblMataamPoints;
    __weak IBOutlet UILabel *lblMataamBalance;
    __weak IBOutlet UILabel *lblSubTotal;
    __weak IBOutlet UILabel *lblDiscount;
    __weak IBOutlet UILabel *lblGrandTotal;
    __weak IBOutlet UILabel *lblDeliveryCharges;
    __weak IBOutlet UITextField *txtCouponCode;
    
    __weak IBOutlet UILabel *lblRestroName;
    
    __weak IBOutlet UIButton *btnRedeemCoupon;
    
    __weak IBOutlet UIView *categoryItemView;
    __weak IBOutlet UIButton *categoryItemDoneBtn;
    __weak IBOutlet UITableView *CategoryItemTableView;

    __weak IBOutlet UIView *moveView;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onCheckCoupon:(id)sender;
- (IBAction)onLoyaltyPoints:(id)sender;
- (IBAction)onMataamPoints:(id)sender;

- (IBAction)onContinue:(id)sender;

- (IBAction)onUseCoupon:(id)sender;

@property (nonatomic, retain) NSString *restroId;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSDictionary *parMenuFoodItem;

- (IBAction)editItemViewClose:(id)sender;
- (IBAction)onUpdateCurrentItem:(id)sender;

- (IBAction)onMinusQty:(id)sender;
- (IBAction)onPlusQty:(id)sender;

- (IBAction)onAddItems:(id)sender;

- (IBAction)onCategoryItemViewClose:(id)sender;
- (IBAction)onCategoryItemViewDone:(id)sender;
@end
