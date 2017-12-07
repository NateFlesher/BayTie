//
//  DeliveryResCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "DeliveryResCell.h"
#import "UIImageView+AFNetworking.h"

@implementation DeliveryResCell{
    int rate;
}

+ (DeliveryResCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DeliveryResCell" owner:nil options:nil];
    DeliveryResCell *cell = [array objectAtIndex:0];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    rate = 0;
}
//- (void)layoutSubviews{
//    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
//    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self addGestureRecognizer:leftSwipeRecognizer];
//}
- (void)swipeLeft:(id)sender{
    _ratingView.hidden = NO;
    [_ratingView setFrame:CGRectMake(316, 5, 170, 108)];
    CGRect viewSize = _ratingView.frame;
    [UIView animateWithDuration:0.5
                     animations: ^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         _ratingView.frame =CGRectMake(146, viewSize.origin.y, 320, viewSize.size.height);
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
- (void)setCurWorkoutsItem:(NSDictionary *)deliveryResItem
{
    _curDict = deliveryResItem;
}

- (IBAction)onOkayForRating:(id)sender {
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
// Configure the view for the selected state

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (IBAction)onRateStarOne:(id)sender {
    rate = 1;
    _btnStarOne.selected = !_btnStarOne.selected;
    if (!_btnStarOne.selected) {
        _btnStarTwo.selected = NO;
        _btnStarThree.selected = NO;
        _btnStarFour.selected = NO;
        _btnStarFive.selected = NO;
    }
}

- (IBAction)onRateStarTwo:(id)sender {
    rate = 2;
    _btnStarTwo.selected = !_btnStarTwo.selected;
    if (_btnStarTwo.selected) {
        _btnStarOne.selected = YES;
    }else{
        _btnStarThree.selected = NO;
        _btnStarFour.selected = NO;
        _btnStarFive.selected = NO;
    }
}

- (IBAction)onRateStarThree:(id)sender {
    rate = 3;
    _btnStarThree.selected = !_btnStarThree.selected;
    if (_btnStarThree.selected) {
        _btnStarOne.selected = YES;
        _btnStarTwo.selected = YES;
    }else{
        _btnStarFour.selected = NO;
        _btnStarFive.selected = NO;
    }
}

- (IBAction)onRateStarFour:(id)sender {
    rate = 4;
    _btnStarThree.selected = !_btnStarThree.selected;
    if (_btnStarThree.selected) {
        _btnStarOne.selected = YES;
        _btnStarTwo.selected = YES;
    }else{
        _btnStarFour.selected = NO;
        _btnStarFive.selected = NO;
    }
}

- (IBAction)onRateStarFive:(id)sender {
    rate = 5;
    _btnStarFive.selected = !_btnStarFive.selected;
    if (_btnStarFive.selected) {
        _btnStarOne.selected = YES;
        _btnStarTwo.selected = YES;
        _btnStarThree.selected = YES;
        _btnStarFour.selected = YES;
    }
}
@end
