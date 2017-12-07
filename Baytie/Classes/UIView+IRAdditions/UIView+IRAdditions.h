//
//  UIView+IRAdditions.h
//  Synq
//
//  Created by ccom on 10/26/15.
//  Copyright © 2015 Dan. All rights reserved.
//

@import UIKit;


IB_DESIGNABLE
@interface UIView (IRAdditions)

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, copy) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable NSUInteger borderEdge;
@property (nonatomic) IBInspectable BOOL isRound;


@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGSize shadowOffset;

- (UIView *)superviewWithClass:(Class)superviewClass;

@end
