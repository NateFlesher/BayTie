//
//  PromotionsCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PromotionsCellDelegate

@optional;
- (void)GotoAddToCartPromo:(NSDictionary *)dic;
- (void)GotoMenuPromo:(NSDictionary *)dic;
@end

@interface PromotionsCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *curDict;
+ (PromotionsCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)promotionsItem;


@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImage;

@property (weak, nonatomic) IBOutlet UILabel *lblRestroName;
@property (weak, nonatomic) IBOutlet UILabel *lblPromotionName;
@property (weak, nonatomic) IBOutlet UILabel *lblPromotionsDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (nonatomic, strong) id<PromotionsCellDelegate> delegate;

- (IBAction)onGotoMenu:(id)sender;
- (IBAction)OnAddToCart:(id)sender;

@end
