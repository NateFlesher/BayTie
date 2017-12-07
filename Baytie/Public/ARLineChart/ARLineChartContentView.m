//
//  SportLineChartContentView.m
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import "ARLineChartContentView.h"
#import "ARLineChartCommon.h"

#define DEFAULT_Y_COUNT 4
#define DEFAULT_X_COUNT 4

typedef enum {
    XViewAll    = 0,
    XViewLast   = 1
}XView;

@interface ARLineChartContentView ()

@property (strong, nonatomic) NSMutableArray *xArray;
@property (strong, nonatomic) NSMutableArray *y1Array;
@property (strong, nonatomic) NSMutableArray *y2Array;

@property (strong, nonatomic) NSArray *dataSource;

@property CGFloat marginLeft;
@property CGFloat marginRight;
@property CGFloat marginBottom;
@property (strong, nonatomic) UIFont *xyTextFont;
@property (strong, nonatomic) UIColor *xyTextColor;
@property CGPoint originPoint;
@property CGPoint leftTopPoint;
@property CGPoint rightBottomPoint;
@property CGFloat xPerStepWidth;
@property CGFloat yPerStepHeight;
@property UIColor *dataLineColor;
@property CGFloat xPerValue;
@property NSInteger currXStepCount;
@property NSInteger currYStepCount;

@property int maxHeight;
@property int maxWidth;
@property CGPoint contentScroll;
@property XView xview;

static bool isLineIntersectRectangle(CGFloat linePointX1,
                                     CGFloat linePointY1,
                                     CGFloat linePointX2,
                                     CGFloat linePointY2,
                                     CGFloat rectangleLeftTopX,
                                     CGFloat rectangleLeftTopY,
                                     CGFloat rectangleRightBottomX,
                                     CGFloat rectangleRightBottomY);
@end


@implementation ARLineChartContentView

