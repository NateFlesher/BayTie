//
//  MyOrderCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell
+ (MyOrderCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:nil options:nil];
    MyOrderCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSDictionary *)myOrdersItem
{
    _curDict = myOrdersItem;
}

- (IBAction)onRateItForOrder:(id)sender {
    [_delegate onRateIt:_curDict];
}

- (IBAction)onReorder:(id)sender {
    [_delegate onReorderOne:_curDict];
}

- (IBAction)onOrderDetails:(id)sender {
    [_delegate onOrderDetailsOne:_curDict];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onOrderCancel:(id)sender {
    [_delegate onOrderCancelOne:_curDict];
}
@end
