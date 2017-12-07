//
//  ChangePasswordViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *txtOldPassword;
    __weak IBOutlet UITextField *txtNewPassword;
    __weak IBOutlet UITextField *txtRePassword;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onConfirm:(id)sender;
@end
