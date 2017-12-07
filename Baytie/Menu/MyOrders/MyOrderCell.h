//
//  MyOrderCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyOrderCellDelegate

@optional;
- (void)onRateIt:(NSDictionary *)dic;
- (void)onReorderOne:(NSDictionary *)dic;
- (void)onOrderDetailsOne:(NSDictionary *)dic;
- (void)onOrderCancelOne:(NSDictionary *)dic;
@end

@interface MyOrderCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *curDict;
+ (MyOrderCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)myOrdersItem;

@property (nonatomic, strong) id<MyOrderCellDelegate> delegate;

- (IBAction)onRateItForOrder:(id)sender;
- (IBAction)onReorder:(id)sender;
- (IBAction)onOrderDetails:(id)sender;
- (IBAction)onOrderCancel:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOneDeliveryStatus;
@property (weak, nonatomic) IBOutlet UIImageView *oneOrderProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOneRestroName;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOneNo;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOneAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOneDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOnePointsGained;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOneUsed;
@property (weak, nonatomic) IBOutlet UILabel *lblMyOrderOnePayment;

@property (weak, nonatomic) IBOutlet UIButton *btnReOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnRate;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end
