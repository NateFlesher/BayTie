//
//  FoodItemForDeliveryCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "FoodItemForDeliveryCell.h"

@implementation FoodItemForDeliveryCell
+ (FoodItemForDeliveryCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FoodItemForDeliveryCell" owner:nil options:nil];
    FoodItemForDeliveryCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setOrderCartItem:(NSDictionary *)item
{
    _curDict = item;
}

- (IBAction)oniTemEdit:(id)sender {
    if (_delegate)
        [_delegate onOrderCartEditItem:_curDict];
}

- (IBAction)onDeleteItem:(id)sender {
    if (_delegate)
        [_delegate onOrderCartDeleteItem:_curDict];
}

@end
