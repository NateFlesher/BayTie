//
//  AddressCell.m
//  Baytie
//
//  Created by stepanekdavid on 1/8/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell
+ (AddressCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:nil options:nil];
    AddressCell *cell = [array objectAtIndex:0];
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
- (void)setAddressesItem:(NSDictionary *)addressItem
{
    _curDict = addressItem;
}
@end
