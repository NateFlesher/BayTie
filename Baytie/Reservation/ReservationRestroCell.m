//
//  ReservationRestroCell.m
//  Baytie
//
//  Created by stepanekdavid on 11/3/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ReservationRestroCell.h"

#import "UIImageView+AFNetworking.h"
@implementation ReservationRestroCell
{
    int rate;
}
+ (ReservationRestroCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ReservationRestroCell" owner:nil options:nil];
    ReservationRestroCell *cell = [array objectAtIndex:0];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    rate = 0;
}
- (void)swipeLeft:(id)sender{
    _ratingView.hidden = NO;
    [_ratingView setFrame:CGRectMake(316, 5, 194, 85)];
    CGRect viewSize = _ratingView.frame;
    [UIView animateWithDuration:0.5
                     animations: ^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         _ratingView.frame =CGRectMake(121, viewSize.origin.y, 320, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (![APPDELEGATE.availableSwippingCellsById containsObject:[_curDict objectForKey:@"location_id"]]) {
                                 [APPDELEGATE.availableSwippingCellsById addObject:[_curDict objectForKey:@"location_id"]];
                             }
                             [_delegate onReloadTableView];
                         }
                     }];
    
}
- (void)isSwipingCell:(BOOL)isSwipAble{
    if (isSwipAble) {
        _ratingView.hidden = NO;
    }else{
        _ratingView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryResItem
{
    _curDict = deliveryResItem;
}
- (IBAction)onRating:(id)sender {
    CGRect viewSize = _ratingView.frame;
    [UIView animateWithDuration:0.5
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         _ratingView.frame =CGRectMake(316, viewSize.origin.y, 320, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             _ratingView.hidden = YES;
                         }
                     }];
    [self removeGestureRecognizer:leftSwipeRecognizer];
    [_delegate onRestorRatingSetting:[NSString stringWithFormat:@"%d",rate] id:[_curDict objectForKey:@"location_id"]];
}

- (IBAction)onStar1:(id)sender {
    rate = 1;
    _star1.selected = !_star1.selected;
    if (!_star1.selected) {
        _star2.selected = NO;
        _star3.selected = NO;
        _star4.selected = NO;
        _star5.selected = NO;
    }
}

- (IBAction)onStar2:(id)sender {
    rate = 2;
    _star2.selected = !_star2.selected;
    if (_star2.selected) {
        _star1.selected = YES;
    }else{
        _star3.selected = NO;
        _star4.selected = NO;
        _star5.selected = NO;
    }
}

- (IBAction)onStar3:(id)sender {
    rate = 3;
    _star3.selected = !_star3.selected;
    if (_star3.selected) {
        _star1.selected = YES;
        _star2.selected = YES;
    }else{
        _star4.selected = NO;
        _star5.selected = NO;
    }
}

- (IBAction)onStar4:(id)sender {
    rate = 4;
    _star4.selected = !_star4.selected;
    if (_star4.selected) {
        _star1.selected = YES;
        _star2.selected = YES;
    }else{
        _star3.selected = NO;
        _star5.selected = NO;
    }
}

- (IBAction)onStar5:(id)sender {
    rate = 5;
    _star5.selected = !_star5.selected;
    if (_star5.selected) {
        _star1.selected = YES;
        _star2.selected = YES;
        _star3.selected = YES;
        _star4.selected = YES;
    }
}
- (IBAction)onClickSlot:(id)sender {
    NSInteger index = 0;
    if ([sender isEqual:_slot1]) {
        index = 1;
    }else if ([sender isEqual:_slot2]) {
        index = 2;
    }else if ([sender isEqual:_slot3]) {
        index = 3;
    }else if ([sender isEqual:_slot4]) {
        index = 4;
    }else if ([sender isEqual:_slot5]) {
        index = 5;
    }
    [_delegate onSlotSelected:_curDict index:index];
}
@end
