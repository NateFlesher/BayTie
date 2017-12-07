//
//  NotificationsCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "NotificationsCell.h"

@implementation NotificationsCell
+ (NotificationsCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NotificationsCell" owner:nil options:nil];
    NotificationsCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSDictionary *)notificationsItem
{
    _curDict = notificationsItem;
}

- (IBAction)onDeleteNotification:(id)sender {
    if (_delegate)
        [_delegate onNotiDeleteItem:_curDict];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
