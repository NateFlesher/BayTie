//
//  SelectedCateringPreViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCateringPreViewController : UIViewController{
    BOOL showKeyboard;
    IBOutlet UIView *navView;
    IBOutlet UIView *foodLogoView;
    IBOutlet UIView *foodDetailView;
    IBOutlet UIView *foodPriceView;
    IBOutlet UIView *specialRequestQtyView;
    IBOutlet UIView *addToCartView;
    __weak IBOutlet UITableView *PlatTableview;
    
    __weak IBOutlet UIImageView *foodLogoImage;
    
    __weak IBOutlet UILabel *lblCount;
    __weak IBOutlet UILabel *lblPriceForFood;
    __weak IBOutlet UILabel *lblFoodDetails;
    
    __weak IBOutlet UITextField *txtSpecialRequest;
    
    __weak IBOutlet UILabel *lblRestroName;
}
- (IBAction)onMinusCount:(id)sender;
- (IBAction)onPlusCount:(id)sender;

- (IBAction)onMenu:(id)sender;
- (IBAction)onclose:(id)sender;
- (IBAction)onCateringBasket:(id)sender;

@property (nonatomic, retain) NSDictionary *deliveryFoodsItem;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *areaId;
@end
