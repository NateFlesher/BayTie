//
//  CatergoryCell.h
//  Baytie
//
//  Created by stepanekdavid on 1/5/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatergoryCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *curDict;
+ (CatergoryCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)valItem;
@property (weak, nonatomic) IBOutlet UILabel *lblCatergoryName;
@end
