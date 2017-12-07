//
//  ForgotPWViewController.h
//  RouteTrade
//
//  Created by stepanekdavid on 9/4/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPWViewController : UIViewController<UITextFieldDelegate>{

    __weak IBOutlet UITextField *txtEmailOrPhoneNumForgot;
}

- (IBAction)onBackScreen:(id)sender;
- (IBAction)onSend:(id)sender;

@end
