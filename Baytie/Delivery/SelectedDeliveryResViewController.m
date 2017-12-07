//
//  SelectedDeliveryResViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SelectedDeliveryResViewController.h"
#import "MainMenuViewController.h"
#import "FoodMenuCell.h"
#import "DeliverySelectedResInfoViewController.h"
#import "SelectedDeliveryFoodViewController.h"
#import "BasketFoodViewController.h"

@interface SelectedDeliveryResViewController (){
    NSDictionary *restroInfos;
    NSMutableArray *arrRestroMenuCategories;
}

@end



@implementation SelectedDeliveryResViewController
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
                    [deliveryFoodMenuTableView reloadData];
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
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    SelectedDeliveryFoodViewController *viewcontroller = [[SelectedDeliveryFoodViewController alloc] initWithNibName:@"SelectedDeliveryFoodViewController" bundle:nil];
    viewcontroller.parMenuFoodItem = [arrRestroMenuCategories objectAtIndex:indexPath.row];
    viewcontroller.selectedRestroName = [restroInfos objectForKey:@"restro_name"];
    viewcontroller.areaId = _areaId;
    viewcontroller.restroId = [restroInfos objectForKey:@"restro_id"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onDeliveryResInfo:(id)sender {
    DeliverySelectedResInfoViewController *viewcontroller = [[DeliverySelectedResInfoViewController alloc] initWithNibName:@"DeliverySelectedResInfoViewController" bundle:nil];
    viewcontroller.restroDetails = restroInfos;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onDeliveryBasket:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
             NSMutableArray *arrItems = [[_responseObject objectForKey:@"resource"] mutableCopy];
            if ([arrItems count] <= 0) {
                
                [ self  showAlert: @"Oops! Your cart is empty" :@"Mataam"] ;
            }else{
                
                BasketFoodViewController *vc = [[BasketFoodViewController alloc] initWithNibName:@"BasketFoodViewController" bundle:nil];
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
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ];
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetFetchAllOrdersCart:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:[[restroInfos objectForKey:@"restro_id"] integerValue] locationId:[[restroInfos objectForKey:@"location_id"] integerValue] successed:successed failure:failure];
    
}
@end
