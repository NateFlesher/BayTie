//
//  FoodItemForDeliveryCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FoodItemForDeliveryCellDelegate

@optional;
- (void)onOrderCartDeleteItem:(NSDictionary *)dic;
- (void)onOrderCartEditItem:(NSDictionary *)dic;
@end

@interface FoodItemForDeliveryCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *curDict;
+ (FoodItemForDeliveryCell *)sharedCell;
- (void)setOrderCartItem:(NSDictionary *)item;

@property (nonatomic, strong) id<FoodItemForDeliveryCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblItemQty;
@property (weak, nonatomic) IBOutlet UILabel *ItemTotal;



- (IBAction)oniTemEdit:(id)sender;
- (IBAction)onDeleteItem:(id)sender;
@end
