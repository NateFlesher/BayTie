//
//  ViewController.m
//  RouteTrade
//
//  Created by stepanekdavid on 9/3/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "MBProgressHUD.h"
#import "Communication.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnlogin.hidden = YES;
    self.btnRegister.hidden = YES;
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
    if (sessionId) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        [[Communication sharedManager] CheckSession:sessionId successed:^(id _responseObject) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            if ([_responseObject[@"status"] integerValue] == 1) {
                [[AppDelegate sharedDelegate] loadLoginData];
                [[AppDelegate sharedDelegate] goToMainView];
            } else {
                [[AppDelegate sharedDelegate] deleteLoginData];
                self.btnlogin.hidden = NO;
                self.btnRegister.hidden = NO;
            }
        } failure:^(NSError *_error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [[AppDelegate sharedDelegate] deleteLoginData];
            self.btnlogin.hidden = NO;
            self.btnRegister.hidden = NO;
        }];
    } else {
        self.btnlogin.hidden = NO;
        self.btnRegister.hidden = NO;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btLoginClick:(id)sender
{
    LoginViewController *viewcontroller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(IBAction)btSignupClick:(id)sender
{
    SignUpViewController *viewcontroller = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height >= 568.0);
}

@end
