//
//  ChildCityAndFoodCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/15/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ChildCityAndFoodCell.h"

@implementation ChildCityAndFoodCell
+ (ChildCityAndFoodCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ChildCityAndFoodCell" owner:nil options:nil];
    ChildCityAndFoodCell *cell = [array objectAtIndex:0];
    
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
- (void)setCurWorkoutsItem:(NSString *)cityAndFoodItem
{
    _lblChildCityName.text = cityAndFoodItem;
    //_curDict = cityAndFoodItem;
}
@end
