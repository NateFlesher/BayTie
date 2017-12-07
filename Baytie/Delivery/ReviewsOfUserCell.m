//
//  ReviewsOfUserCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ReviewsOfUserCell.h"

@implementation ReviewsOfUserCell
+ (ReviewsOfUserCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ReviewsOfUserCell" owner:nil options:nil];
    ReviewsOfUserCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setReviewsItem:(NSDictionary *)reviewItem
{
    _curDict = reviewItem;
    //_curDict = foodMenuItem;
}
@end
