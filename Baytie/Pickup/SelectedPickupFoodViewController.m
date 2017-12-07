//
//  SelectedPickupFoodViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SelectedPickupFoodViewController.h"
#import "FoodCell.h"
#import "MainMenuViewController.h"
#import "SelectedFoodForPickUpPreViewController.h"
#import "BasketPickUpViewController.h"
#import "UIImageView+AFNetworking.h"
@interface SelectedPickupFoodViewController (){
    NSMutableArray *arrPickupFoods;
}

@end

@implementation SelectedPickupFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    arrPickupFoods = [[NSMutableArray alloc] init];
    
    lblParFoodName.text = [_parMenuFoodItem objectForKey:@"cat_name"];
    lblRestroName.text = _selectedRestroName;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    
    [self getAllFood];
}
- (void)getAllFood{
    [arrPickupFoods removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            for (NSDictionary *dict in [_responseObject objectForKey:@"resource"]) {
                //if ([dict objectForKey:@"price"] && [[dict objectForKey:@"price"] floatValue] > 0) {
                    [arrPickupFoods addObject:dict];
                //}
            }
            [KindsSelectedFoodForPickupTableView reloadData];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetRestaurantsAllFood:APPDELEGATE.access_token categoryId:[[_parMenuFoodItem objectForKey:@"id"] integerValue] successed:successed failure:failure];
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrPickupFoods count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"FoodItem";
    FoodCell *cell = (FoodCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrPickupFoods objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [FoodCell sharedCell];
    }
    [cell setCurWorkoutsItem:dict];
    cell.menuItemName.text = [dict objectForKey:@"name"];
    cell.menuItemDescription.text = [dict objectForKey:@"description"];
    if ([[dict objectForKey:@"price_type"] integerValue] == 2) {
        if ([dict objectForKey:@"price"] && [[dict objectForKey:@"price"] floatValue] > 0) {
            cell.lblFoodItemPrice.hidden = NO;
            cell.lblFoodItemPrice.text = [APPDELEGATE getFloatToString:[[dict objectForKey:@"price"] floatValue]];
        }
    }else{
        cell.lblFoodItemPrice.text = @"Price on selection";
    }
    
    cell.lblPoint.text = [APPDELEGATE getIntToStringForPoint:[[dict objectForKey:@"redeem_point"] integerValue]];
    cell.promoImage.hidden = YES;
    if (![[dict objectForKey:@"promo_id"] isKindOfClass:[NSNull class]]) {
        cell.promoImage.hidden = NO;
    }
    if ([dict objectForKey:@"image"] && ![[dict objectForKey:@"image"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"image"] isEqualToString:@""]) {
        NSArray *arrForUrl = [[dict objectForKey:@"image"] componentsSeparatedByString:@"/"];
        NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
        [cell.foodImage setImageWithURL:[NSURL URLWithString:logoUrl]];
    }
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
    SelectedFoodForPickUpPreViewController *viewcontroller = [[SelectedFoodForPickUpPreViewController alloc] initWithNibName:@"SelectedFoodForPickUpPreViewController" bundle:nil];
    viewcontroller.pickupFoodsItem = [arrPickupFoods objectAtIndex:indexPath.row];
    viewcontroller.selectedRestroName = _selectedRestroName;
    viewcontroller.locationId = [_parMenuFoodItem objectForKey:@"location_id"];
    viewcontroller.areaId = _areaId;
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}
- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
                vc.restroId = _restroId;
                vc.locationId = [_parMenuFoodItem objectForKey:@"location_id"];
                vc.selectedRestroName = _selectedRestroName;
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
    
    [[Communication sharedManager] GetFetchAllOrdersCart:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:[_restroId integerValue] locationId:[[_parMenuFoodItem objectForKey:@"location_id"] integerValue] successed:successed failure:failure];
}
@end
