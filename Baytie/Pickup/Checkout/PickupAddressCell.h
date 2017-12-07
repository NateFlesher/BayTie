//
//  PickupAddressCell.h
//  Baytie
//
//  Created by stepanekdavid on 11/3/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickupAddressCellDelegate

@optional;
- (void)onReloadTableView;
@end

@interface PickupAddressCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *curDict;
+ (PickupAddressCell *)sharedCell;
@property (nonatomic, strong) id<PickupAddressCellDelegate> delegate;
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryResItem;

@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

- (IBAction)onSelectedLocation:(id)sender;

@end
