//
//  ChildCityAndFoodCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/15/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildCityAndFoodCell : UITableViewCell{

}
@property (nonatomic, retain) NSDictionary *curDict;
+ (ChildCityAndFoodCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSString *)cityAndFoodItem;

@property (weak, nonatomic) IBOutlet UILabel *lblChildCityName;
@property (weak, nonatomic) IBOutlet UIImageView *imgOption;


@end
