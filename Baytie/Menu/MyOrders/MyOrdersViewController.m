//
//  MyOrdersViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "MyOrderCell.h"
#import "DeliverySelectedResInfoViewController.h"
#import "UIImageView+AFNetworking.h"
@interface MyOrdersViewController ()<MyOrderCellDelegate,UIAlertViewDelegate, UITextViewDelegate>{
    NSMutableArray *arrMyOrders;
    NSDictionary *selectedRestroInfo;
    
    NSMutableArray *ratingRestros;
    NSInteger starValue;
    
    NSMutableArray *arrItems;
    
    NSDictionary *currentRestro;
    NSMutableArray *arrArea;
}

@end

@implementation MyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrMyOrders = [[NSMutableArray alloc] init];
    ratingRestros = [[NSMutableArray alloc] init];
    arrArea = [[NSMutableArray alloc] init];
    
    ratingViewOfOrders.hidden = YES;
    detailsOrdersView.hidden = YES;
    locationSelectedView.hidden = YES;
    starValue = 0;
    [self updatingStars:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getMyOrders];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)getMyOrders{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetMyOrders:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:0 successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            arrMyOrders = [_responseObject objectForKey:@"resource"];
            [MyOrdersTableView reloadData];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:ItemTableView]){
        return [arrItems count];
    }else if([tableView isEqual:areaTableView]){
        return [arrArea count];
    }
    return [arrMyOrders count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:ItemTableView]){
        return 30.0f;
    }
    return 210.0f;
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
    }else if([tableView isEqual:ItemTableView]){
        static NSString *sortTableViewIdentifier = @"OrderItemItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sortTableViewIdentifier];
        }

        NSDictionary *dic = [arrItems objectAtIndex:indexPath.row];
        cell.textLabel.text =[dic objectForKey:@"item_name"];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        cell.detailTextLabel.text = [APPDELEGATE getFloatToString:[[dic objectForKey:@"price"] floatValue]];
        return cell;
    }
    static NSString *simpleTableIdentifier = @"MyOrderItem";
    MyOrderCell *cell = (MyOrderCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrMyOrders objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [MyOrderCell sharedCell];
    }
    cell.delegate = self;
    [cell setCurWorkoutsItem:dict];
    if (![[dict objectForKey:@"restaurant"] isKindOfClass:[NSNull class]]) {
        if (![[[dict objectForKey:@"restaurant"] objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]]) {
            NSArray *arrForUrl = [[[dict objectForKey:@"restaurant"] objectForKey:@"restro_logo"] componentsSeparatedByString:@"/"];
            NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
            [cell.oneOrderProfileImage setImageWithURL:[NSURL URLWithString:logoUrl]];
        }
        cell.lblMyOrderOneRestroName.text = [[dict objectForKey:@"restaurant"] objectForKey:@"restro_name"];
    }
    cell.lblMyOrderOneNo.text = [NSString stringWithFormat:@"# %@", [dict objectForKey:@"order_no"]];
    cell.lblMyOrderOneAmount.text = [APPDELEGATE getFloatToString:[[dict objectForKey:@"total"] floatValue]];
    NSArray *arrydate = [[dict objectForKey:@"updated_time"] componentsSeparatedByString:@" "];
    cell.lblMyOrderOneDateTime.text = arrydate[0];
    cell.lblMyOrderOnePointsGained.text = [APPDELEGATE getIntToStringForPoint:[[dict objectForKey:@"order_points"] integerValue]];
    cell.lblMyOrderOneUsed.text = [APPDELEGATE getIntToStringForPoint:[[dict objectForKey:@"used_points"] integerValue]];
    switch ([[dict objectForKey:@"payment_method"] integerValue]) {
        case 1:
            cell.lblMyOrderOnePayment.text = @"Cash";
            break;
        case 2:
            cell.lblMyOrderOnePayment.text = @"Knet";
            break;
        case 3:
            cell.lblMyOrderOnePayment.text = @"Credit Card";
            break;
            
        default:
            break;
    }
    //if ([ratingRestros containsObject:[dict objectForKey:@"restro_location_id"]]) {
        cell.btnRate.selected = YES;
    //}else{
    //    cell.btnRate.selected = NO;
    //}
    switch ([[dict objectForKey:@"status"] integerValue]) {
        case -1:
            cell.lblMyOrderOneDeliveryStatus.text = @"CANCELLED";
            [cell.lblMyOrderOneDeliveryStatus setTextColor:[UIColor colorWithRed:214.0f/255.0f green:29.0f/255.0f blue:8.0f/255.0f alpha:1.0f]];
            [cell.btnRate setEnabled:NO];
            [cell.btnReOrder setEnabled:NO];
            [cell.btnCancel setEnabled:NO];
            cell.btnRate.selected = NO;
            cell.btnReOrder.selected = NO;
            cell.btnCancel.selected = NO;
            break;
        case 1:
            cell.lblMyOrderOneDeliveryStatus.text = @"UNDER PROCESS";
            [cell.lblMyOrderOneDeliveryStatus setTextColor:[UIColor colorWithRed:41.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
            [cell.btnRate setEnabled:NO];
            [cell.btnReOrder setEnabled:NO];
            [cell.btnCancel setEnabled:YES];
            cell.btnRate.selected = NO;
            cell.btnReOrder.selected = NO;
            cell.btnCancel.selected = YES;
            break;
        case 3:
            cell.lblMyOrderOneDeliveryStatus.text = @"COMPLETED";
            [cell.lblMyOrderOneDeliveryStatus setTextColor:[UIColor colorWithRed:107.0f/255.0f green:190.0f/255.0f blue:27.0f/255.0f alpha:1.0f]];
            [cell.btnRate setEnabled:YES];
            [cell.btnReOrder setEnabled:YES];
            [cell.btnCancel setEnabled:NO];
            cell.btnRate.selected = YES;
            cell.btnReOrder.selected = YES;
            cell.btnCancel.selected = NO;
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
    if([tableView isEqual:ItemTableView]){
        
    }
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView isEqual:areaTableView]){
        locationSelectedView.hidden = YES;
        
        NSDictionary *dict = [arrArea objectAtIndex:indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        [[Communication sharedManager] GetCurrentOrderDetails:APPDELEGATE.access_token serviceType:[[currentRestro objectForKey:@"order_service_type"] integerValue] orderId:[[currentRestro objectForKey:@"id"] integerValue] successed:^(id _responseObject) {
            
            
            if ([_responseObject[@"code"] integerValue] == 0) {
                void ( ^successed )( id _responseObject ) = ^( id _responseObject )
                {
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
                        
                        [self getMyOrders];
                        
                    }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
                        [self showAlert:_responseObject[@"message"] :@"Error"];
                    }
                };
                
                void ( ^failure )( NSError* _error ) = ^( NSError* _error )
                {
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
                    
                } ;
                
                [[Communication sharedManager] SetOrders:APPDELEGATE.access_token serviceType:[[currentRestro objectForKey:@"order_service_type"] integerValue] areaId:[[dict objectForKey:@"id"] integerValue] restroId:[[currentRestro objectForKey:@"restro_id"] integerValue] locationId:[[currentRestro objectForKey:@"restro_location_id"] integerValue] redeemType:[[currentRestro objectForKey:@"coupon_point_apply"] integerValue] couponCode:[currentRestro objectForKey:@"coupon_code"] scheduleDate:[currentRestro objectForKey:@"delivery_date"] scheduleTime:[currentRestro objectForKey:@"delivery_time"] paymentMethod:[[currentRestro objectForKey:@"payment_method"] integerValue] addressId:[[currentRestro objectForKey:@"address_id"] integerValue] extraDirection:[currentRestro objectForKey:@"extra_direction"] successed:successed failure:failure];
            }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self showAlert:_responseObject[@"message"] :@"Error"];
            }
        } failure:^(NSError *_error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark MyOrderCellDelegate
- (void)onRateIt:(NSDictionary *)dic{
    ratingViewOfOrders.hidden = NO;
    selectedRestroInfo = dic;
}
- (IBAction)onRatingViewClose:(id)sender {
    [self.view endEditing:YES];
    ratingViewOfOrders.hidden = YES;
}

- (IBAction)onRateItForOrder:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] SetRestaurantsRating:APPDELEGATE.access_token locationId:[[selectedRestroInfo objectForKey:@"restro_location_id"] integerValue] starValue:starValue restroId:[[selectedRestroInfo objectForKey:@"restro_id"] integerValue] msg:txtReview.text successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            
            ratingViewOfOrders.hidden = YES;
            [ratingRestros addObject:[[_responseObject objectForKey:@"resource"] objectForKey:@"location_id"]];
            [MyOrdersTableView reloadData];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
}

