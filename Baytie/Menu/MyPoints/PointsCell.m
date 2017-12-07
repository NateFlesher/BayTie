//
//  PointsCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "PointsCell.h"

@implementation PointsCell
+ (PointsCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PointsCell" owner:nil options:nil];
    PointsCell *cell = [array objectAtIndex:0];
    
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
- (void)setPointsItem:(NSDictionary *)pointsItem
{
    _curDict = pointsItem;
}
@end
