//
//  MainMenuViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "MainMenuViewController.h"
#import "PoliciesViewController.h"
#import "NotificationsViewController.h"
#import "PromotionsViewController.h"
#import "LiveSupportViewController.h"
#import "SocialMediaViewController.h"
#import "SettingViewController.h"
#import "MyReservationsViewController.h"
#import "MyOrdersViewController.h"
#import "MyPointsViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onMyOrders:(id)sender {
    MyOrdersViewController *viewcontroller = [[MyOrdersViewController alloc] initWithNibName:@"MyOrdersViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onMyReservations:(id)sender {
    MyReservationsViewController *viewcontroller = [[MyReservationsViewController alloc] initWithNibName:@"MyReservationsViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onSetting:(id)sender {
    SettingViewController *viewcontroller = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onSocialMedia:(id)sender {
    SocialMediaViewController *viewcontroller = [[SocialMediaViewController alloc] initWithNibName:@"SocialMediaViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onLiveSupport:(id)sender {
    LiveSupportViewController *viewcontroller = [[LiveSupportViewController alloc] initWithNibName:@"LiveSupportViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onPromotions:(id)sender {
    PromotionsViewController *viewcontroller = [[PromotionsViewController alloc] initWithNibName:@"PromotionsViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onNotifications:(id)sender {
    NotificationsViewController *viewcontroller = [[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onMyPoints:(id)sender {
    MyPointsViewController *viewcontroller = [[MyPointsViewController alloc] initWithNibName:@"MyPointsViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onPolicies:(id)sender {
    PoliciesViewController *viewcontroller = [[PoliciesViewController alloc] initWithNibName:@"PoliciesViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBackTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
