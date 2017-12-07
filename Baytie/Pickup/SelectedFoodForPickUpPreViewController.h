//
//  SelectedFoodForPickUpPreViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RATreeView/RATreeView.h>
#import "SKSTableView.h"
@interface SelectedFoodForPickUpPreViewController : UIViewController{
    
    __weak IBOutlet UITableView *PlatTableview;
    BOOL showKeyboard;
    IBOutlet UIView *navView;
    IBOutlet UIView *foodLogoView;
    IBOutlet UIView *foodDetailView;
    IBOutlet UIView *foodPriceView;
    IBOutlet UIView *foodCategoryView;
    IBOutlet UIView *specialRequestQtyView;
    IBOutlet UIView *addToCartView;
    
    
    __weak IBOutlet UILabel *lblRestroName;
    __weak IBOutlet UILabel *lblFoodItemDetails;
    __weak IBOutlet UILabel *foodItemPrice;
    __weak IBOutlet UITableView *foodItemTableview;
    __weak IBOutlet UITextField *txtSpecialRequest;
    __weak IBOutlet UILabel *itemCount;
    __weak IBOutlet UIImageView *foodLogoImage;
    
    
    __weak IBOutlet UIView *categoryItemView;
    __weak IBOutlet UIButton *categoryItemDoneBtn;
    __weak IBOutlet UITableView *CategoryItemTableView;
}

- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onGoToCart:(id)sender;

@property (nonatomic, retain) NSDictionary *pickupFoodsItem;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic,retain) NSString *areaId;

- (IBAction)onMinusCount:(id)sender;
- (IBAction)onPlusCount:(id)sender;

- (IBAction)onCategoryItemViewClose:(id)sender;
- (IBAction)onCategoryItemViewDone:(id)sender;
@end
