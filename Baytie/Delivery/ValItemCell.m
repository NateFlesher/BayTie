//
//  ValItemCell.m
//  Baytie
//
//  Created by stepanekdavid on 12/28/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ValItemCell.h"

@implementation ValItemCell

+ (ValItemCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValItemCell" owner:nil options:nil];
    ValItemCell *cell = [array objectAtIndex:0];
    
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
- (void)setCurWorkoutsItem:(NSDictionary *)valItem
{
    _curDict = valItem;
}

@end
