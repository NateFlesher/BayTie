//
//  AddressesViewController.m
//  Baytie
//
//  Created by stepanekdavid on 1/8/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import "AddressesViewController.h"
#import "AddressCell.h"
#import "SettingAddressViewController.h"

@interface AddressesViewController (){
    NSMutableArray *addressesArray;
}

@end

@implementation AddressesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    addressesArray = [[NSMutableArray alloc] init];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    [self getUserInfos];
}
- (void)getUserInfos{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetUserAddress:APPDELEGATE.access_token successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            [addressesArray removeAllObjects];
            addressesArray = [[_responseObject objectForKey:@"resource"] mutableCopy];
            [AddressesTableView reloadData];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [addressesArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"AddressItem";
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [addressesArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [AddressCell sharedCell];
    }
    [cell setAddressesItem:dict];
    cell.addressName.text = [NSString stringWithFormat:@"%@(%@)",[dict objectForKey:@"address_name"], [dict objectForKey:@"area_name"]];
    cell.addressFull.text = [NSString stringWithFormat:@"%@, %@, %@, %@", [dict objectForKey:@"street"], [dict objectForKey:@"block"], [dict objectForKey:@"floor"], [dict objectForKey:@"appartment"]];
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
    NSDictionary *dict = [addressesArray objectAtIndex:indexPath.row];
    
    SettingAddressViewController *viewcontroller = [[SettingAddressViewController alloc] initWithNibName:@"SettingAddressViewController" bundle:nil];
    viewcontroller.addressInfo = dict;
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddAddress:(id)sender {
    SettingAddressViewController *viewcontroller = [[SettingAddressViewController alloc] initWithNibName:@"SettingAddressViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}
@end
