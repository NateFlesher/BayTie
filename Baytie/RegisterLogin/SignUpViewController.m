//
//  SignUpViewController.m
//  RouteTrade
//
//  Created by stepanekdavid on 9/4/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import "SignUpViewController.h"
#import "Communication.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    showKeyboard = NO;
    insertCodeView.hidden = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [srcView addGestureRecognizer:gesture];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (!showKeyboard)
    {
        showKeyboard = YES;
        [srcView setContentSize:CGSizeMake(320, srcView.frame.size.height + 236.0f)];
//        if (IS_IPHONE_5) {
//            [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
//        } else [srcView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [srcView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [srcView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtPhoneNum)
    {
        [txtFirstName becomeFirstResponder];
        [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    else if (textField == txtFirstName)
    {
        [txtLastName becomeFirstResponder];
        [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
    }else if (textField == txtLastName)
    {
        [txtPassword becomeFirstResponder];
        [srcView setContentOffset:CGPointMake(0, 80) animated:YES];
    }else if (textField == txtPassword)
    {
        [txtConfirmPassword becomeFirstResponder];
        [srcView setContentOffset:CGPointMake(0, 80) animated:YES];
    }else if (textField == txtConfirmPassword)
    {
        [txtEmail becomeFirstResponder];
        [srcView setContentOffset:CGPointMake(0, 180) animated:YES];
    }else if (textField == txtEmail)
    {
        [self onSignup:nil];
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtPhoneNum)
    {
        [srcView setContentOffset:CGPointMake(0, 20) animated:YES];
    }
    else if (textField == txtFirstName)
    {
        [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
    }else if (textField == txtLastName)
    {
        [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
    }else if (textField == txtPassword)
    {
        [srcView setContentOffset:CGPointMake(0, 80) animated:YES];
    }else if (textField == txtConfirmPassword)
    {
        [srcView setContentOffset:CGPointMake(0, 80) animated:YES];
    }else if (textField == txtEmail)
    {
        [srcView setContentOffset:CGPointMake(0, 180) animated:YES];
    }
    return YES;
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (BOOL)checkEmail:(UITextField *)checkText
{
    BOOL filter = YES ;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if([emailTest evaluateWithObject:checkText.text] == NO)
    {
        [self showAlert:@"Please enter a valid email address." :@"Error" :nil];
        return NO ;
    }
    
    return YES ;
}
- (IBAction)onSignup:(id)sender {
    if (!txtFirstName.text.length)
    {
        [self showAlert:@"Please input Fist Name" :@"Input Error" :nil];
        return;
    }
    if (!txtLastName.text.length)
    {
        [self showAlert:@"Please input Last Name" :@"Input Error" :nil];
        return;
    }
    if (!txtPhoneNum.text.length)
    {
        [self showAlert:@"Please input Mibile Number" :@"Input Error" :nil];
        return;
    }
    if (!txtPassword.text.length)
    {
        [self showAlert:@"Please input Password" :@"Input Error" :nil];
        return;
    }
    if (![txtPassword.text isEqualToString:txtConfirmPassword.text]) {
        [self showAlert:@"Password do not match!" :@"Input Error" :nil];
        return;
    }
    if (!txtEmail.text.length)
    {
        [self showAlert:@"Please input Email address" :@"Input Error" :nil];
        return;
    }
    if ([txtEmail.text rangeOfString:@" "].length != 0) {
        [self showAlert:@"Email field contains space. Please input again" :@"Input Error" :nil];
        return;
    }
    if (![self checkEmail:txtEmail]) {
        return;
    }
    [self.view endEditing:YES];
    
    NSDate *currentime = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *userID = [dateformatter stringFromDate:currentime];
    
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSLog(@"%@", _responseObject);
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            //insertCodeView.hidden = NO;
            [AppDelegate sharedDelegate].userid = [[_responseObject objectForKey:@"resource"] objectForKey:@"user_id"];
            APPDELEGATE.access_token = [[_responseObject objectForKey:@"resource"] objectForKey:@"access_token"];
            [AppDelegate sharedDelegate].firstName = txtFirstName.text;
            [AppDelegate sharedDelegate].lastName = txtLastName.text;
            [AppDelegate sharedDelegate].emailAddress = txtEmail.text;
            [AppDelegate sharedDelegate].mobilePhoneNum = txtPhoneNum.text;
            [AppDelegate sharedDelegate].language = @"eng";
            [self sendSMSForVeryfy];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }else{
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
    
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
    
    };
    
    if (![AppDelegate sharedDelegate].strDeviceToken)
    {
        [AppDelegate sharedDelegate].strDeviceToken = @"Simulator Test";
    }
    
    NSString * Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[Communication sharedManager] SignUP:txtPhoneNum.text firstName:txtFirstName.text lastName:txtLastName.text userPassword:txtPassword.text userEmail:txtEmail.text deviceID:[AppDelegate sharedDelegate].strDeviceToken deviceType:Identifier successed:successed failure:failure];
    
}

- (void) registerDevice
{
    NSString *device_token = @"";
    if ([AppDelegate sharedDelegate].strDeviceToken) {
        device_token = [AppDelegate sharedDelegate].strDeviceToken;
    }else{
        device_token = @"111111111111111111";
    }
    
    [[Communication sharedManager] registerDevice:[AppDelegate sharedDelegate].access_token deviceid:device_token devicetype:@"ios" devicetoken:device_token successed:^(id _responseObject)
     {
         if ([_responseObject[@"code"] integerValue] == 0) {
             
         }else if ([[_responseObject objectForKey:@"code"] integerValue] == 4001) {
             [self showAlert:_responseObject[@"message"] :@"Error"];
         }else{
             [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
         }
     } failure:^(NSError *_error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}

- (void)sendSMSForVeryfy{
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            insertCodeView.hidden = NO;
            NSLog(@"Mataam sent the code successfully!");
        }else if ([[_responseObject objectForKey:@"code"] integerValue] == 21211) {
            insertCodeView.hidden = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }else{
            insertCodeView.hidden = YES;
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        insertCodeView.hidden = YES;
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
        
    };
    [[Communication sharedManager] SendSMScode:APPDELEGATE.access_token mobileNum:APPDELEGATE.mobilePhoneNum successed:successed failure:failure];
}
- (void)verifySMScode{
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            [self verifySMScode];
        }else if ([[_responseObject objectForKey:@"code"] integerValue] == 4001) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }else{
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
        
    };
    [[Communication sharedManager] VerifySMScode:APPDELEGATE.userid mobileNum:APPDELEGATE.mobilePhoneNum code:txtCode.text successed:successed failure:failure];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onBackScreen:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCloseInsertView:(id)sender {
    insertCodeView.hidden = YES;
}

- (IBAction)onConfirmCode:(id)sender {
    if (!txtCode.text.length)
    {
        [self showAlert:@"Please input code" :@"Input Error" :nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            insertCodeView.hidden = YES;
            
            [[AppDelegate sharedDelegate] saveLoginData];
            [[AppDelegate sharedDelegate] goToMainView];
            [self registerDevice];
        }else if ([[_responseObject objectForKey:@"code"] integerValue] == 4001) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }else{
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {        
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
        
    };
    [[Communication sharedManager] VerifySMScode:APPDELEGATE.access_token mobileNum:APPDELEGATE.mobilePhoneNum code:txtCode.text successed:successed failure:failure];
}
@end
