//
//  LoginViewController.h
//  RouteTrade
//
//  Created by stepanekdavid on 9/3/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <sys/utsname.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    BOOL showKeyboard;
    
    __weak IBOutlet UITextField *txtphoneNum;
    __weak IBOutlet UITextField *txtPassword;
    
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIImageView *bgForLoginImage;
    
    __weak IBOutlet UIView *admobView;
    __weak IBOutlet UIImageView *adsImage1;
    __weak IBOutlet UIImageView *adsImage2;
    __weak IBOutlet UIImageView *adsImage3;
    __weak IBOutlet UIImageView *adsImage4;
}

- (IBAction)onLogin:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onForgotPassword:(id)sender;
- (IBAction)onSignup:(id)sender;

- (IBAction)onSkipAd:(id)sender;
@end
