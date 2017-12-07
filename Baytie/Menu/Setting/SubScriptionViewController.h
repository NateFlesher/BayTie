//
//  SubScriptionViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubScriptionViewController : UIViewController{
    
    __weak IBOutlet UIButton *btnNotification;
    __weak IBOutlet UIButton *btnSMS;
    __weak IBOutlet UIButton *btnEmail;
}

- (IBAction)onBackmenu:(id)sender;
- (IBAction)onSave:(id)sender;

- (IBAction)onBtnNotification:(id)sender;
- (IBAction)onBtnSMS:(id)sender;
- (IBAction)onBtnEmail:(id)sender;
@end
