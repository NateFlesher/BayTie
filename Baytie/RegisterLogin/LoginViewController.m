//
//  LoginViewController.m
//  RouteTrade
//
//  Created by stepanekdavid on 9/3/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPWViewController.h"
#import "SignUpViewController.h"
//#import "HomeViewController.h"
#import "Communication.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#import "UIImageView+AFNetworking.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getAds];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrView.hidden = YES;
    bgForLoginImage.hidden = YES;
    
    //[self performSelector:@selector(setupUI) withObject:nil afterDelay:5.0f];
    
    
    //[self.navigationController.navigationBar setTranslucent:YES];
    showKeyboard = NO;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [scrView addGestureRecognizer:gesture];
    
    
}
- (void)getAds{
    [[Communication sharedManager] GetAdvertisements:@"" kind:0 page:0 successed:^(id _responseObject) {
        if ([_responseObject[@"code"] integerValue] == 0) {
            int i = 0;
            for (NSDictionary *dict in _responseObject[@"resource"]) {
                if ([dict objectForKey:@"image"] && ![[dict objectForKey:@"image"] isKindOfClass:[NSNull class]]) {
                    NSArray *arrForUrl = [[dict objectForKey:@"image"] componentsSeparatedByString:@"/"];
                    if ([arrForUrl count] > 2) {
                        i  ++;
                        NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
                        switch (i) {
                            case 1:
                                [adsImage1 setImageWithURL:[NSURL URLWithString:logoUrl]];
                                break;
                            case 2:
                                [adsImage2 setImageWithURL:[NSURL URLWithString:logoUrl]];
                                break;
                            case 3:
                                [adsImage3 setImageWithURL:[NSURL URLWithString:logoUrl]];
                                break;
                            case 4:
                                [adsImage4 setImageWithURL:[NSURL URLWithString:logoUrl]];
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
            }
        }
    } failure:^(NSError *_error) {
        
    }];
}
-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        showKeyboard = NO;
    }
}

- (void)setupUI{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSLog(@"Access token : %@", access_token);
    if (access_token) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        [[Communication sharedManager] CheckSession:access_token successed:^(id _responseObject) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            if ([_responseObject[@"code"] integerValue] == 0) {
                [[AppDelegate sharedDelegate] loadLoginData];
                [[AppDelegate sharedDelegate] goToMainView];
                [self registerDevice];
            } else {
                [[AppDelegate sharedDelegate] deleteLoginData];
                scrView.hidden = NO;
                bgForLoginImage.hidden = NO;
            }
        } failure:^(NSError *_error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [[AppDelegate sharedDelegate] deleteLoginData];
            scrView.hidden = NO;
            bgForLoginImage.hidden = NO;
        }];
    } else {
        scrView.hidden = NO;
        bgForLoginImage.hidden = NO;
    }
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
        [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f)];
        //        if (IS_IPHONE_5) {
        //            [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
        //        } else [srcView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtphoneNum)
    {
        [txtPassword becomeFirstResponder];
    } else {
        [self onLogin:nil];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtphoneNum)
    {
        [scrView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    else if (textField == txtPassword)
    {
        [scrView setContentOffset:CGPointMake(0, 90) animated:YES];
    }
    return YES;
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onLogin:(id)sender {
    if (!txtphoneNum.text.length)
    {
        [self showAlert:@"Please input Mobile Number" :@"Input Error"];
        return;
    }
    if (!txtPassword.text.length)
    {
        [self showAlert:@"Please input Password" :@"Input Error"];
        return;
    }
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            
            [AppDelegate sharedDelegate].access_token = [[_responseObject objectForKey:@"resource"] objectForKey:@"access_token"];
            [AppDelegate sharedDelegate].userid = [[_responseObject objectForKey:@"resource"] objectForKey:@"user_id"];
            [[Communication sharedManager] GetUserInfos:[AppDelegate sharedDelegate].userid successed:^(id _responseObject) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                if ([_responseObject[@"code"] integerValue] == 0) {
                    [AppDelegate sharedDelegate].firstName = [[[_responseObject objectForKey:@"resource"] objectForKey:@"profile"] objectForKey:@"f_name"];
                    [AppDelegate sharedDelegate].lastName = [[[_responseObject objectForKey:@"resource"] objectForKey:@"profile"] objectForKey:@"l_name"];
                    [AppDelegate sharedDelegate].emailAddress = [[_responseObject objectForKey:@"resource"] objectForKey:@"email"];
                    [AppDelegate sharedDelegate].mobilePhoneNum = [[_responseObject objectForKey:@"resource"] objectForKey:@"mobile_no"];
                    [AppDelegate sharedDelegate].profileUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@", [[[_responseObject objectForKey:@"resource"] objectForKey:@"profile"] objectForKey:@"image"]];
                    if ([[[_responseObject objectForKey:@"resource"] objectForKey:@"profile"] objectForKey:@"language"] && ![[[[_responseObject objectForKey:@"resource"] objectForKey:@"profile"] objectForKey:@"language"] isKindOfClass:[NSNull class]]) {
                        [AppDelegate sharedDelegate].language = [[[_responseObject objectForKey:@"resource"] objectForKey:@"profile"] objectForKey:@"language"];
                    }else{
                        [AppDelegate sharedDelegate].language = @"eng";
                    }
                    
                    [self registerDevice];
                    [[AppDelegate sharedDelegate] saveLoginData];
                    [[AppDelegate sharedDelegate] goToMainView];
                }else if ([[_responseObject objectForKey:@"code"] integerValue] == 4001) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self showAlert:_responseObject[@"message"] :@"Login Error"];
                }else{
                    [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
                    [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
                }
            } failure:^(NSError *_error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
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
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    if (![AppDelegate sharedDelegate].strDeviceToken)
    {
        [AppDelegate sharedDelegate].strDeviceToken = @"Simulator Test";
    }
    
    NSString * Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[Communication sharedManager] UserLogin:txtphoneNum.text driverPwd:txtPassword.text deviceID:[AppDelegate sharedDelegate].strDeviceToken deviceType:Identifier successed:successed failure:failure];
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onForgotPassword:(id)sender {
    [self.view endEditing:YES];
    ForgotPWViewController *viewcontroller = [[ForgotPWViewController alloc] initWithNibName:@"ForgotPWViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onSignup:(id)sender {
    SignUpViewController *viewcontroller = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onSkipAd:(id)sender {
    [self setupUI];
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
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
        }else if ([[_responseObject objectForKey:@"code"] integerValue] == 4001) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }else{
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
@end
