//
//  MyReservationsCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "MyReservationsCell.h"

@implementation MyReservationsCell
+ (MyReservationsCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyReservationsCell" owner:nil options:nil];
    MyReservationsCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSDictionary *)myReservationsItem
{
    _curDict = myReservationsItem;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onRateForReservation:(id)sender {
    [_delegate onRateItForReservation:_curDict];
}

- (IBAction)onDetailsReservation:(id)sender {
    [_delegate onReservationDetailsOne:_curDict];
}

- (IBAction)onPayReservation:(id)sender {
    [_delegate onReservationPayOne:_curDict];
}

- (IBAction)onCancelForReservation:(id)sender {
    [_delegate onReservationCancelOne:_curDict];
}
@end
