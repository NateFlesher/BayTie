//
//  FoodCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "FoodCell.h"

@implementation FoodCell
+ (FoodCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FoodCell" owner:nil options:nil];
    FoodCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryFoodItem
{
    _curDict = deliveryFoodItem;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
