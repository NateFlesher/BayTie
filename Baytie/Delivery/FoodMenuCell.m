//
//  FoodMenuCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "FoodMenuCell.h"

@implementation FoodMenuCell

+ (FoodMenuCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FoodMenuCell" owner:nil options:nil];
    FoodMenuCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    switch (APPDELEGATE.serviceType) {
        case 1:
            [_smallLogoImage setImage:[UIImage imageNamed:@"small_logo_green.png"]];
            break;
        case 2:
            [_smallLogoImage setImage:[UIImage imageNamed:@"small_logo_orange.png"]];
            break;
        case 3:
            [_smallLogoImage setImage:[UIImage imageNamed:@"small_logo_red.png"]];
            break;
        case 4:
            [_smallLogoImage setImage:[UIImage imageNamed:@"small_logo_blue.png"]];
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCurWorkoutsItem:(NSDictionary *)foodMenuItem
{
    _lblFoodName.text = [foodMenuItem objectForKey:@"cat_name"];
    _curDict = foodMenuItem;
}
@end
