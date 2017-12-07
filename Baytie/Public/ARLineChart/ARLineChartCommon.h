//
//  SportLineChartUtilty.h
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define line1Color  [UIColor colorWithRed:(float)50/255 green:(float)102/255 blue:(float)204/255 alpha:1.0]
#define line2Color  [UIColor colorWithRed:(float)176/255 green:(float)29/255 blue:(float)45/255 alpha:1.0]
#define xylineColor  [UIColor blackColor]


@interface ARLineChartCommon : NSObject

+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color;
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor;
+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;
+ (void)drawText2:(CGContextRef)context text:(NSString*)text color:(UIColor *)color fontSize:(CGFloat)fontSize;


@end


@interface RLLineChartItem : NSObject

@property double xValue;
@property double y1Value;
@property double y2Value;

@end