- (id)initWithFrame:(CGRect)frame dataSource:(NSArray*)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"_xValue" ascending:YES];
        self.dataSource = [dataSource sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor1, nil]];
        

        //
        [self buildXYSetpArray:DEFAULT_X_COUNT yStepCount:DEFAULT_Y_COUNT];
        self.currXStepCount = DEFAULT_X_COUNT;
        self.currYStepCount = DEFAULT_Y_COUNT;
        
        
        self.xyTextFont = [UIFont systemFontOfSize:8];
        self.xyTextColor = [UIColor lightGrayColor];
        self.dataLineColor = [UIColor lightGrayColor];
        
        
        double xMax =  [[self.xArray objectAtIndex:0] integerValue];
        for (NSNumber *num in self.xArray) {
            if ([num doubleValue] > xMax) {
                xMax = [num doubleValue];
            }
        }
        NSString *xMaxStr = [NSString stringWithFormat:@"%.2lf", xMax];
        
        CGSize size = [xMaxStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.xyTextFont, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
        self.marginBottom = size.height;
        //
        double y1Max =  [[self.y1Array objectAtIndex:0] integerValue];
        for (NSNumber *num in self.y1Array) {
            if ([num doubleValue] > y1Max) {
                y1Max = [num doubleValue];
            }
        }
        NSString *y1MaxStr = [NSString stringWithFormat:@"%.2lf", y1Max];
        size = [y1MaxStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.xyTextFont, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
        self.marginLeft = size.width;
        //
        double y2Max =  [[self.y2Array objectAtIndex:0] integerValue];
        for (NSNumber *num in self.y2Array) {
            if ([num doubleValue] > y2Max) {
                y2Max = [num doubleValue];
            }
        }
        NSString *y2MaxStr = [NSString stringWithFormat:@"%.2lf", y2Max];
        size = [y2MaxStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.xyTextFont, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
        self.marginRight = size.width;
        
        //
        self.originPoint = CGPointMake(self.marginLeft + 2, self.frame.size.height - self.marginBottom - 2);
        self.leftTopPoint = CGPointMake(self.originPoint.x, 0 + 2);
        self.rightBottomPoint = CGPointMake(self.frame.size.width - self.marginRight - 2, self.originPoint.y);
        
        //
        self.xPerStepWidth = (self.rightBottomPoint.x - self.originPoint.x) / (DEFAULT_X_COUNT) - 0.1;
        self.maxWidth = (self.xArray.count - 1) * self.xPerStepWidth;
        
        //
        self.yPerStepHeight = (self.originPoint.y - self.leftTopPoint.y) / (DEFAULT_Y_COUNT) - 0.1;
        //
        NSInteger yStepCount = (self.y1Array.count > self.y2Array.count ? self.y1Array.count : self.y2Array.count);
        self.maxHeight = (yStepCount - 1) * self.yPerStepHeight;
        
        
    }
    return self;
}

- (void)buildXYSetpArray:(NSInteger)xStepCount yStepCount:(NSInteger)yStepCount
{
    if (self.dataSource.count >= 2) {
        float xMin, xMax, y1Min, y1Max, y2Min, y2Max;
        RLLineChartItem *item = [self.dataSource objectAtIndex:0];
        xMin = item.xValue; xMax = item.xValue;
        y1Min = item.y1Value; y1Max = item.y1Value;
        y2Min = item.y2Value; y2Max = item.y2Value;
        
        for (NSInteger i = 1; i < self.dataSource.count; i++) {
            RLLineChartItem *item = [self.dataSource objectAtIndex:i];
            if (item.xValue < xMin)
                xMin = item.xValue;
            else if (item.xValue > xMax)
                xMax = item.xValue;
            
            if (item.y1Value < y1Min)
                y1Min = item.y1Value;
            else if (item.y1Value > y1Max)
                y1Max = item.y1Value;
            
            if (item.y2Value < y2Min)
                y2Min = item.y2Value;
            else if (item.y2Value > y2Max)
                y2Max = item.y2Value;
        }
        
        if (!self.xArray)
            self.xArray = [NSMutableArray array];
        else
            [self.xArray removeAllObjects];
        float xPer = (xMax ) / xStepCount ;
        self.xPerValue = xPer;
        for (int i=0; i<xStepCount; i++) {
            [self.xArray addObject:[NSNumber numberWithFloat: (xPer + i * xPer)]];
        }
        
        if (!self.y1Array)
            self.y1Array = [NSMutableArray array];
        else
            [self.y1Array removeAllObjects];
        float y1Per = (y1Max ) / yStepCount ;
        for (int i=0; i<yStepCount; i++) {
            [self.y1Array addObject:[NSNumber numberWithFloat: (y1Per + i * y1Per)]];
        }
        
        if (!self.y2Array)
            self.y2Array = [NSMutableArray array];
        else
            [self.y2Array removeAllObjects];
        float y2Per = (y2Max ) / yStepCount ;
        for (int i=0; i<yStepCount; i++) {
            [self.y2Array addObject:[NSNumber numberWithFloat: (y2Per + i * y2Per)]];
        }
    }
    else if (self.dataSource.count == 1) {
        RLLineChartItem *item = [self.dataSource objectAtIndex:0];
        
        NSNumber *num1 = [NSNumber numberWithDouble:item.xValue];
        self.xArray = [NSMutableArray arrayWithObject:num1];
        
        NSNumber *num2 = [NSNumber numberWithDouble:item.y1Value];
        self.y1Array = [NSMutableArray arrayWithObject:num2];
        
        NSNumber *num3 = [NSNumber numberWithDouble:item.y2Value];
        self.y2Array = [NSMutableArray arrayWithObject:num3];
    }
    
    
}

- (void)buildXSetpArray:(NSInteger)xStepCount
{
    if (self.dataSource.count >= 2) {
        float xMin, xMax;
        RLLineChartItem *item = [self.dataSource objectAtIndex:0];
        xMin = item.xValue; xMax = item.xValue;
        
        for (NSInteger i = 1; i < self.dataSource.count; i++) {
            RLLineChartItem *item = [self.dataSource objectAtIndex:i];
            if (item.xValue < xMin)
                xMin = item.xValue;
            else if (item.xValue > xMax)
                xMax = item.xValue;
            
        }
        
        
        if (!self.xArray)
            self.xArray = [NSMutableArray array];
        else
            [self.xArray removeAllObjects];
        float xPer = (xMax ) / xStepCount ;
        self.xPerValue = xPer;
        for (int i=0; i<xStepCount; i++) {
            [self.xArray addObject:[NSNumber numberWithFloat: (xPer + i * xPer)]];
        }
    }
    else if (self.dataSource.count == 1) {
        RLLineChartItem *item = [self.dataSource objectAtIndex:0];
        
        NSNumber *num1 = [NSNumber numberWithDouble:item.xValue];
        self.xArray = [NSMutableArray arrayWithObject:num1];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (NSInteger index=0; index < self.xArray.count; index++) {
        
        NSNumber *num = [self.xArray objectAtIndex:index];
        NSString *valStr = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];
        
        float xPosition = self.originPoint.x + (index+1)* self.xPerStepWidth + self.contentScroll.x;
        
        if (xPosition > self.originPoint.x && xPosition < self.rightBottomPoint.x) {
            
            
            [self.xyTextColor set];
            CGSize title1Size = [valStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.xyTextFont, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
            CGRect titleRect1 = CGRectMake(xPosition - (title1Size.width)/2,
                                           self.originPoint.y + 2,
                                           title1Size.width,
                                           title1Size.height);
            [valStr drawInRect:titleRect1 withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.xyTextFont, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
            
            CGFloat dashPattern[]= {6.0, 5};
            CGContextSetLineDash(context, 0.0, dashPattern, 2);
            [ARLineChartCommon drawLine:context
                                startPoint:CGPointMake(xPosition, self.originPoint.y)
                                  endPoint:CGPointMake(xPosition, self.leftTopPoint.y)
                                 lineColor:self.dataLineColor];
        }
    }
    
    for (NSInteger i = 0; i < self.y1Array.count; i++) {
        NSNumber *num = [self.y1Array objectAtIndex:i];
        NSString *valStr = [NSString stringWithFormat:@"%.2lf", [num doubleValue]];
        //        CGSize textSize = [valStr sizeWithFont: self.xyTextFont];
        
        CGFloat y1Position = self.originPoint.y - (i+1) * self.yPerStepHeight + self.contentScroll.y; // - (textSize.height/2);
        
        if (y1Position < self.originPoint.y && y1Position > self.leftTopPoint.y) {
            
            [self.xyTextColor set];
            CGSize title1Size = [valStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.xyTextFont, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
            CGRect titleRect1 = CGRectMake(1,
                                           y1Position - (title1Size.height)/2,
                                           title1Size.width,
                                           title1Size.height);            
            [valStr drawInRect:titleRect1 withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.xyTextFont, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil]];
            CGFloat dashPattern[]= {6.0, 5};
            CGContextSetLineDash(context, 0.0, dashPattern, 2);
            [ARLineChartCommon drawLine:context
                                startPoint:CGPointMake(self.originPoint.x, y1Position)
                                  endPoint:CGPointMake(self.rightBottomPoint.x, y1Position)
                                 lineColor:self.dataLineColor];
        }
    }
    
//    for (NSInteger i = 0; i < self.y2Array.count; i++) {
//        NSNumber *num = [self.y2Array objectAtIndex:i];
//        NSString *valStr = [NSString stringWithFormat:@"%.2lf", [num doubleValue]];
//        //        CGSize textSize = [valStr sizeWithFont: self.xyTextFont];
//        
//        CGFloat y2Position = self.originPoint.y - (i+1) * self.yPerStepHeight + self.contentScroll.y; // - (textSize.height/2);
//        
//        if (y2Position < self.originPoint.y && y2Position > self.leftTopPoint.y) {
//            
//            [line2Color set];
//            CGSize title1Size = [valStr sizeWithFont:self.xyTextFont];
//            CGRect titleRect1 = CGRectMake(self.rightBottomPoint.x + 1,
//                                           y2Position - (title1Size.height)/2,
//                                           title1Size.width,
//                                           title1Size.height);
//            [valStr drawInRect:titleRect1 withFont:self.xyTextFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
//            
//            
//            CGFloat dashPattern[]= {6.0, 5};
//            CGContextSetLineDash(context, 0.0, dashPattern, 2);
//            [ARLineChartCommon drawLine:context
//                                startPoint:CGPointMake(self.originPoint.x, y2Position)
//                                  endPoint:CGPointMake(self.rightBottomPoint.x, y2Position)
//                                 lineColor:self.dataLineColor];
//        }
//    }
    
    if (self.dataSource && self.dataSource.count > 0) {
        
        for (NSInteger i = 0; i < self.dataSource.count-1; i++) {
            RLLineChartItem *item = (RLLineChartItem*)[self.dataSource objectAtIndex:i];
            RLLineChartItem *item2 = (RLLineChartItem*)[self.dataSource objectAtIndex:i+1];
            
            float xPerStepVal = [(NSNumber*)[self.xArray objectAtIndex:0] floatValue];
            //        if (xPerStepVal == 0) xPerStepVal = [(NSNumber*)[self.xArray objectAtIndex:1] floatValue];
            float xPosition = self.originPoint.x + ((self.xPerStepWidth * item.xValue) / xPerStepVal) + self.contentScroll.x;
            float xPosition2 = self.originPoint.x + ((self.xPerStepWidth * item2.xValue) / xPerStepVal) + self.contentScroll.x;
            
            float y1PerStepVal = [(NSNumber*)[self.y1Array objectAtIndex:0] floatValue];
            //        if (y1PerStepVal == 0) y1PerStepVal = [(NSNumber*)[self.y1Array objectAtIndex:1] floatValue];
            float y1Position = self.originPoint.y - fabs(((self.yPerStepHeight * item.y1Value) / y1PerStepVal )) + self.contentScroll.y;
            float y1Position2 = self.originPoint.y - fabs(((self.yPerStepHeight * item2.y1Value) / y1PerStepVal )) + self.contentScroll.y;
            
            float y2PerStepVal = [(NSNumber*)[self.y2Array objectAtIndex:0] floatValue];
            //        if (y2PerStepVal == 0) y2PerStepVal = [(NSNumber*)[self.y2Array objectAtIndex:1] floatValue];
            float y2Position = self.originPoint.y - fabs(((self.yPerStepHeight * item.y2Value) / y2PerStepVal )) + self.contentScroll.y;
            float y2Position2 = self.originPoint.y - fabs(((self.yPerStepHeight * item2.y2Value) / y2PerStepVal )) + self.contentScroll.y;
            
            CGPoint startPoint = CGPointMake(xPosition, y1Position);
            CGPoint endPoint = CGPointMake(xPosition2, y1Position2);
            //        graphPoints1[i] = startPoint;
            
            CGPoint startPoint2 = CGPointMake(xPosition, y2Position);
            CGPoint endPoint2 = CGPointMake(xPosition2, y2Position2);
            
            CGFloat normal[1]={1};
            CGContextSetLineDash(context,0,normal,0);
            
            
            if ( isLineIntersectRectangle(xPosition, y1Position, xPosition2, y1Position2, _leftTopPoint.x, _leftTopPoint.y, _rightBottomPoint.x, _rightBottomPoint.y) )
            {
                [ARLineChartCommon drawLine:context startPoint:startPoint endPoint:endPoint lineColor:line1Color];
            }
            
            if ( isLineIntersectRectangle(xPosition, y2Position, xPosition2, y2Position2, _leftTopPoint.x, _leftTopPoint.y, _rightBottomPoint.x, _rightBottomPoint.y) )
            {
                [ARLineChartCommon drawLine:context startPoint:startPoint2 endPoint:endPoint2 lineColor:line2Color];
            }
            
            
        }
    }
    
    CGFloat normal[1]={1};
    CGContextSetLineDash(context,0,normal,0);
    [ARLineChartCommon drawLine:context
                        startPoint:self.originPoint
                          endPoint:self.leftTopPoint
                         lineColor:self.dataLineColor];
    
    [ARLineChartCommon drawLine:context
                        startPoint:self.rightBottomPoint
                          endPoint:CGPointMake(self.rightBottomPoint.x, self.leftTopPoint.y)
                         lineColor:self.dataLineColor];
    
    [ARLineChartCommon drawLine:context
                        startPoint:CGPointMake(self.originPoint.x, self.originPoint.y)
                          endPoint:CGPointMake(self.rightBottomPoint.x, self.rightBottomPoint.y)
                         lineColor:self.dataLineColor];
    
    
}

//static CGPoint s_p1;
//static CGPoint s_p2;
//CGFloat s_xDistance;
//CGFloat s_yDistance;

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //    NSArray * touchesArr=[[event allTouches] allObjects];
//    //    if (touchesArr.count == 2) {
//    //
//    ////        s_p1 = [[touchesArr objectAtIndex:0] locationInView:self];
//    ////        s_p2 =[[touchesArr objectAtIndex:1] locationInView:self];
//    //        CGPoint p1 =[[touchesArr objectAtIndex:0] locationInView:self];
//    //        CGPoint p2 =[[touchesArr objectAtIndex:1] locationInView:self];
//    //
//    //        //        CGFloat xDiff = fabs(p1.x-s_p1.x) + fabs(p2.x-s_p2.x);
//    //        //        CGFloat yDiff = fabs(p1.y-s_p1.y) + fabs(p2.y-s_p2.y);
//    //        s_xDistance = fabs(p2.x - p1.x);
//    //        s_yDistance = fabs(p2.y - p1.y);
//    //        NSLog(@"touchesBegan xDistance：%f",s_xDistance);
//    //        NSLog(@"touchesBegan yDistance：%f",s_yDistance);
//    //
//    //    }
//}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    
//    NSArray * touchesArr=[[event allTouches] allObjects];
//    if (touchesArr.count == 1) {
//        
//        CGPoint touchLocation=[[touches anyObject] locationInView:self];
//        CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
//        float xDiffrance=touchLocation.x-prevouseLocation.x;
//        float yDiffrance=touchLocation.y-prevouseLocation.y;
//        
//        _contentScroll.x+=xDiffrance;
//        _contentScroll.y+=yDiffrance;
//        
//        if (_contentScroll.x >0) {
//            _contentScroll.x=0;
//        }
//        if(_contentScroll.y<0)
//        {
//            _contentScroll.y=0;
//        }
//        
//        if (-_contentScroll.x>self.maxWidth) {
//            _contentScroll.x=-self.maxWidth;
//        }
//        if (_contentScroll.y>self.maxHeight) {
//            _contentScroll.y=self.maxHeight;
//        }
//        
//        [self setNeedsDisplay];
//    }
//    
//    
//    
//    
//}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSArray * touchesArr=[[event allTouches] allObjects];
//    if (touchesArr.count == 1) {
//        
//        UITouch *touch = [touches anyObject];
//        if (touch.tapCount == 2) {
//            NSLog(@"双击了");
//            if (self.xview == XViewLast) {
//                [self zoomLastX];
//                self.xview = XViewAll;
//            }
//            else {
//                [self zoomOriginal];
//                self.xview = XViewLast;
//            }
//        }
//    }
//    
//}


static bool isLineIntersectRectangle(CGFloat linePointX1,
                                     CGFloat linePointY1,
                                     CGFloat linePointX2,
                                     CGFloat linePointY2,
                                     CGFloat rectangleLeftTopX,
                                     CGFloat rectangleLeftTopY,
                                     CGFloat rectangleRightBottomX,
                                     CGFloat rectangleRightBottomY)
{
    CGFloat  lineHeight = linePointY1 - linePointY2;
    CGFloat lineWidth = linePointX2 - linePointX1;
    CGFloat c = linePointX1 * linePointY2 - linePointX2 * linePointY1;
    if ((lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c <= 0)
        || (lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c >= 0)
        || (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c <= 0)
        || (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c >= 0))
    {
        
        if (rectangleLeftTopX > rectangleRightBottomX) {
            CGFloat temp = rectangleLeftTopX;
            rectangleLeftTopX = rectangleRightBottomX;
            rectangleRightBottomX = temp;
        }
        if (rectangleLeftTopY < rectangleRightBottomY) {
            CGFloat temp1 = rectangleLeftTopY;
            rectangleLeftTopY = rectangleRightBottomY;
            rectangleRightBottomY = temp1;   }
        if ((linePointX1 < rectangleLeftTopX && linePointX2 < rectangleLeftTopX)
            || (linePointX1 > rectangleRightBottomX && linePointX2 > rectangleRightBottomX)
            || (linePointY1 > rectangleLeftTopY && linePointY2 > rectangleLeftTopY)
            || (linePointY1 < rectangleRightBottomY && linePointY2 < rectangleRightBottomY)) {
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}


- (void)zoomUp
{
    self.currXStepCount++;
    self.currYStepCount++;
    
    [self buildXYSetpArray:self.currXStepCount yStepCount:self.currYStepCount];
    
    //    self.xPerStepWidth = (self.rightBottomPoint.x - self.originPoint.x) / (self.currXStepCount) - 0.1;
    self.maxWidth = (self.xArray.count - 1) * self.xPerStepWidth;
    //
    //    self.yPerStepHeight = (self.originPoint.y - self.leftTopPoint.y) / (self.currYStepCount) - 0.1;
    
    NSInteger yStepCount = (self.y1Array.count > self.y2Array.count ? self.y1Array.count : self.y2Array.count);
    self.maxHeight = (yStepCount - 1) * self.yPerStepHeight;
    
    
    [self setNeedsDisplay];
}

- (void)zoomDown
{
    self.currXStepCount--;
    if (self.currXStepCount < DEFAULT_X_COUNT) self.currXStepCount = DEFAULT_X_COUNT;
    
    self.currYStepCount--;
    if (self.currYStepCount < DEFAULT_Y_COUNT) self.currYStepCount = DEFAULT_Y_COUNT;
    
    
    [self buildXYSetpArray:self.currXStepCount yStepCount:self.currYStepCount];
    
    
    //    self.xPerStepWidth = (self.rightBottomPoint.x - self.originPoint.x) / (self.currXStepCount) - 0.1;
    self.maxWidth = (self.xArray.count - 1) * self.xPerStepWidth;
    //
    
    //    self.yPerStepHeight = (self.originPoint.y - self.leftTopPoint.y) / (self.currYStepCount) - 0.1;
    
    NSInteger yStepCount = (self.y1Array.count > self.y2Array.count ? self.y1Array.count : self.y2Array.count);
    self.maxHeight = (yStepCount - 1) * self.yPerStepHeight;
    
    
    [self setNeedsDisplay];
}

- (void)zoomOriginal
{
    self.currXStepCount = DEFAULT_X_COUNT;
    self.currYStepCount = DEFAULT_Y_COUNT;
    _contentScroll.x=0;
    _contentScroll.y=0;
    
    
    [self buildXYSetpArray:self.currXStepCount yStepCount:self.currYStepCount];
    
    
    self.xPerStepWidth = (self.rightBottomPoint.x - self.originPoint.x) / (DEFAULT_X_COUNT) - 0.1;
    self.maxWidth = (self.xArray.count - 1) * self.xPerStepWidth;
    
    
    //    self.yPerStepHeight = (self.originPoint.y - self.leftTopPoint.y) / (DEFAULT_Y_COUNT) - 0.1;
    
    NSInteger yStepCount = (self.y1Array.count > self.y2Array.count ? self.y1Array.count : self.y2Array.count);
    self.maxHeight = (yStepCount - 1) * self.yPerStepHeight;
    
    
    [self setNeedsDisplay];
}

- (void)zoomLastX
{
    
    self.currXStepCount = self.dataSource.count;
    
    
    [self buildXSetpArray:self.currXStepCount];
    
    //
    self.maxWidth = (self.xArray.count -1 ) * self.xPerStepWidth;
    //
    _contentScroll.x=-self.maxWidth + (self.xPerStepWidth * 3);
    
    
   
    [self setNeedsDisplay];

}


- (void)zoomHorizontalUp
{
    
    self.currXStepCount++;
    
    
    [self buildXYSetpArray:self.currXStepCount yStepCount:self.currYStepCount];
    
    //
    //    self.xPerStepWidth = (self.rightBottomPoint.x - self.originPoint.x) / (self.currXStepCount) - 0.1;
    self.maxWidth = (self.xArray.count - 1) * self.xPerStepWidth;
    
    
    [self setNeedsDisplay];
    
}

- (void)zoomHorizontalDown
{
    
    self.currXStepCount--;
    if (self.currXStepCount < DEFAULT_X_COUNT) self.currXStepCount = DEFAULT_X_COUNT;
    
    
    [self buildXYSetpArray:self.currXStepCount yStepCount:self.currYStepCount];
    
    //
    //    self.xPerStepWidth = (self.rightBottomPoint.x - self.originPoint.x) / (self.currXStepCount) - 0.1;
    self.maxWidth = (self.xArray.count - 1) * self.xPerStepWidth;
    //
//    _contentScroll.x=-self.maxWidth + (self.xPerStepWidth * 3);
    
    
    [self setNeedsDisplay];
}


- (void)zoomVerticalUp
{
   
    self.currYStepCount++;
    
    [self buildXYSetpArray:self.currXStepCount yStepCount:self.currYStepCount];
    
    //    self.yPerStepHeight = (self.originPoint.y - self.leftTopPoint.y) / (self.currYStepCount) - 0.1;
    
    NSInteger yStepCount = (self.y1Array.count > self.y2Array.count ? self.y1Array.count : self.y2Array.count);
    self.maxHeight = (yStepCount - 1) * self.yPerStepHeight;
    
    
    [self setNeedsDisplay];
}

- (void)zoomVerticalDown
{
    
    self.currYStepCount--;
    if (self.currYStepCount < DEFAULT_Y_COUNT) self.currYStepCount = DEFAULT_Y_COUNT;
    
    
    [self buildXYSetpArray:self.currXStepCount yStepCount:self.currYStepCount];
    
    
    //    self.yPerStepHeight = (self.originPoint.y - self.leftTopPoint.y) / (self.currYStepCount) - 0.1;
    
    NSInteger yStepCount = (self.y1Array.count > self.y2Array.count ? self.y1Array.count : self.y2Array.count);
    self.maxHeight = (yStepCount - 1) * self.yPerStepHeight;
    //
//    _contentScroll.y = self.maxHeight + (self.yPerStepHeight * 3);
    
    
    [self setNeedsDisplay];
}


- (void)refreshData:(NSArray*)dataSource
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"_xValue" ascending:YES];
        self.dataSource = [dataSource sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor1, nil]];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.xview == XViewLast) {
                [self zoomLastX];
            }
            else {
                [self zoomOriginal];
            }
        });
     });
    
    
}

@end
