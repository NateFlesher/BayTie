//
//  LocationCell.h
//  Baytie
//
//  Created by stepanekdavid on 11/3/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LocationCellDelegate

@optional;
- (void)onReloadTableView;
@end
@interface LocationCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *curDict;
+ (LocationCell *)sharedCell;
@property (nonatomic, strong) id<LocationCellDelegate> delegate;
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryResItem;


@property (weak, nonatomic) IBOutlet UIButton *btnSelectedLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblPersons;


- (IBAction)onSelectedLocation:(id)sender;



@end
