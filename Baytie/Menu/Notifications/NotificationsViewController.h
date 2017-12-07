//
//  NotificationsViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    __weak IBOutlet UITableView *notificationTableView;
}

- (IBAction)onBack:(id)sender;
@end
