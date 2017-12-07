//
//  SelectedReservationResViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SelectedReservationResViewController.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "LocationCell.h"
@interface SelectedReservationResViewController (){
    NSString *timeForSlots;
    NSString *selectedSlot;
}
@end

@implementation SelectedReservationResViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    reservationsEditView.hidden = YES;
    lblRestroName.text = [_selectedRestroDict objectForKey:@"restro_name"];
    lblPersions.text = _persionsNumber;
    lblReservationDate.text = _dateForReservation;
    lblReservationTime.text = _timeForReservation;
    
    timeForSlots = _dateForReserveTimes;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    [self getRestroInfos];
    [self getTimes];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getRestroInfos{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dict = [_responseObject objectForKey:@"resource"];
            if (![[dict objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]])
            {
                NSArray *arrForUrl = [[dict objectForKey:@"restro_logo"] componentsSeparatedByString:@"/"];
                NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
                [logoImage setImageWithURL:[NSURL URLWithString:logoUrl]];
            }
            lblWorkingTiemForWeekend.text = [NSString stringWithFormat:@"Sat-Sun: %@-%@",[dict objectForKey:@"saturday_from"], [dict objectForKey:@"saturday_to"]];
            
            lblWorkingTimeForDays.text = [NSString stringWithFormat:@"Mon-Fri: %@-%@",[dict objectForKey:@"monday_from"], [dict objectForKey:@"monday_to"]];
            lblDetailsForRes.text = [dict objectForKey:@"restro_description"];
            if ([[dict objectForKey:@"reviews"] count] > 0) {
                NSInteger sum = 0;
                for (NSDictionary *rateDict in [dict objectForKey:@"reviews"]) {
                    sum = sum + [[rateDict objectForKey:@"star_value"] integerValue];
                }
                [ratingImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%d", (int)roundf(sum/[[dict objectForKey:@"reviews"] count])]]];
            }else{
                [ratingImage setImage:[UIImage imageNamed:@"rating_0"]];
            }
            [btnLocation setTitle:[dict objectForKey:@"location_name"] forState:UIControlStateNormal];
            lblAddressForReservation.text = [NSString stringWithFormat:@"Address:%@, %@ %@",[dict objectForKey:@"street"], [dict objectForKey:@"block"], [dict objectForKey:@"building"]];
            lblPhoneNumberFor.text = [NSString stringWithFormat:@"Phone: %@", [dict objectForKey:@"telephones"]];
            
            //[self getAddress];
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
    
    [[Communication sharedManager] GetRestaurantInfos:APPDELEGATE.access_token restroId:[[_selectedRestroDict objectForKey:@"restro_id"] integerValue] locationId:[[_selectedRestroDict objectForKey:@"location_id"] integerValue] serviceType:APPDELEGATE.serviceType successed:successed failure:failure];
}
- (void)getTimes{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            if (![[[_responseObject objectForKey:@"resource"] objectForKey:@"slots"] isKindOfClass:[NSNull class]]) {
                NSArray *arr = [[_responseObject objectForKey:@"resource"] objectForKey:@"slots"];
                
                timeSlot1.text = [[arr objectAtIndex:0] objectForKey:@"time"];
                timeSlot2.text = [[arr objectAtIndex:1] objectForKey:@"time"];
                timeSlot3.text = [[arr objectAtIndex:2] objectForKey:@"time"];
                timeSlot4.text = [[arr objectAtIndex:3] objectForKey:@"time"];
                timeslot5.text = [[arr objectAtIndex:4] objectForKey:@"time"];
                
                if ([[[arr objectAtIndex:0] objectForKey:@"available"] boolValue]) {
                    btnTimeSlot1.enabled =  YES;
                }else{
                    btnTimeSlot1.enabled =  NO;
                }
                if ([[[arr objectAtIndex:1] objectForKey:@"available"] boolValue]) {
                    btnTimeSlot2.enabled =  YES;
                }else{
                    btnTimeSlot2.enabled =  NO;
                }
                if ([[[arr objectAtIndex:2] objectForKey:@"available"] boolValue]) {
                    btnTimeSlot3.enabled =  YES;
                }else{
                    btnTimeSlot3.enabled =  NO;
                }
                if ([[[arr objectAtIndex:3] objectForKey:@"available"] boolValue]) {
                    btnTimeSlot4.enabled =  YES;
                }else{
                    btnTimeSlot4.enabled =  NO;
                }
                if ([[[arr objectAtIndex:4] objectForKey:@"available"] boolValue]) {
                    btnTimeSlot5.enabled =  YES;
                }else{
                    btnTimeSlot5.enabled =  NO;
                }
                switch (_slotIndex) {
                    case 0:
                        btnTimeSlot1.selected = YES;
                        btnTimeSlot2.selected = NO;
                        btnTimeSlot3.selected = NO;
                        btnTimeSlot4.selected = NO;
                        btnTimeSlot5.selected = NO;
                        selectedSlot = timeSlot1.text;
                        break;
                    case 1:
                        btnTimeSlot1.selected = YES;
                        btnTimeSlot2.selected = NO;
                        btnTimeSlot3.selected = NO;
                        btnTimeSlot4.selected = NO;
                        btnTimeSlot5.selected = NO;
                        selectedSlot = timeSlot1.text;
                        break;
                    case 2:
                        btnTimeSlot1.selected = NO;
                        btnTimeSlot2.selected = YES;
                        btnTimeSlot3.selected = NO;
                        btnTimeSlot4.selected = NO;
                        btnTimeSlot5.selected = NO;
                        selectedSlot = timeSlot2.text;
                        break;
                    case 3:
                        btnTimeSlot1.selected = NO;
                        btnTimeSlot2.selected = NO;
                        btnTimeSlot3.selected = YES;
                        btnTimeSlot4.selected = NO;
                        btnTimeSlot5.selected = NO;
                        selectedSlot = timeSlot3.text;
                        break;
                    case 4:
                        btnTimeSlot1.selected = NO;
                        btnTimeSlot2.selected = NO;
                        btnTimeSlot3.selected = NO;
                        btnTimeSlot4.selected = YES;
                        btnTimeSlot5.selected = NO;
                        selectedSlot = timeSlot4.text;
                        break;
                    case 5:
                        btnTimeSlot1.selected = NO;
                        btnTimeSlot2.selected = NO;
                        btnTimeSlot3.selected = NO;
                        btnTimeSlot4.selected = NO;
                        btnTimeSlot5.selected = YES;
                        selectedSlot = timeslot5.text;
                        break;
                    default:
                        break;
                }
            }else{
                btnTimeSlot1.enabled =  NO;
                btnTimeSlot2.enabled =  NO;
                btnTimeSlot3.enabled =  NO;
                btnTimeSlot4.enabled =  NO;
                btnTimeSlot5.enabled =  NO;
                [self showAlert:@"Please contact Admin." :@"Error"];
            }
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    NSString *reserveTime = [[timeForSlots stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    [[Communication sharedManager] GetOrdersTimes:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:[[_selectedRestroDict objectForKey:@"restro_id"] integerValue] locationId:[[_selectedRestroDict objectForKey:@"location_id"] integerValue] reserveTime:reserveTime peopleNumber:[_persionsNumber integerValue] successed:successed failure:failure];
    
    //_dateForReserveTimes
}
//- (void)getAddress{
//    [[Communication sharedManager] GetUserAddress:APPDELEGATE.access_token successed:^(id _responseObject) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//        if ([_responseObject[@"code"] integerValue] == 0) {
//            locationsForRes = [_responseObject objectForKey:@"resource"];
//            selectedAddressId = @"";
//            if ([locationsForRes count] > 0) {
//                NSString *selectedCityId = [locationsForRes[0] objectForKey:@"city_id"];
//                NSString *selectedAreaId = [locationsForRes[0] objectForKey:@"area_id"];
//                NSString *fullcity = @"";
//                NSString *fullarea = @"";
//                [btnLocation setTitle:[locationsForRes[0] objectForKey:@"address_name"] forState:UIControlStateNormal];
//                for (int i = 0 ; i < [APPDELEGATE.lstCityIds count]; i ++)
//                {
//                    NSArray *areaIdsArray = [APPDELEGATE.lstCityIds objectAtIndex:i];
//                    NSArray *areaNamesArray = [APPDELEGATE.lstCity objectAtIndex:i];
//                    for (int j = 0; j < [areaIdsArray count]; j ++) {
//                        if (j == 0) {
//                            if ([selectedCityId isEqualToString:[areaIdsArray objectAtIndex:0]]) {
//                                fullcity = [areaNamesArray objectAtIndex:0];
//                            }
//                        }else{
//                            if ([selectedAreaId isEqualToString:[areaIdsArray objectAtIndex:j]]) {
//                                fullarea = [areaNamesArray objectAtIndex:j];
//                            }
//                        }
//                    }
//                }
//                lblAddressForReservation.text = [NSString stringWithFormat:@"Address:%@, %@ %@",[locationsForRes[0] objectForKey:@"street"],[locationsForRes[0] objectForKey:@"block"], [locationsForRes[0] objectForKey:@"house"]];
//                selectedAddressId = [locationsForRes[0] objectForKey:@"id"];
//                lblPhoneNumberFor.text = [NSString stringWithFormat:@"Phone: %@", APPDELEGATE.mobilePhoneNum];
//            }
//            
//        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [self showAlert:_responseObject[@"message"] :@"Login Error"];
//        }
//    } failure:^(NSError *_error) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//    }];
//}

-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onSelectedTime:(id)sender {
    if ([sender isEqual:btnTimeSlot1]) {
        btnTimeSlot1.selected = !btnTimeSlot1.selected;
        if (btnTimeSlot1.selected == YES) {
            selectedSlot = timeSlot1.text;
            btnTimeSlot2.selected = NO;
            btnTimeSlot3.selected = NO;
            btnTimeSlot4.selected = NO;
            btnTimeSlot5.selected = NO;
        }
    }else if ([sender isEqual:btnTimeSlot2]) {
        btnTimeSlot2.selected = !btnTimeSlot2.selected;
        if (btnTimeSlot2.selected == YES) {
            selectedSlot = timeSlot2.text;
            btnTimeSlot1.selected = NO;
            btnTimeSlot3.selected = NO;
            btnTimeSlot4.selected = NO;
            btnTimeSlot5.selected = NO;
        }
    }else if ([sender isEqual:btnTimeSlot3]) {
        btnTimeSlot3.selected = !btnTimeSlot3.selected;
        if (btnTimeSlot3.selected == YES) {
            selectedSlot = timeSlot3.text;
            btnTimeSlot1.selected = NO;
            btnTimeSlot2.selected = NO;
            btnTimeSlot4.selected = NO;
            btnTimeSlot5.selected = NO;
        }
    }else if ([sender isEqual:btnTimeSlot4]) {
        btnTimeSlot4.selected = !btnTimeSlot4.selected;
        if (btnTimeSlot4.selected == YES) {
            selectedSlot = timeSlot4.text;
            btnTimeSlot1.selected = NO;
            btnTimeSlot2.selected = NO;
            btnTimeSlot3.selected = NO;
            btnTimeSlot5.selected = NO;
        }
    }else if ([sender isEqual:btnTimeSlot5]) {
        btnTimeSlot5.selected = !btnTimeSlot5.selected;
        if (btnTimeSlot5.selected == YES) {
            selectedSlot = timeslot5.text;
            btnTimeSlot1.selected = NO;
            btnTimeSlot2.selected = NO;
            btnTimeSlot3.selected = NO;
            btnTimeSlot4.selected = NO;
        }
    }
}

- (IBAction)onLocationForReservation:(id)sender {
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMakeReservation:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            
            [[AppDelegate sharedDelegate] goToMainView];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    NSArray *timeForMakeingReserve = [timeForSlots componentsSeparatedByString:@" "];
    
    NSArray *fixPreTime = [selectedSlot componentsSeparatedByString:@":"];
    NSLog(@"%ld:%@", (long)[fixPreTime[0] integerValue], fixPreTime[1]);
    NSString *fixTime = [NSString stringWithFormat:@"%ld:%@", (long)[fixPreTime[0] integerValue], fixPreTime[1]];

    [[Communication sharedManager] SetOrdersReserve:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:[[_selectedRestroDict objectForKey:@"restro_id"] integerValue] locationId:[[_selectedRestroDict objectForKey:@"location_id"] integerValue] reserveDate:timeForMakeingReserve[0] reserveTime:fixTime peopleNumber:[_persionsNumber integerValue] successed:successed failure:failure];
}

- (IBAction)onReservationsEditViewClose:(id)sender {
    reservationsEditView.hidden = YES;
}

- (IBAction)onReservationUpdate:(id)sender {
    reservationsEditView.hidden = YES;
    lblPersions.text = lblnumer.text;
    NSDate *myDate = updateDatePick.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d yyyy, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    NSArray *arrDate = [prettyVersion componentsSeparatedByString:@","];
    lblReservationDate.text = arrDate[0];
    lblReservationTime.text = arrDate[1];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    timeForSlots = [dateFormat stringFromDate:myDate];
    [self getTimes];
}

- (IBAction)onMinusPsersons:(id)sender {
    if ([_persionsNumber integerValue] < 1) {
        lblnumer.text =[NSString stringWithFormat:@"%d",1];
    }
    NSInteger count = [lblnumer.text integerValue];
    count --;
    lblnumer.text =[NSString stringWithFormat:@"%ld",(long)count];
    _persionsNumber = [NSString stringWithFormat:@"%ld",(long)count];
}
    - (IBAction)onPlusPersons:(id)sender {
        NSInteger count = [lblnumer.text integerValue];
        count ++;
        lblnumer.text =[NSString stringWithFormat:@"%ld",(long)count];
        _persionsNumber = [NSString stringWithFormat:@"%ld",(long)count];
}

- (IBAction)onEdit:(id)sender {
    reservationsEditView.hidden = NO;
    lblnumer.text = _persionsNumber;
//    NSDateFormatter *formatter;
//    formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"cccc MMM d h:mm a"];
//    
//    NSDate *date=[formatter dateFromString:[NSString stringWithFormat:@"%@ %@", _dateForReservation, _timeForReservation]];
//    [updateDatePick setDate:date];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.view endEditing:NO];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *dict = [locationsForRes objectAtIndex:indexPath.row];
//    [btnLocation setTitle:[dict objectForKey:@"address_name"] forState:UIControlStateNormal];
//    lblAddressForReservation.text = [NSString stringWithFormat:@"Address:%@, %@ %@",[dict objectForKey:@"street"],[dict objectForKey:@"block"], [dict objectForKey:@"house"]];
//    lblPhoneNumberFor.text = [NSString stringWithFormat:@"Phone: %@", APPDELEGATE.mobilePhoneNum];
//    selectedAddressId = [dict objectForKey:@"id"];
//    
//}
@end
