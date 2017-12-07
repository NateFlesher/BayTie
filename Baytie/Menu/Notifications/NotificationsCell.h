//
//  NotificationsCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NotificationsCelllDelegate

@optional;
- (void)onNotiDeleteItem:(NSDictionary *)dic;
@end

@interface NotificationsCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *curDict;
+ (NotificationsCell *)sharedCell;
@property (nonatomic, strong) id<NotificationsCelllDelegate> delegate;
- (void)setCurWorkoutsItem:(NSDictionary *)notificationsItem;
- (IBAction)onDeleteNotification:(id)sender;
@end
