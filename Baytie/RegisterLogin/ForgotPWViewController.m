//
//  ForgotPWViewController.m
//  RouteTrade
//
//  Created by stepanekdavid on 9/4/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import "ForgotPWViewController.h"

@interface ForgotPWViewController ()

@end

@implementation ForgotPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:gesture];
}
-(void)handleTap
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtEmailOrPhoneNumForgot)
    {
        [self onSend:nil];
    }
    return YES;
}
- (IBAction)onBackScreen:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSend:(id)sender {
}
@end
