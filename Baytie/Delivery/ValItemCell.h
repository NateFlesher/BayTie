//
//  ValItemCell.h
//  Baytie
//
//  Created by stepanekdavid on 12/28/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValItemCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *curDict;
+ (ValItemCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)valItem;

@property (weak, nonatomic) IBOutlet UILabel *valName;
@property (weak, nonatomic) IBOutlet UILabel *valPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgOption;
@end
