//
//  FoodMenuCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodMenuCell : UITableViewCell{
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblFoodName;
@property (weak, nonatomic) IBOutlet UIImageView *smallLogoImage;

@property (nonatomic, retain) NSDictionary *curDict;
+ (FoodMenuCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)foodMenuItem;

@end
