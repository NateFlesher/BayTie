//
//  NotificationsViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationsCell.h"

@interface NotificationsViewController ()<NotificationsCelllDelegate>{
    NSMutableArray *arrNotifications;
}

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrNotifications = [[NSMutableArray alloc] init];
    [arrNotifications addObject:@{@"id": @1}];
    [arrNotifications addObject:@{@"id": @2}];
    [arrNotifications addObject:@{@"id": @3}];
    [arrNotifications addObject:@{@"id": @4}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrNotifications count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"NotificationsItem";
    NotificationsCell *cell = (NotificationsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrNotifications objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [NotificationsCell sharedCell];
    }
    [cell setCurWorkoutsItem:dict];
    cell.delegate = self;
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma  mark NotificationCellDelegate
- (void)onNotiDeleteItem:(NSDictionary *)dic{
    if ([arrNotifications containsObject:dic]) {
        [arrNotifications removeObject:dic];
        [notificationTableView reloadData];
    }
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
