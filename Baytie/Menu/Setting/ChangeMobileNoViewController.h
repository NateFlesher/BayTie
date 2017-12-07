//
//  ChangeMobileNoViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeMobileNoViewController : UIViewController<UITextFieldDelegate>{

    __weak IBOutlet UITextField *txtOldMobileNo;
    __weak IBOutlet UITextField *txtNewMobileNo;
    __weak IBOutlet UITextField *txtReNewMobileNo;
    
}

- (IBAction)onBackMenu:(id)sender;
- (IBAction)onConfirmChangeMobileNo:(id)sender;
@end
