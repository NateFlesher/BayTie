//
//  ChangeMobileNoViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ChangeMobileNoViewController.h"

@interface ChangeMobileNoViewController ()

@end

@implementation ChangeMobileNoViewController

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


- (IBAction)onBackMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onConfirmChangeMobileNo:(id)sender {
    if (!txtOldMobileNo.text.length)
    {
        [self showAlert:@"Please input Old mobile no." :@"Input Error" :nil];
        return;
    }
    if (!txtNewMobileNo.text.length)
    {
        [self showAlert:@"Please input New mobile no." :@"Input Error" :nil];
        return;
    }
    if (!txtReNewMobileNo.text.length)
    {
        [self showAlert:@"Please input Retype New mobile no." :@"Input Error" :nil];
        return;
    }
    if (![txtNewMobileNo.text isEqualToString:txtReNewMobileNo.text]) {
        [self showAlert:@"New mobile no do not match." :@"Input Error" :nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSLog(@"%@", _responseObject);
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
            
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
    [[Communication sharedManager] ChangeMobileNo:APPDELEGATE.access_token oldMobileNo:txtOldMobileNo.text newMobileNo:txtNewMobileNo.text successed:successed failure:failure];
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
    if (textField == txtOldMobileNo) {
        [txtNewMobileNo becomeFirstResponder];
    }else if (textField == txtNewMobileNo){
        [txtReNewMobileNo becomeFirstResponder];
    }else if (textField == txtReNewMobileNo){
        [self.view endEditing:YES];
        [self onConfirmChangeMobileNo:nil];
    }
    return YES;
}
@end
