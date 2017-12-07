//
//  SelectedPickupResViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SelectedPickupResViewController.h"
#import "MainMenuViewController.h"
#import "FoodMenuCell.h"
#import "PickupSelectedResInfoViewController.h"
#import "SelectedPickupFoodViewController.h"
#import "BasketPickUpViewController.h"

@interface SelectedPickupResViewController (){
    NSDictionary *restroInfos;
    NSMutableArray *arrRestroMenuCategories;
}

@end

@implementation SelectedPickupResViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    
    arrRestroMenuCategories = [[NSMutableArray alloc] init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    [self getRestroInfos];
}
- (void)getRestroInfos{
    [arrRestroMenuCategories removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            restroInfos = [_responseObject objectForKey:@"resource"];
            _lblRestroName.text = [restroInfos objectForKey:@"restro_name"];
            void ( ^successed )( id _responseObject ) = ^( id _responseObject )
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
                    arrRestroMenuCategories = [[_responseObject objectForKey:@"resource"] mutableCopy];
                    [pickupFoodMenuTableView reloadData];
                }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
                    [self showAlert:_responseObject[@"message"] :@"Error"];
                }
            };
            
            void ( ^failure )( NSError* _error ) = ^( NSError* _error )
            {
                
                [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
                [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
                
            } ;
            
            [[Communication sharedManager] GetRestaurantsItemCategories:APPDELEGATE.access_token locationId:[[[_responseObject objectForKey:@"resource"] objectForKey:@"location_id"] integerValue] serviceId:APPDELEGATE.serviceType successed:successed failure:failure];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetRestaurantInfos:APPDELEGATE.access_token restroId:[_restroId integerValue] locationId:[_locationId integerValue] serviceType:APPDELEGATE.serviceType successed:successed failure:failure];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrRestroMenuCategories count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"FoodMenuItem";
    FoodMenuCell *cell = (FoodMenuCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrRestroMenuCategories objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [FoodMenuCell sharedCell];
    }
    [cell setCurWorkoutsItem:dict];
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
    SelectedPickupFoodViewController *viewcontroller = [[SelectedPickupFoodViewController alloc] initWithNibName:@"SelectedPickupFoodViewController" bundle:nil];
    viewcontroller.selectedRestroName = [restroInfos objectForKey:@"restro_name"];
    viewcontroller.parMenuFoodItem = [arrRestroMenuCategories objectAtIndex:indexPath.row];
    viewcontroller.areaId = _areaId;
    viewcontroller.restroId = [restroInfos objectForKey:@"restro_id"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectedResInfo:(id)sender {
    PickupSelectedResInfoViewController *viewcontroller = [[PickupSelectedResInfoViewController alloc] initWithNibName:@"PickupSelectedResInfoViewController" bundle:nil];
    viewcontroller.restroDetails = restroInfos;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onGoToCart:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            NSMutableArray *arrItems = [[_responseObject objectForKey:@"resource"] mutableCopy];
            if ([arrItems count]<=0) {
                [ self  showAlert: @"Oops! Your cart is empty." :@"Mataam"] ;
            }else{
                BasketPickUpViewController *vc = [[BasketPickUpViewController alloc] initWithNibName:@"BasketPickUpViewController" bundle:nil];
                vc.restroId = [restroInfos objectForKey:@"restro_id"];
                vc.locationId = [restroInfos objectForKey:@"location_id"];
                vc.selectedRestroName = [restroInfos objectForKey:@"restro_name"];
                vc.areaId = _areaId;
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                nc.navigationBar.translucent = NO;
                [self presentViewController:nc animated:YES completion:nil];
            }
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [ self  showAlert: @"Oops! Your cart is empty." :@"Mataam"] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetFetchAllOrdersCart:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:[[restroInfos objectForKey:@"restro_id"] integerValue] locationId:[[restroInfos objectForKey:@"location_id"] integerValue] successed:successed failure:failure];
}
@end
