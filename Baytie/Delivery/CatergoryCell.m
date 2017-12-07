//
//  CatergoryCell.m
//  Baytie
//
//  Created by stepanekdavid on 1/5/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import "CatergoryCell.h"

@implementation CatergoryCell
+ (CatergoryCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CatergoryCell" owner:nil options:nil];
    CatergoryCell *cell = [array objectAtIndex:0];
    
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
