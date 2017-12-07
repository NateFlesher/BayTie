//
//  ReservationRestroCell.h
//  Baytie
//
//  Created by stepanekdavid on 11/3/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReservationRestroCellDelegate

@optional;
- (void)onRestorRatingSetting:(NSString *)rate id:(NSString *)_id;
- (void)onReloadTableView;
- (void)onSlotSelected:(NSDictionary *)dic index:(NSInteger)_index;
@end

@interface ReservationRestroCell : UITableViewCell<UIGestureRecognizerDelegate>{
    UISwipeGestureRecognizer *leftSwipeRecognizer;
}
@property (nonatomic, retain) NSDictionary *curDict;
+ (ReservationRestroCell *)sharedCell;
@property (nonatomic, strong) id<ReservationRestroCellDelegate> delegate;
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryResItem;
- (void)isSwipingCell:(BOOL)isSwipAble;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UIImageView *featureImage;
@property (weak, nonatomic) IBOutlet UIImageView *promoImage;
@property (weak, nonatomic) IBOutlet UILabel *lblRestroImage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *restroLogoImage;
@property BOOL isSwiping;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *star1;
@property (weak, nonatomic) IBOutlet UIButton *star2;
@property (weak, nonatomic) IBOutlet UIButton *star3;
@property (weak, nonatomic) IBOutlet UIButton *star4;
@property (weak, nonatomic) IBOutlet UIButton *star5;

- (IBAction)onRating:(id)sender;
- (IBAction)onStar1:(id)sender;
- (IBAction)onStar2:(id)sender;
- (IBAction)onStar3:(id)sender;
- (IBAction)onStar4:(id)sender;
- (IBAction)onStar5:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *slot1;
@property (weak, nonatomic) IBOutlet UIButton *slot2;
@property (weak, nonatomic) IBOutlet UIButton *slot3;
@property (weak, nonatomic) IBOutlet UIButton *slot4;
@property (weak, nonatomic) IBOutlet UIButton *slot5;

- (IBAction)onClickSlot:(id)sender;

@end
