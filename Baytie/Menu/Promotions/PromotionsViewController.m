//
//  PromotionsViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "PromotionsViewController.h"
#import "PromotionsCell.h"
#import "UIImageView+AFNetworking.h"

#import "SelectedDeliveryResViewController.h"
#import "BasketFoodViewController.h"

#import "SelectedPickupResViewController.h"
#import "BasketPickUpViewController.h"

#import "SelectedCateringResViewController.h"
#import "BasketCateringViewController.h"


@interface PromotionsViewController ()<UITableViewDelegate, UITableViewDataSource, PromotionsCellDelegate>{
    NSMutableArray *arrPromotions;
    NSMutableArray *arrArea;
    
    NSDictionary *currentRestro;
    
    BOOL isGoToMenu;
}

@end

@implementation PromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrPromotions = [[NSMutableArray alloc] init];
    arrArea = [[NSMutableArray alloc] init];
    areaSelectedView.hidden = YES;
    isGoToMenu = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getRestroPromotions];
}
- (void)getRestroPromotions{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetRestaurantsPromotions:APPDELEGATE.access_token restroId:0 locationId:0 serviceId:APPDELEGATE.serviceType successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            [arrPromotions removeAllObjects];
            arrPromotions = [[_responseObject objectForKey:@"resource"] mutableCopy];
            [promotionsTableView reloadData];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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
    if([tableView isEqual:areaTableView]){
        return [arrArea count];
    }
    return [arrPromotions count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isEqual:areaTableView]){
        return 30.0f;
    }
    return 151.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isEqual:areaTableView]){
        static NSString *sortTableViewIdentifier = @"AreaForRestroItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sortTableViewIdentifier];
        }
        
        NSDictionary *dic = [arrArea objectAtIndex:indexPath.row];
        cell.textLabel.text =[NSString stringWithFormat:@"%@, %@",[dic objectForKey:@"city_name"], [dic objectForKey:@"name"]];
        return cell;
    }
    static NSString *simpleTableIdentifier = @"PromotionsItem";
    PromotionsCell *cell = (PromotionsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrPromotions objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [PromotionsCell sharedCell];
    }
    [cell setCurWorkoutsItem:dict];
    if (![[dict objectForKey:@"restaurant"] isKindOfClass:[NSNull class]]) {
        if (![[[dict objectForKey:@"restaurant"] objectForKey:@"restaurant_logo"] isKindOfClass:[NSNull class]]) {
            NSArray *arrForUrl = [[[dict objectForKey:@"restaurant"] objectForKey:@"restaurant_logo"]componentsSeparatedByString:@"/"];
            NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
            [cell.logoImage setImageWithURL:[NSURL URLWithString:logoUrl]];
        }
        cell.lblRestroName.text = [[dict objectForKey:@"restaurant"] objectForKey:@"restro_name"];
        [cell.lblRestroName setTextColor:[UIColor darkTextColor]];       
        cell.delegate = self;
        switch ([[[dict objectForKey:@"restaurant"] objectForKey:@"status"] integerValue]) {
            case 0://close
                [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                cell.lblStatus.text = @"Close";
                break;
            case 1://open
                [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                cell.lblStatus.text = @"Open";
                break;
            case 2://busy
                [cell.statusImage setImage:[UIImage imageNamed:@"status_open_red.png"]];
                cell.lblStatus.text = @"Busy";
                break;
                
            default:
                break;
        }
    }else{
        [cell.logoImage setImage:[UIImage imageNamed:@"restro_detault.png"]];
        cell.lblRestroName.text = @"Restaurant";
        [cell.lblRestroName setTextColor:[UIColor grayColor]];
        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
        cell.lblStatus.text = @"Close";
    }
    cell.lblPromotionName.text = [dict objectForKey:@"name"];
    cell.lblPromotionsDescription.text = [dict objectForKey:@"description"];
    cell.lblAmount.text = [APPDELEGATE getFloatToString:[[dict objectForKey:@"price"] floatValue]];
    cell.lblDate.text = [dict objectForKey:@"to_date"];
    switch ([[dict objectForKey:@"service_id"] integerValue]) {
        case 1:
            [cell.serviceImage setImage:[UIImage imageNamed:@"img_promotion_mark_delivery.png"]];
            break;
        case 2:
            [cell.serviceImage setImage:[UIImage imageNamed:@"img_promotion_mark_catering.png"]];
            break;
        case 3:
            [cell.serviceImage setImage:[UIImage imageNamed:@"img_promotion_mark_reservation.png"]];
            break;
        case 4:
            [cell.serviceImage setImage:[UIImage imageNamed:@"img_promotion_mark_pickup.png"]];
            break;            
        default:
            break;
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
    if([tableView isEqual:areaTableView]){
        areaSelectedView.hidden = YES;
        NSDictionary *dict = [arrArea objectAtIndex:indexPath.row];
        
        switch ([[currentRestro objectForKey:@"service_id"] integerValue]) {
            case 1://delivery
            {
                APPDELEGATE.serviceType = 1;
                if (isGoToMenu) {
                    SelectedDeliveryResViewController *viewcontroller = [[SelectedDeliveryResViewController alloc] initWithNibName:@"SelectedDeliveryResViewController" bundle:nil];
                    viewcontroller.restroId = [currentRestro objectForKey:@"restro_id"];
                    viewcontroller.locationId = [currentRestro objectForKey:@"location_id"];
                    viewcontroller.areaId = [dict objectForKey:@"id"];
                    [self.navigationController pushViewController:viewcontroller animated:YES];
                }else{
                    BasketFoodViewController *vc = [[BasketFoodViewController alloc] initWithNibName:@"BasketFoodViewController" bundle:nil];
                    vc.restroId = [currentRestro objectForKey:@"restro_id"];
                    vc.locationId = [currentRestro objectForKey:@"location_id"];
                    vc.selectedRestroName = [[currentRestro objectForKey:@"restaurant"] objectForKey:@"restro_name"];
                    vc.areaId = [dict objectForKey:@"id"];
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                    nc.navigationBar.translucent = NO;
                    [self presentViewController:nc animated:YES completion:nil];
                }
                
            }
                break;
            case 2://catering
            {
                
                APPDELEGATE.serviceType = 2;
                if (isGoToMenu) {
                    SelectedCateringResViewController *viewcontroller = [[SelectedCateringResViewController alloc] initWithNibName:@"SelectedCateringResViewController" bundle:nil];
                    viewcontroller.restroId = [currentRestro objectForKey:@"restro_id"];
                    viewcontroller.locationId = [currentRestro objectForKey:@"location_id"];
                    viewcontroller.areaId = [dict objectForKey:@"id"];
                    [self.navigationController pushViewController:viewcontroller animated:YES];
                }else{
                    BasketCateringViewController *vc = [[BasketCateringViewController alloc] initWithNibName:@"BasketCateringViewController" bundle:nil];
                    vc.restroId = [currentRestro objectForKey:@"restro_id"];
                    vc.locationId = [currentRestro objectForKey:@"location_id"];
                    vc.selectedRestroName = [[currentRestro objectForKey:@"restaurant"] objectForKey:@"restro_name"];
                    vc.areaId = [dict objectForKey:@"id"];
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                    nc.navigationBar.translucent = NO;
                    [self presentViewController:nc animated:YES completion:nil];
                }
            }
                break;
            case 3://reservation
            {
                APPDELEGATE.serviceType = 3;
            }
                break;
            case 4://pickup
            {
                APPDELEGATE.serviceType = 4;
                if (isGoToMenu) {
                    SelectedPickupResViewController *viewcontroller = [[SelectedPickupResViewController alloc] initWithNibName:@"SelectedPickupResViewController" bundle:nil];
                    viewcontroller.restroId = [currentRestro objectForKey:@"restro_id"];
                    viewcontroller.locationId = [currentRestro objectForKey:@"location_id"];
                    viewcontroller.areaId = [dict objectForKey:@"id"];
                    [self.navigationController pushViewController:viewcontroller animated:YES];
                }else{
                    BasketPickUpViewController *vc = [[BasketPickUpViewController alloc] initWithNibName:@"BasketPickUpViewController" bundle:nil];
                    vc.restroId = [currentRestro objectForKey:@"restro_id"];
                    vc.locationId = [currentRestro objectForKey:@"location_id"];
                    vc.selectedRestroName = [[currentRestro objectForKey:@"restaurant"] objectForKey:@"restro_name"];
                    vc.areaId = [dict objectForKey:@"id"];
                    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                    nc.navigationBar.translucent = NO;
                    [self presentViewController:nc animated:YES completion:nil];
                }
                
            }
                break;
            default:
                break;
        }

    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark PromotionCellDelegate

-(void)GotoAddToCartPromo:(NSDictionary *)dic{
    isGoToMenu = NO;
    currentRestro = dic;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetRestaurantsAreas:APPDELEGATE.access_token restroId:[[currentRestro objectForKey:@"restro_id"] integerValue] locationId:[[currentRestro objectForKey:@"location_id"] integerValue] serviceId:[[currentRestro objectForKey:@"service_id"] integerValue] successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            [arrArea removeAllObjects];
            arrArea = [[_responseObject objectForKey:@"resource"] mutableCopy];
            areaSelectedView.hidden = NO;
            [areaTableView reloadData];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self showAlert:@"Internet error!" :@"Error"];
    }];
}

-(void)GotoMenuPromo:(NSDictionary *)dic{
    isGoToMenu = YES;
    currentRestro = dic;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetRestaurantsAreas:APPDELEGATE.access_token restroId:[[currentRestro objectForKey:@"restro_id"] integerValue] locationId:[[currentRestro objectForKey:@"location_id"] integerValue] serviceId:[[currentRestro objectForKey:@"service_id"] integerValue] successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            [arrArea removeAllObjects];
            arrArea = [[_responseObject objectForKey:@"resource"] mutableCopy];
            areaSelectedView.hidden = NO;
            [areaTableView reloadData];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self showAlert:@"Internet error!" :@"Error"];
    }];

    
    
}
@end
