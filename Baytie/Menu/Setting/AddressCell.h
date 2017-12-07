//
//  AddressCell.h
//  Baytie
//
//  Created by stepanekdavid on 1/8/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *curDict;
+ (AddressCell *)sharedCell;
- (void)setAddressesItem:(NSDictionary *)addressItem;
@property (weak, nonatomic) IBOutlet UILabel *addressName;
@property (weak, nonatomic) IBOutlet UILabel *addressFull;
@end