- (IBAction)onGainStars:(id)sender {
    [self.view endEditing:YES];
    if ([sender isEqual:btnStar1]) {
        starValue = 1;
    }else if ([sender isEqual:btnStar2]) {
        starValue = 2;
    }else if ([sender isEqual:btnStar3]) {
        starValue = 3;
    }else if ([sender isEqual:btnStar4]) {
        starValue = 4;
    }else if ([sender isEqual:btnStar5]) {
        starValue = 5;
    }
    [self updatingStars:starValue];
}

- (IBAction)onCloseDetailsOrderView:(id)sender {
    detailsOrdersView.hidden = YES;
}

#pragma mark - MyOrderCellDelegate
- (void)onReorderOne:(NSDictionary *)dic;
{
    currentRestro = dic;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetRestaurantsAreas:APPDELEGATE.access_token restroId:[[currentRestro objectForKey:@"restro_id"] integerValue] locationId:[[currentRestro objectForKey:@"location_id"] integerValue] serviceId:[[currentRestro objectForKey:@"service_id"] integerValue] successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            [arrArea removeAllObjects];
            arrArea = [[_responseObject objectForKey:@"resource"] mutableCopy];
            locationSelectedView.hidden = NO;
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
- (void)onOrderDetailsOne:(NSDictionary *)dic{
    selectedRestroInfo = dic;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetCurrentOrderDetails:APPDELEGATE.access_token serviceType:[[dic objectForKey:@"order_service_type"] integerValue] orderId:[[dic objectForKey:@"id"] integerValue] successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            detailsOrdersView.hidden = NO;
            //[arrItems removeAllObjects];
            arrItems = [[_responseObject objectForKey:@"resource"] mutableCopy];
            [ItemTableView reloadData];
            
            if (![[dic objectForKey:@"restaurant"] isKindOfClass:[NSNull class]]) {
                if (![[[dic objectForKey:@"restaurant"] objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]]) {
                    NSArray *arrForUrl = [[[dic objectForKey:@"restaurant"] objectForKey:@"restro_logo"]componentsSeparatedByString:@"/"];
                    NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
                    [restroImg setImageWithURL:[NSURL URLWithString:logoUrl]];
                }
                restroName.text = [[dic objectForKey:@"restaurant"] objectForKey:@"restro_name"];
                lblDeliveryAddress.text = [NSString stringWithFormat:@"Address: %@, %@", [[dic objectForKey:@"restaurant"] objectForKey:@"street"], [[dic objectForKey:@"restaurant"] objectForKey:@"building"]];
                lblDeliveryPhoneNo.text = [NSString stringWithFormat:@"Phone: %@", [[dic objectForKey:@"restaurant"] objectForKey:@"telephones"]];
                [restroName setTextColor:[UIColor darkTextColor]];
                [lblDeliveryAddress setTextColor:[UIColor darkTextColor]];
                [lblDeliveryPhoneNo setTextColor:[UIColor darkTextColor]];
            }else{
                [restroImg setImage:[UIImage imageNamed:@"restro_detault.png"]];
                restroName.text = @"Restaurant";
                lblDeliveryAddress.text = @"";
                lblDeliveryPhoneNo.text = @"";
                [restroName setTextColor:[UIColor grayColor]];
                [lblDeliveryAddress setTextColor:[UIColor grayColor]];
                [lblDeliveryPhoneNo setTextColor:[UIColor grayColor]];
            }
            lblDeliveryPersionName.text = [NSString stringWithFormat:@"Person Name: %@ %@", APPDELEGATE.firstName, APPDELEGATE.lastName];
            lblOrderNm.text =[dic objectForKey:@"order_no"];
            lblOrderAmount.text = [APPDELEGATE getFloatToString:[[dic objectForKey:@"total"] floatValue]];
            NSArray *arrdate = [[dic objectForKey:@"updated_time"] componentsSeparatedByString:@" "];
            lblDate.text =arrdate[0];
            switch ([[dic objectForKey:@"payment_method"] integerValue]) {
                case 1:
                    lblPayment.text = @"Cash";
                    break;
                case 2:
                    lblPayment.text = @"Knet";
                    break;
                case 3:
                    lblPayment.text = @"Credit Card";
                    break;
                    
                default:
                    break;
            }
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
- (void)onOrderCancelOne:(NSDictionary *)dic{
    selectedRestroInfo = dic;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel" message:@"ARE YOU SURE?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 300;
    [alert show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (alertView.tag == 300) {
            [self cancelCurrentOrder:[[selectedRestroInfo objectForKey:@"id"] integerValue]];
            return;
        }
    }
}
- (void)cancelCurrentOrder:(NSInteger)orderId{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] CancelCurrentOrder:APPDELEGATE.access_token serviceType:[[selectedRestroInfo objectForKey:@"order_service_type"] integerValue] orderId:orderId successed:^(id _responseObject) {
        if ([_responseObject[@"code"] integerValue] == 0) {
            [[Communication sharedManager] GetMyOrders:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:0 successed:^(id _responseObject) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                if ([_responseObject[@"code"] integerValue] == 0) {
                    arrMyOrders = [_responseObject objectForKey:@"resource"];
                    [MyOrdersTableView reloadData];
                    
                }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                    [self showAlert:_responseObject[@"message"] :@"Error"];
                }
            } failure:^(NSError *_error) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            }];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
- (void)updatingStars:(NSInteger)value{
    switch (value) {
        case 0:
            [btnStar1 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar2 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar3 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [btnStar1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar2 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar3 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [btnStar1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar3 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [btnStar1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar3 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [btnStar5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [btnStar1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar3 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar4 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [btnStar1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar3 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar4 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [btnStar5 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView isEqual:txtReview]) {
        if ([txtReview.text isEqualToString:@"Write your reivew here"]) {
            txtReview.text = @"";
        }
    }
    return YES;
}
//- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView isEqual:txtReview]) {
        if ([txtReview.text isEqualToString:@""]) {
            txtReview.text = @"Write your reivew here";
        }
    }
}
@end
