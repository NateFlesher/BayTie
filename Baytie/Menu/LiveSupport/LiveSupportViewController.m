//
//  LiveSupportViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "LiveSupportViewController.h"
#import "LiveChattingViewController.h"

@interface LiveSupportViewController ()

@end

@implementation LiveSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onLiveChat:(id)sender {
    LiveChattingViewController *viewcontroller = [[LiveChattingViewController alloc] initWithNibName:@"LiveChattingViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
@end
