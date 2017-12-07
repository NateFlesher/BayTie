//
//  DeliveryResCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeliveryResCellDelegate

@optional;
- (void)onRestorRatingSetting:(NSString *)rate id:(NSString *)_id;
- (void)onReloadTableView;
@end

@interface DeliveryResCell : UITableViewCell<UIGestureRecognizerDelegate>{
    
    UISwipeGestureRecognizer *leftSwipeRecognizer;
}

@property (nonatomic, retain) NSDictionary *curDict;
@property (weak, nonatomic) IBOutlet UIView *ratingView;

+ (DeliveryResCell *)sharedCell;
@property (nonatomic, strong) id<DeliveryResCellDelegate> delegate;
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryResItem;
- (void)isSwipingCell:(BOOL)isSwipAble;

- (IBAction)onOkayForRating:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnStarOne;
@property (weak, nonatomic) IBOutlet UIButton *btnStarTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnStarThree;
@property (weak, nonatomic) IBOutlet UIButton *btnStarFour;
@property (weak, nonatomic) IBOutlet UIButton *btnStarFive;

@property (weak, nonatomic) IBOutlet UIImageView *restroLogo;
@property (weak, nonatomic) IBOutlet UILabel *restroName;
@property (weak, nonatomic) IBOutlet UILabel *lblMinOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveryTime;

@property (weak, nonatomic) IBOutlet UIImageView *restroStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *lblRestroStatus;

@property (weak, nonatomic) IBOutlet UIImageView *restroRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *restroFeaturedImage;
@property (weak, nonatomic) IBOutlet UIImageView *restroBowImage;
@property (weak, nonatomic) IBOutlet UIImageView *restroPaymentC;
@property (weak, nonatomic) IBOutlet UIImageView *restroPaymentD;
@property (weak, nonatomic) IBOutlet UIImageView *restroPaymentK;


@property BOOL isSwiping;

- (IBAction)onRateStarOne:(id)sender;
- (IBAction)onRateStarTwo:(id)sender;
- (IBAction)onRateStarThree:(id)sender;
- (IBAction)onRateStarFour:(id)sender;
- (IBAction)onRateStarFive:(id)sender;


@end
