//
//  PromotionsCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "PromotionsCell.h"

@implementation PromotionsCell
+ (PromotionsCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PromotionsCell" owner:nil options:nil];
    PromotionsCell *cell = [array objectAtIndex:0];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSDictionary *)promotionsItem
{
    _curDict = promotionsItem;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onGotoMenu:(id)sender {
    [_delegate GotoMenuPromo:_curDict];
}

- (IBAction)OnAddToCart:(id)sender {
    [_delegate GotoAddToCartPromo:_curDict];
}
@end
