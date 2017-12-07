//
//  PointsCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *curDict;
+ (PointsCell *)sharedCell;
- (void)setPointsItem:(NSDictionary *)pointsItem;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *lblRestroName;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lblAmout;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblGainedPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;







@end
