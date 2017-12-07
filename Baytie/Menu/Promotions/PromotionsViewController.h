//
//  PromotionsViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    __weak IBOutlet UITableView *promotionsTableView;
    __weak IBOutlet UIView *areaSelectedView;
    __weak IBOutlet UITableView *areaTableView;
}

- (IBAction)onBack:(id)sender;
@end
