//
//  CateringCheckOutViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "CateringCheckOutViewController.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"

@interface CateringCheckOutViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextViewDelegate>{
    NSInteger paymentMethod;
    NSArray *arrDate;
    NSMutableArray *AllSavedAddress;
    NSString *selectedAddressId;
    
    NSString *scheduleDate;
    NSString *scheduleTime;
}

@end

@implementation CateringCheckOutViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 220.0f)];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    paymentMethod = 1;
    btnCheckCash.selected = YES;
    updateDateTimeView.hidden = YES;
    lblTotal.text = _total;
    lblDiscount.text = _discount;
    lblDeliveryCharges.text = _deliveryCharges;
    lblGrandTotal.text = _grandTotal;
    lblRestroName.text = _selectedRestroName;
    CateringAddressLocationTableView.hidden = YES;
    
    NSDate *myDate = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    arrDate = [prettyVersion componentsSeparatedByString:@","];
    lblTimeFor.text = arrDate[2];
    lblDayOfWeek.text = arrDate[0];
    lblDateFor.text = arrDate[1];
    btnDateForPlain.selected = YES;
    
    [dateFormat setDateFormat:@"yyyy-MM-dd,hh:mm"];
    NSArray *sendDate = [[dateFormat stringFromDate:myDate] componentsSeparatedByString:@","];
    scheduleDate = sendDate[0];
    scheduleTime = sendDate[1];
    
    AllSavedAddress = [[NSMutableArray alloc] init];
    lblMobileNumber.text = APPDELEGATE.mobilePhoneNum;
    
    txtViewDirection.text = @"Please enter extra direction";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getSavedAddress];
}
- (void)getSavedAddress{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetUserAddress:APPDELEGATE.access_token successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            AllSavedAddress = [_responseObject objectForKey:@"resource"];
            selectedAddressId = @"";
            if ([AllSavedAddress count] > 0) {
                NSString *selectedCityId = [AllSavedAddress[0] objectForKey:@"city_id"];
                NSString *selectedAreaId = [AllSavedAddress[0] objectForKey:@"area_id"];
                NSString *fullcity = @"";
                NSString *fullarea = @"";
                [btnSavedAddressName setTitle:[AllSavedAddress[0] objectForKey:@"address_name"] forState:UIControlStateNormal];
                for (int i = 0 ; i < [APPDELEGATE.lstCityIds count]; i ++)
                {
                    NSArray *areaIdsArray = [APPDELEGATE.lstCityIds objectAtIndex:i];
                    NSArray *areaNamesArray = [APPDELEGATE.lstCity objectAtIndex:i];
                    for (int j = 0; j < [areaIdsArray count]; j ++) {
                        if (j == 0) {
                            if ([selectedCityId isEqualToString:[areaIdsArray objectAtIndex:0]]) {
                                fullcity = [areaNamesArray objectAtIndex:0];
                            }
                        }else{
                            if ([selectedAreaId isEqualToString:[areaIdsArray objectAtIndex:j]]) {
                                fullarea = [areaNamesArray objectAtIndex:j];
                            }
                        }
                    }
                }
                lblArea.text = [NSString stringWithFormat:@"%@ %@", fullcity, fullarea];
                lblStreet.text = [AllSavedAddress[0] objectForKey:@"street"];
                lblBlock.text = [AllSavedAddress[0] objectForKey:@"block"];
                lblBuilding.text = [AllSavedAddress[0] objectForKey:@"house"];
                lblFloor.text = [AllSavedAddress[0] objectForKey:@"floor"];
                lblAppartment.text = [AllSavedAddress[0] objectForKey:@"appartment"];
                selectedAddressId = [AllSavedAddress[0] objectForKey:@"id"];
            }
            [self updateTableViewHeight];
            [CateringAddressLocationTableView reloadData];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(void)handleTap
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onAddressEdit:(id)sender {
}

- (IBAction)onSavedAddressName:(id)sender {
    if (CateringAddressLocationTableView.hidden == NO) {
        CateringAddressLocationTableView.hidden = YES;
    }
    CateringAddressLocationTableView.hidden = NO;
}

- (IBAction)onCheckCash:(id)sender {
    btnCheckCash.selected = !btnCheckCash.selected;
    if (btnCheckCash.selected == YES) {
        paymentMethod = 1;
        btnCheckKnet.selected = NO;
        btnCheckCreditCard.selected = NO;
    }
}

- (IBAction)onCheckKnet:(id)sender {
    btnCheckKnet.selected = !btnCheckKnet.selected;
    if (btnCheckKnet.selected == YES) {
        paymentMethod = 2;
        btnCheckCash.selected = NO;
        btnCheckCreditCard.selected = NO;
    }
}

- (IBAction)onCheckCreditCard:(id)sender {
    btnCheckCreditCard.selected = !btnCheckCreditCard.selected;
    if (btnCheckCreditCard.selected == YES) {
        paymentMethod = 3;
        btnCheckCash.selected = NO;
        btnCheckKnet.selected = NO;
    }
}

- (IBAction)onCheckOut:(id)sender {
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] SetOrders:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType areaId:[_areaId integerValue] restroId:[_restroId integerValue] locationId:[_locationId integerValue] redeemType:_redeemType couponCode:_couponCode scheduleDate:scheduleDate scheduleTime:scheduleTime paymentMethod:paymentMethod addressId:[selectedAddressId integerValue] extraDirection:txtViewDirection.text successed:successed failure:failure];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onViewDateTime:(id)sender {
    updateDateTimeView.hidden = NO;
}

