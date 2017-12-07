//
//  PickupAddressCell.m
//  Baytie
//
//  Created by stepanekdavid on 11/3/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "PickupAddressCell.h"

@implementation PickupAddressCell
+ (PickupAddressCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PickupAddressCell" owner:nil options:nil];
    PickupAddressCell *cell = [array objectAtIndex:0];
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
- (void)setCurWorkoutsItem:(NSDictionary *)pickupResItem
{
    _curDict = pickupResItem;
}

- (IBAction)onSelectedLocation:(id)sender {
    _btnLocation.selected = !_btnLocation.selected;
}
@end
