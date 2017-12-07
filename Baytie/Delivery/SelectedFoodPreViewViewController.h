//
//  SelectedFoodPreViewViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView/RATreeView.h>
#import "SKSTableView.h"

@interface SelectedFoodPreViewViewController : UIViewController
{
    BOOL showKeyboard;
    IBOutlet UIView *navView;
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UILabel *lblAmount;
    
    __weak IBOutlet UILabel *lblSelectedRestroName;
    
    __weak IBOutlet UIImageView *foodItemProfileImage;
    __weak IBOutlet UILabel *foodItemDetails;
    __weak IBOutlet UITextView *txtFoodItemDetails;
    __weak IBOutlet UILabel *foodItemPrice;
    __weak IBOutlet UITableView *choiceCategoriesTableView;
    __weak IBOutlet UIView *moveView;
    
    __weak IBOutlet UITextField *txtSpecialRequest;
    
    __weak IBOutlet UILabel *lblMenuItem;
    
    
    __weak IBOutlet UIView *categoryItemView;
    __weak IBOutlet UIButton *categoryItemDoneBtn;
    __weak IBOutlet UITableView *CategoryItemTableView;
    
    __weak IBOutlet UILabel *lblPriceTitle;
    
}

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onFoodBasket:(id)sender;

- (IBAction)onDiscount:(id)sender;
- (IBAction)onCount:(id)sender;
@property (nonatomic, retain) NSDictionary *deliveryFoodsItem;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *areaId;


- (IBAction)onCategoryItemViewClose:(id)sender;
- (IBAction)onCategoryItemViewDone:(id)sender;


@end
