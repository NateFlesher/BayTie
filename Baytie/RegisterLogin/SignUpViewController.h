//
//  SignUpViewController.h
//  RouteTrade
//
//  Created by stepanekdavid on 9/4/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>{

    BOOL showKeyboard;
    __weak IBOutlet UIScrollView *srcView;
    
    __weak IBOutlet UITextField *txtFirstName;
    __weak IBOutlet UITextField *txtLastName;
    __weak IBOutlet UITextField *txtPhoneNum;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UITextField *txtConfirmPassword;
    __weak IBOutlet UITextField *txtEmail;
    
    __weak IBOutlet UIButton *btnSubmit;
    
    
    __weak IBOutlet UIView *insertCodeView;
    __weak IBOutlet UITextField *txtCode;
    
}
- (IBAction)onSignup:(id)sender;
- (IBAction)onBackScreen:(id)sender;


- (IBAction)onCloseInsertView:(id)sender;
- (IBAction)onConfirmCode:(id)sender;
@end
