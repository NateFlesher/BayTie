//
//  FoodCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *curDict;
+ (FoodCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryFoodItem;

@property (weak, nonatomic) IBOutlet UILabel *menuItemName;
@property (weak, nonatomic) IBOutlet UILabel *menuItemDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblFoodItemPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;
@property (weak, nonatomic) IBOutlet UIImageView *promoImage;
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;


@end
