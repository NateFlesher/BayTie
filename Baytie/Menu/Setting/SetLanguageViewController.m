//
//  SetLanguageViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/16/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SetLanguageViewController.h"

@interface SetLanguageViewController (){
    
}

@end

@implementation SetLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([APPDELEGATE.language isEqualToString:@"eng"]) {
        btnCheckEngLag.selected = YES;
        btnCheckAraLag.selected = NO;
    }else{
        btnCheckAraLag.selected = YES;
        btnCheckEngLag.selected = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAraLag:(id)sender {
    btnCheckAraLag.selected = !btnCheckAraLag.selected;
    if (btnCheckAraLag.selected) {
        APPDELEGATE.language = @"ara";
        btnCheckEngLag.selected = NO;
    }
}

- (IBAction)onEngLag:(id)sender {
    btnCheckEngLag.selected = !btnCheckEngLag.selected;
    if (btnCheckEngLag.selected) {
        APPDELEGATE.language = @"eng";
        btnCheckAraLag.selected = NO;
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSetLanguage:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSLog(@"%@", _responseObject);
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            [[AppDelegate sharedDelegate] saveLoginData];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error" :nil];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
        
    };
    [[Communication sharedManager] SetLanguage:APPDELEGATE.access_token language:APPDELEGATE.language successed:successed failure:failure];
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
