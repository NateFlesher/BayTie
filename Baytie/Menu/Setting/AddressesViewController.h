//
//  AddressesViewController.h
//  Baytie
//
//  Created by stepanekdavid on 1/8/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    __weak IBOutlet UITableView *AddressesTableView;
}
- (IBAction)onBack:(id)sender;
- (IBAction)onAddAddress:(id)sender;

@end
