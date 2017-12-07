//
//  MyReservationsViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "MyReservationsViewController.h"
#import "MyReservationsCell.h"
#import "UIImageView+AFNetworking.h"

@interface MyReservationsViewController ()<MyReservationsCellDelegate, UIAlertViewDelegate, UITextViewDelegate>{
    NSMutableArray *arrMyReservations;
    
    NSDictionary *selectedRestroInfo;
    NSInteger starValue;
}

@end

@implementation MyReservationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrMyReservations = [[NSMutableArray alloc] init];
    
    payViewForReservations.hidden = YES;
    detailsForReservations.hidden = YES;
    
    starValue = 0;
    ratingView.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self getMyReservations];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)getMyReservations{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetMyReservations:APPDELEGATE.access_token restroId:0 locationId:0 successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            arrMyReservations = [_responseObject objectForKey:@"resource"];
            [myReservationsTableView reloadData];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
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
    return [arrMyReservations count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"MyReservationsItem";
    MyReservationsCell *cell = (MyReservationsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrMyReservations objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [MyReservationsCell sharedCell];
    }
    [cell setCurWorkoutsItem:dict];
    cell.delegate = self;
    if (![[dict objectForKey:@"restaurant"] isKindOfClass:[NSNull class]]) {
        if (![[[dict objectForKey:@"restaurant"] objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]]) {
            NSArray *arrForUrl = [[[dict objectForKey:@"restaurant"] objectForKey:@"restro_logo"]componentsSeparatedByString:@"/"];
            NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
            [cell.reservationOneProfile setImageWithURL:[NSURL URLWithString:logoUrl]];
        }
        cell.lblReservationRestroName.text = [[dict objectForKey:@"restaurant"] objectForKey:@"restro_name"];
    }
    cell.lblReservationNo.text = [dict objectForKey:@"order_no"];
    cell.lblReservationDateTime.text = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"date"],[dict objectForKey:@"time"]];
    cell.lblReservationPointsGained.text = [APPDELEGATE getIntToStringForPoint:[[dict objectForKey:@"order_points"] integerValue]];
    if (![[dict objectForKey:@"used_points"] isKindOfClass:[NSNull class]]) {
        cell.lblReservationUsed.text = [APPDELEGATE getIntToStringForPoint:[[dict objectForKey:@"used_points"] integerValue]];
    }else{
        cell.lblReservationUsed.text = @"0";
    }
    
    cell.btnPay.selected = YES;
    
    switch ([[dict objectForKey:@"status"] integerValue]) {
        case -1:
            cell.lblReservationOneStatus.text = @"CANCELLED";
            [cell.lblReservationOneStatus setTextColor:[UIColor colorWithRed:214.0f/255.0f green:29.0f/255.0f blue:8.0f/255.0f alpha:1.0f]];
            [cell.btnRate setEnabled:NO];
            [cell.btnCancenl setEnabled:NO];
            cell.btnRate.selected = NO;
            cell.btnCancenl.selected = NO;
            [cell.btnPay setEnabled:NO];
            cell.btnPay.selected = NO;
            break;
        case 1:
            cell.lblReservationOneStatus.text = @"UNDER PROCESS";
            [cell.lblReservationOneStatus setTextColor:[UIColor colorWithRed:41.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
            [cell.btnRate setEnabled:YES];
            [cell.btnCancenl setEnabled:YES];
            cell.btnRate.selected = YES;
            cell.btnCancenl.selected = YES;
            [cell.btnPay setEnabled:YES];
            cell.btnPay.selected = YES;
            break;
        case 2:
            cell.lblReservationOneStatus.text = @"WAITING PAYMENT";
            [cell.lblReservationOneStatus setTextColor:[UIColor colorWithRed:253.0f/255.0f green:129.0f/255.0f blue:5.0f/255.0f alpha:1.0f]];
            [cell.btnRate setEnabled:YES];
            [cell.btnCancenl setEnabled:YES];
            cell.btnRate.selected = YES;
            cell.btnCancenl.selected = YES;
            [cell.btnPay setEnabled:NO];
            cell.btnPay.selected = NO;
            break;
        case 3:
            cell.lblReservationOneStatus.text = @"COMPLETED";
            [cell.lblReservationOneStatus setTextColor:[UIColor colorWithRed:107.0f/255.0f green:190.0f/255.0f blue:27.0f/255.0f alpha:1.0f]];
            [cell.btnRate setEnabled:YES];
            [cell.btnCancenl setEnabled:NO];
            cell.btnRate.selected = YES;
            cell.btnCancenl.selected = NO;
            [cell.btnPay setEnabled:YES];
            cell.btnPay.selected = YES;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark MyReservationCellDelegate
- (void)onRateItForReservation:(NSDictionary *)dic{
    selectedRestroInfo = dic;
    ratingView.hidden = NO;
    
}
- (void)onReservationPayOne:(NSDictionary *)dic{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetCurrentReservationDetails:APPDELEGATE.access_token reservationId:[[dic objectForKey:@"id"] integerValue] successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            payViewForReservations.hidden = NO;
            if (![[dic objectForKey:@"restaurant"] isKindOfClass:[NSNull class]]) {
                
                lblLocationForPayment.text = [[dic objectForKey:@"restaurant"] objectForKey:@"location_name"];
                lblAddressForPayment.text = [NSString stringWithFormat:@"Address: %@, %@", [[dic objectForKey:@"restaurant"] objectForKey:@"street"], [[dic objectForKey:@"restaurant"] objectForKey:@"building"]];
                lblPhoneForPayment.text = [NSString stringWithFormat:@"Phone: %@", [[dic objectForKey:@"restaurant"] objectForKey:@"telephones"]];
            }
            lblReservationTimeForPayment.text = [dic objectForKey:@"time"];
            lblReserveDateForPayment.text = [dic objectForKey:@"date"];
            switch ([[dic objectForKey:@"payment_method"] integerValue]) {
                case 1:
                    btnPaymentKnetForPayment.selected = YES;
                    btnPaymentCreditForPayment.selected = NO;
                    break;
                case 2:
                    btnPaymentKnetForPayment.selected = NO;
                    btnPaymentCreditForPayment.selected = YES;
                    break;
                default:
                    break;
            }
            lblPaymentAmountForPayment.text = [NSString stringWithFormat:@"KD %3f", [[dic objectForKey:@"total"] floatValue]];
            lblPersonNumForPayment.text = [dic objectForKey:@"number_of_people"];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];

}
- (void)onReservationDetailsOne:(NSDictionary *)dic{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetCurrentReservationDetails:APPDELEGATE.access_token reservationId:[[dic objectForKey:@"id"] integerValue] successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            detailsForReservations.hidden = NO;
            if (![[dic objectForKey:@"restaurant"] isKindOfClass:[NSNull class]]) {
                if (![[[dic objectForKey:@"restaurant"] objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]]) {
                    NSArray *arrForUrl = [[[dic objectForKey:@"restaurant"] objectForKey:@"restro_logo"]componentsSeparatedByString:@"/"];
                    NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
                    [logoForDetails setImageWithURL:[NSURL URLWithString:logoUrl]];
                }
                detailsForDetails.text = [[dic objectForKey:@"restaurant"] objectForKey:@"restro_description"];
                SatWorkingTimeForDetails.text = [NSString stringWithFormat:@"Sat-Sun: %@-%@",[[dic objectForKey:@"restaurant"] objectForKey:@"saturday_from"], [[dic objectForKey:@"restaurant"] objectForKey:@"saturday_to"]];
                
                MonWorkingTimeForDetails.text = [NSString stringWithFormat:@"Mon-Fri: %@-%@",[[dic objectForKey:@"restaurant"] objectForKey:@"monday_from"], [[dic objectForKey:@"restaurant"] objectForKey:@"monday_to"]];
                if (![[[dic objectForKey:@"restaurant"] objectForKey:@"rating"] isKindOfClass:[NSNull class]]) {
                    if ([[[dic objectForKey:@"restaurant"] objectForKey:@"rating"] floatValue] > 0) {
                        NSInteger ratingValue = (int)roundf([[[dic objectForKey:@"restaurant"] objectForKey:@"rating"] floatValue]);
                        [ratingForDetails setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%ld", (long)ratingValue]]];
                    }else{
                        [ratingForDetails setImage:[UIImage imageNamed:@"rating_0"]];
                    }
                }else{
                    [ratingForDetails setImage:[UIImage imageNamed:@"rating_0"]];
                }
                
                lblLocationForDetails.text = [[dic objectForKey:@"restaurant"] objectForKey:@"location_name"];
                lblAddressForDetails.text = [NSString stringWithFormat:@"Address: %@, %@", [[dic objectForKey:@"restaurant"] objectForKey:@"street"], [[dic objectForKey:@"restaurant"] objectForKey:@"building"]];
                lblPhoneNumberForDetails.text = [NSString stringWithFormat:@"Phone: %@", [[dic objectForKey:@"restaurant"] objectForKey:@"telephones"]];
                [detailsForDetails setTextColor:[UIColor darkTextColor]];
                [SatWorkingTimeForDetails setTextColor:[UIColor darkTextColor]];
                [MonWorkingTimeForDetails setTextColor:[UIColor darkTextColor]];
                
            }else{
                [logoForDetails setImage:[UIImage imageNamed:@"restro_detault.png"]];
                detailsForDetails.text = @"***";
                SatWorkingTimeForDetails.text = @"Sat-Sun:";
                MonWorkingTimeForDetails.text = @"Mon-Fri:";
                [ratingForDetails setImage:[UIImage imageNamed:@"rating_0"]];
                [detailsForDetails setTextColor:[UIColor grayColor]];
                [SatWorkingTimeForDetails setTextColor:[UIColor grayColor]];
                [MonWorkingTimeForDetails setTextColor:[UIColor grayColor]];
            }
            lblReservationForDetails.text = [dic objectForKey:@"time"];
            lblReserveDateForDetails.text = [dic objectForKey:@"date"];
            lblPersonNumberForDetails.text = [dic objectForKey:@"number_of_people"];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];

}
- (void)onReservationCancelOne:(NSDictionary *)dic{
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
            [[Communication sharedManager] GetMyReservations:APPDELEGATE.access_token restroId:0 locationId:0 successed:^(id _responseObject) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                if ([_responseObject[@"code"] integerValue] == 0) {
                    arrMyReservations = [_responseObject objectForKey:@"resource"];
                    [myReservationsTableView reloadData];
                    
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
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPayViewCancel:(id)sender {
    payViewForReservations.hidden = YES;
}

- (IBAction)onDetailsViewCancel:(id)sender {
    detailsForReservations.hidden = YES;
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onRatingViewClose:(id)sender {
    [self.view endEditing:YES];
    ratingView.hidden = YES;
}

- (IBAction)onRating:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] SetRestaurantsRating:APPDELEGATE.access_token locationId:[[selectedRestroInfo objectForKey:@"restro_location_id"] integerValue] starValue:starValue restroId:[[selectedRestroInfo objectForKey:@"restro_id"] integerValue] msg:txtReview.text successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            
            ratingView.hidden = YES;
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
- (IBAction)onPaymentKnetForPayment:(id)sender {
    btnPaymentKnetForPayment.selected= YES;
    btnPaymentCreditForPayment.selected = NO;
}

- (IBAction)onPaymentCreditForPayment:(id)sender {
    btnPaymentKnetForPayment.selected= NO;
    btnPaymentCreditForPayment.selected = YES;
}

- (IBAction)onCheckout:(id)sender {
}

- (IBAction)onGainStars:(id)sender {
    [self.view endEditing:YES];
    if ([sender isEqual:star1]) {
        starValue = 1;
    }else if ([sender isEqual:star2]) {
        starValue = 2;
    }else if ([sender isEqual:star3]) {
        starValue = 3;
    }else if ([sender isEqual:star4]) {
        starValue = 4;
    }else if ([sender isEqual:star5]) {
        starValue = 5;
    }
    [self updatingStars:starValue];
}
- (void)updatingStars:(NSInteger)value{
    switch (value) {
        case 0:
            [star1 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star2 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star3 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [star1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star2 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star3 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [star1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star3 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [star1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star3 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star4 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            [star5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [star1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star3 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star4 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star5 setImage:[UIImage imageNamed:@"blank_star.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [star1 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star2 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star3 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star4 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            [star5 setImage:[UIImage imageNamed:@"fill_star.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
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
