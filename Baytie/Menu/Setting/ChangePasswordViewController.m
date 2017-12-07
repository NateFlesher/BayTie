//
//  ChangePasswordViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onConfirm:(id)sender {
    if (!txtOldPassword.text.length)
    {
        [self showAlert:@"Please input Old Password." :@"Input Error" :nil];
        return;
    }
    if (!txtNewPassword.text.length)
    {
        [self showAlert:@"Please input New Passowrd." :@"Input Error" :nil];
        return;
    }
    if (!txtRePassword.text.length)
    {
        [self showAlert:@"Please input Retype New Password." :@"Input Error" :nil];
        return;
    }
    if (![txtNewPassword.text isEqualToString:txtRePassword.text]) {
        [self showAlert:@"Password do not match." :@"Input Error" :nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSLog(@"%@", _responseObject);
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error" :nil];
        }else{
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!" :nil] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
        
    };
    [[Communication sharedManager] ChangePassword:APPDELEGATE.access_token oldPassword:txtOldPassword.text newPassword:txtNewPassword.text successed:successed failure:failure];
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
-(void)handleTap
{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtOldPassword) {
        [txtNewPassword becomeFirstResponder];
    }else if (textField == txtNewPassword){
        [txtRePassword becomeFirstResponder];
    }else if (textField == txtRePassword){
        [self.view endEditing:YES];
        [self onConfirm:nil];
    }
    return YES;
}
@end
