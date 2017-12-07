//
//  ParentCityAndFoodCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/15/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentCityAndFoodCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *curDict;
+ (ParentCityAndFoodCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSString *)cityAndFoodItem;
@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UIImageView *imgCityAndFood;

@property (nonatomic, assign, getter = isExpandable) BOOL expandable;
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;

- (void)addIndicatorView;
- (void)removeIndicatorView;
- (BOOL)containsIndicatorView;
- (void)accessoryViewAnimation;

@end
