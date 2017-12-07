//
//  SelectedFoodPreViewFitViewController.h
//  Baytie
//
//  Created by stepanekdavid on 1/17/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView/RATreeView.h>
#import "SKSTableView.h"
@interface SelectedFoodPreViewFitViewController : UIViewController
{
    BOOL showKeyboard;
    IBOutlet UIView *navView;
    IBOutlet UIView *foodLogoView;
    IBOutlet UIView *foodDetailView;
    IBOutlet UIView *foodPriceView;
    IBOutlet UIView *foodCategoryView;
    IBOutlet UIView *specialRequestQtyView;
    IBOutlet UIView *addToCartView;
    
    //navView
    __weak IBOutlet UILabel *lblSelectedRestroName;
    
    __weak IBOutlet UIImageView *foodItemProfileImage;
    
    __weak IBOutlet UILabel *lblFoodItemDetails;
    
    __weak IBOutlet UILabel *foodItemPrice;
    
    __weak IBOutlet UITableView *choiceCategoriesTableView;
    
    __weak IBOutlet UITextField *txtSpecialRequest;
    
    __weak IBOutlet UILabel *lblAmount;
    
    __weak IBOutlet UIView *categoryItemView;
    __weak IBOutlet UIButton *categoryItemDoneBtn;
    __weak IBOutlet UITableView *CategoryItemTableView;
    
    __weak IBOutlet UITableView *PlatTableView;
}
//navView
- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;


- (IBAction)onFoodBasket:(id)sender;

- (IBAction)onDiscount:(id)sender;
- (IBAction)onCount:(id)sender;
@property (nonatomic, retain) NSDictionary *deliveryFoodsItem;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *areaId;


- (IBAction)onCategoryItemViewDone:(id)sender;
- (IBAction)onCategoryItemViewClose:(id)sender;


@property (strong, nonatomic) NSMutableArray *tables;
@end


