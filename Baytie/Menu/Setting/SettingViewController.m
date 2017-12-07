//
//  SettingViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SettingViewController.h"
#import "CustomerProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "SettingAddressViewController.h"
#import "SetLanguageViewController.h"
#import "SubScriptionViewController.h"
#import "ChangeMobileNoViewController.h"
#import "PrivacyViewController.h"
#import "TermsCondViewController.h"
#import "FaqViewController.h"
#import "AddressesViewController.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBack:(id)sender {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCustomerProfile:(id)sender {
    CustomerProfileViewController *viewcontroller = [[CustomerProfileViewController alloc] initWithNibName:@"CustomerProfileViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onchangePassword:(id)sender {
    ChangePasswordViewController *viewcontroller = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onMyAddress:(id)sender {
    AddressesViewController *viewcontroller = [[AddressesViewController alloc] initWithNibName:@"AddressesViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onSubscription:(id)sender {
    SubScriptionViewController *viewcontroller = [[SubScriptionViewController alloc] initWithNibName:@"SubScriptionViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onChangeMobileNum:(id)sender {
    ChangeMobileNoViewController *viewcontroller = [[ChangeMobileNoViewController alloc] initWithNibName:@"ChangeMobileNoViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onLanguage:(id)sender {
    SetLanguageViewController *viewcontroller = [[SetLanguageViewController alloc] initWithNibName:@"SetLanguageViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onPrivacy:(id)sender {
    PrivacyViewController *viewcontroller = [[PrivacyViewController alloc] initWithNibName:@"PrivacyViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onTermsConditions:(id)sender {
    TermsCondViewController *viewcontroller = [[TermsCondViewController alloc] initWithNibName:@"TermsCondViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onFaq:(id)sender {
    FaqViewController *viewcontroller = [[FaqViewController alloc] initWithNibName:@"FaqViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}

- (IBAction)onLogout:(id)sender {
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    
//    [[Communication sharedManager] Logout:[AppDelegate sharedDelegate].sessionId successed:^(id _responseObject) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//        if ([_responseObject[@"status"] integerValue] == 1) {
    [APPDELEGATE.availableSwippingCellsById removeAllObjects];
            [[AppDelegate sharedDelegate] deleteLoginData];
            [[AppDelegate sharedDelegate] goToSplash];
//        }
//    } failure:^(NSError *_error) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//    }];
}

@end
