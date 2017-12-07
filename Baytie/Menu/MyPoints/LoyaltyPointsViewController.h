//
//  LoyaltyPointsViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoyaltyPointsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    __weak IBOutlet UITableView *loyaltyPointsTableView;
}

- (IBAction)onBackMenu:(id)sender;
@end
