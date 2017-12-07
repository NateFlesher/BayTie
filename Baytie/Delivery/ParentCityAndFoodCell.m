//
//  ParentCityAndFoodCell.m
//  Baytie
//
//  Created by stepanekdavid on 9/15/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ParentCityAndFoodCell.h"
#import "SKSTableViewCellIndicator.h"
#define kIndicatorViewTag -1
@implementation ParentCityAndFoodCell
+ (ParentCityAndFoodCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ParentCityAndFoodCell" owner:nil options:nil];
    ParentCityAndFoodCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.expandable = YES;
    self.expanded = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCurWorkoutsItem:(NSString *)cityAndFoodItem
{
    _lblCityName.text = cityAndFoodItem;
    //_curDict = cityAndFoodItem;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(13, 7, 25, 30);
    
    if (self.isExpanded) {
        switch (APPDELEGATE.serviceType) {
            case 1:
                [self.imageView setImage:[UIImage imageNamed:@"small_logo_green.png"]];
                break;
            case 2:
                [self.imageView setImage:[UIImage imageNamed:@"small_logo_orange.png"]];
                break;
            case 3:
                [self.imageView setImage:[UIImage imageNamed:@"small_logo_red.png"]];
                break;
            case 4:
                [self.imageView setImage:[UIImage imageNamed:@"small_logo_blue.png"]];
                break;
                
            default:
                break;
        }
        if (![self containsIndicatorView])
            [self addIndicatorView];
        else {
            [self removeIndicatorView];
            [self addIndicatorView];
        }
    }else{
        [self.imageView setImage:[UIImage imageNamed:@"small_logo_gray.png"]];
    }
}

static UIImage *_image = nil;
- (UIView *)expandableView
{
    if (!_image) {
        _image = [UIImage imageNamed:@"small_logo_gray.png"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(13, 7, 25, 30);
    button.frame = frame;
    
    [button setBackgroundImage:_image forState:UIControlStateNormal];
    
    return button;
}

- (void)setExpandable:(BOOL)isExpandable
{
    if (isExpandable){
        //[self.imageView setImage:[UIImage imageNamed:@"small_logo_gray.png"]];
        //[self.contentView addSubview:[self expandableView]];
    }
    
    _expandable = isExpandable;
}


- (void)addIndicatorView
{
    CGPoint point = self.accessoryView.center;
    CGRect bounds = self.accessoryView.bounds;
    
    CGRect frame = CGRectMake((point.x - CGRectGetWidth(bounds) * 1.5), point.y * 1.4, CGRectGetWidth(bounds) * 3.0, CGRectGetHeight(self.bounds) - point.y * 1.4);
    SKSTableViewCellIndicator *indicatorView = [[SKSTableViewCellIndicator alloc] initWithFrame:frame];
    indicatorView.tag = kIndicatorViewTag;
    [self.contentView addSubview:indicatorView];
}

- (void)removeIndicatorView
{
    id indicatorView = [self.contentView viewWithTag:kIndicatorViewTag];
    if (indicatorView)
    {
        [indicatorView removeFromSuperview];
        indicatorView = nil;
    }
}

- (BOOL)containsIndicatorView
{
    return [self.contentView viewWithTag:kIndicatorViewTag] ? YES : NO;
}

- (void)accessoryViewAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isExpanded) {
            //[_imgCityAndFood setImage:[UIImage imageNamed:@"small_logo_green.png"]];
            self.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
            switch (APPDELEGATE.serviceType) {
                case 1:
                    [self.imageView setImage:[UIImage imageNamed:@"small_logo_green.png"]];
                    break;
                case 2:
                    [self.imageView setImage:[UIImage imageNamed:@"small_logo_orange.png"]];
                    break;
                case 3:
                    [self.imageView setImage:[UIImage imageNamed:@"small_logo_red.png"]];
                    break;
                case 4:
                    [self.imageView setImage:[UIImage imageNamed:@"small_logo_blue.png"]];
                    break;
                    
                default:
                    break;
            }
        } else {
            //[_imgCityAndFood setImage:[UIImage imageNamed:@"small_logo_gray.png"]];
            self.accessoryView.transform = CGAffineTransformMakeRotation(0);
            [self.imageView setImage:[UIImage imageNamed:@"small_logo_gray.png"]];
        }
    } completion:^(BOOL finished) {
        
        if (!self.isExpanded)
            [self removeIndicatorView];
        
    }];
}
@end
