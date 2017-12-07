//
//  UIImage+Alpha.h
//
//  Created by mobidev on 5/26/14.
//  Copyright (c) 2014 mobidev. All rights reserved.
//

@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
@end
