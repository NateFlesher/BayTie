//
//  ReviewsOfUserCell.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewsOfUserCell : UITableViewCell
{

}

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;


@property (nonatomic, retain) NSDictionary *curDict;
+ (ReviewsOfUserCell *)sharedCell;
- (void)setReviewsItem:(NSDictionary *)reviewItem;

@end
