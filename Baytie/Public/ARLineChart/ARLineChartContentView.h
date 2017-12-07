//
//  SportLineChartContentView.h
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLineChartView.h"

@interface ARLineChartContentView : UIView

- (id)initWithFrame:(CGRect)frame dataSource:(NSArray*)dataSource;


- (void)zoomUp;

- (void)zoomDown;

- (void)zoomOriginal;


- (void)zoomHorizontalUp;

- (void)zoomHorizontalDown;


- (void)zoomVerticalUp;

- (void)zoomVerticalDown;


- (void)refreshData:(NSArray*)dataSource;

@end