- (IBAction)onViewDateTimeClose:(id)sender {
    updateDateTimeView.hidden = YES;
}

- (IBAction)onUpdateDateTime:(id)sender {
    updateDateTimeView.hidden = YES;
    NSDate *myDate = dateTimePick.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    arrDate = [prettyVersion componentsSeparatedByString:@","];
    lblTimeFor.text = arrDate[2];
    lblDayOfWeek.text = arrDate[0];
    lblDateFor.text = arrDate[1];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd,hh:mm"];
    NSArray *sendDate = [[dateFormat stringFromDate:myDate] componentsSeparatedByString:@","];
    scheduleDate = sendDate[0];
    scheduleTime = sendDate[1];
}

- (IBAction)onCheckDatetime:(id)sender {
    btnDateForPlain.selected = !btnDateForPlain.selected;
}
- (void)updateTableViewHeight{
    NSLog(@"%f", CateringAddressLocationTableView.frame.origin.x);
    [CateringAddressLocationTableView setFrame:CGRectMake(CateringAddressLocationTableView.frame.origin.x, CateringAddressLocationTableView.frame.origin.y, CateringAddressLocationTableView.frame.size.width, [AllSavedAddress count] * 20.0f)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [AllSavedAddress count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"AddressNameItem";
    UITableViewCell *cell = [CateringAddressLocationTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"address_name"];
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"jella");
    [btnSavedAddressName setTitle:[[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"address_name"] forState:UIControlStateNormal];
    CateringAddressLocationTableView.hidden = YES;
    selectedAddressId = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSLog(@"seelctedAddressid : %@", selectedAddressId);
    
    NSString *selectedCityId = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"city_id"];
    NSString *selectedAreaId = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"area_id"];
    NSString *fullcity = @"";
    NSString *fullarea = @"";
    [btnSavedAddressName setTitle:[[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"address_name"] forState:UIControlStateNormal];
    for (int i = 0 ; i < [APPDELEGATE.lstCityIds count]; i ++)
    {
        NSArray *areaIdsArray = [APPDELEGATE.lstCityIds objectAtIndex:i];
        NSArray *areaNamesArray = [APPDELEGATE.lstCity objectAtIndex:i];
        for (int j = 0; j < [areaIdsArray count]; j ++) {
            if (j == 0) {
                if ([selectedCityId isEqualToString:[areaIdsArray objectAtIndex:0]]) {
                    fullcity = [areaNamesArray objectAtIndex:0];
                }
            }else{
                if ([selectedAreaId isEqualToString:[areaIdsArray objectAtIndex:j]]) {
                    fullarea = [areaNamesArray objectAtIndex:j];
                }
            }
        }
    }
    lblArea.text = [NSString stringWithFormat:@"%@ %@", fullcity, fullarea];
    lblStreet.text = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"street"];
    lblBlock.text = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"block"];
    lblBuilding.text = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"house"];
    lblFloor.text = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"floor"];
    lblAppartment.text = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"appartment"];
    selectedAddressId = [[AllSavedAddress objectAtIndex:indexPath.row] objectForKey:@"id"];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    if([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCell
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
    if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView isEqual:txtViewDirection]) {
        if ([txtViewDirection.text isEqualToString:@"Please enter extra direction"]) {
            txtViewDirection.text = @"";
        }
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView isEqual:txtViewDirection]) {
        if ([txtViewDirection.text isEqualToString:@""]) {
            txtViewDirection.text = @"Please enter extra direction";
        }
    }
    return YES;
}
@end
