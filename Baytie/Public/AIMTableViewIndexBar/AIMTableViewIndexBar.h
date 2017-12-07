//
//  AIMTableViewIndexBar.h
//  ChatAndMapSample
//
//  Created by stepanekdavid on 2/13/16.
//  Copyright © 2016 stepanekdavid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AIMTableViewIndexBar;

@protocol AIMTableViewIndexBarDelegate <NSObject>

- (void)tableViewIndexBar:(AIMTableViewIndexBar*)indexBar didSelectSectionAtIndex:(NSInteger)index;

@end

@interface AIMTableViewIndexBar : UIView

@property (nonatomic, strong) NSArray *indexes;
@property (nonatomic, weak) id <AIMTableViewIndexBarDelegate> delegate;

@end