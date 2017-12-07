//
//  LocationCell.m
//  Baytie
//
//  Created by stepanekdavid on 11/3/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell
+ (LocationCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:nil options:nil];
    LocationCell *cell = [array objectAtIndex:0];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryResItem
{
    _curDict = deliveryResItem;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onSelectedLocation:(id)sender {
}
@end
