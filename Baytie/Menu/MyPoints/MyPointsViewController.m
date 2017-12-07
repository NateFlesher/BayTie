//
//  MyPointsViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "MyPointsViewController.h"
#import "MataamPointsViewController.h"
#import "LoyaltyPointsViewController.h"

@interface MyPointsViewController ()

@end

@implementation MyPointsViewController

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
- (IBAction)onMataamPoints:(id)sender {
    MataamPointsViewController *viewcontroller = [[MataamPointsViewController alloc] initWithNibName:@"MataamPointsViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onLoyaltyPoints:(id)sender {
    LoyaltyPointsViewController *viewcontroller = [[LoyaltyPointsViewController alloc] initWithNibName:@"LoyaltyPointsViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBackMenu:(id)sender {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
