//
//  UIImage+RoundedCorner.h
//
//  Created by mobidev on 5/26/14.
//  Copyright (c) 2014 mobidev. All rights reserved.
//

// Extends the UIImage class to support making rounded corners
@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
@end
