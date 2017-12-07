//
//  UIView+IRAdditions.m
//  Synq
//
//  Created by ccom on 10/26/15.
//  Copyright © 2015 Dan. All rights reserved.
//

#import "UIView+IRAdditions.h"
//#import "CALayer+RRBorderAdditions.h"


// Workaround for IB not rendering not custom views
@interface UIView_ : UIView @end
@implementation UIView_ @end

@interface UIButton_ : UIButton @end
@implementation UIButton_ @end

@interface UILabel_ : UILabel @end
@implementation UILabel_ @end

@interface UITextView_ : UITextView @end
@implementation UITextView_ @end

@interface UITextField_ : UITextField @end
@implementation UITextField_ @end


@implementation UIView (IRAdditions)


#pragma mark -
#pragma mark UIView (IRAdditions)

- (void)setBorderWidth:(CGFloat)borderWidth {
//    [self.layer setBorderEdgeWidth:borderWidth];
    [self.layer setBorderWidth:borderWidth];
    if( borderWidth && !self.layer.borderColor ){
        [self setBorderColor: [UIColor blackColor]];
    }
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}


- (void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor: borderColor.CGColor];
}


- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius: cornerRadius];
}


- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

/*
- (void)setBorderEdge:(NSUInteger)borderEdge {
    [self.layer setBorderEdge: borderEdge];
    
}


- (NSUInteger)borderEdge {
    return self.layer.borderEdge;
}*/

- (void)setIsRound:(BOOL)isRound {
    if (isRound) {
        self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
        self.layer.masksToBounds = YES;
    }
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (UIView *)superviewWithClass:(Class)superviewClass {
    UIView *view = self;
    while ( (view = view.superview) && ![view isKindOfClass:superviewClass] ) {
        // Find superview
    }
    return view;
}


@end
