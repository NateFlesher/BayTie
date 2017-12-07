//
//  MyReservationsCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyReservationsCellDelegate

@optional;
- (void)onRateItForReservation:(NSDictionary *)dic;
- (void)onReservationPayOne:(NSDictionary *)dic;
- (void)onReservationDetailsOne:(NSDictionary *)dic;
- (void)onReservationCancelOne:(NSDictionary *)dic;
@end

@interface MyReservationsCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *curDict;
+ (MyReservationsCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)myReservationsItem;

@property (nonatomic, strong) id<MyReservationsCellDelegate> delegate;

- (IBAction)onRateForReservation:(id)sender;
- (IBAction)onDetailsReservation:(id)sender;
- (IBAction)onPayReservation:(id)sender;
- (IBAction)onCancelForReservation:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *reservationStatusImage;
@property (weak, nonatomic) IBOutlet UIImageView *reservationOneProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblReservationOneStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblReservationRestroName;
@property (weak, nonatomic) IBOutlet UILabel *lblReservationNo;
@property (weak, nonatomic) IBOutlet UILabel *lblReservationDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblReservationPointsGained;
@property (weak, nonatomic) IBOutlet UILabel *lblReservationUsed;

@property (weak, nonatomic) IBOutlet UIButton *btnRate;
@property (weak, nonatomic) IBOutlet UIButton *btnCancenl;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;



@end
