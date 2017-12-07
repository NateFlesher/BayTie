//
//  PickUpCheckOutViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "PickUpCheckOutViewController.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "PickupAddressCell.h"

@interface PickUpCheckOutViewController (){
    NSInteger paymentMethod;
    NSArray *arrDate;
    
    NSMutableArray *pickupLocationsArray;
    NSString *selectedAddressId;
    
    NSString *scheduleDate;
    NSString *scheduleTime;
}

@end

@implementation PickUpCheckOutViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view from its nib.
    //[scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 200.0f)];
    paymentMethod = 1;
    btnCheckCash.selected = YES;
    updateDateView.hidden = YES;
    lblTotal.text = _total;
    lbldiscount.text = _discount;
    lblGrandTotal.text = _grandTotal;
    
    pickupLocationsArray = [[NSMutableArray alloc] init];
    NSDate *myDate = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    arrDate = [prettyVersion componentsSeparatedByString:@","];
    lblTimeToPlan.text = arrDate[2];
    lblDayOfWeekToPlan.text = arrDate[0];
    lblDateToPlan.text = arrDate[1];
    btnCheckDateTime.selected = YES;
    lblselectedRestroName.text = _selectedRestroName;
    
    [dateFormat setDateFormat:@"yyyy-MM-dd,hh:mm"];
    NSArray *sendDate = [[dateFormat stringFromDate:myDate] componentsSeparatedByString:@","];
    scheduleDate = sendDate[0];
    scheduleTime = sendDate[1];
    
    selectedAddressId = @"";
    

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getRestroInfos];
}
- (void)getRestroInfos{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
                NSDictionary *dict = [_responseObject objectForKey:@"resource"];
                [btnChoosePickUpAddress setTitle:[dict objectForKey:@"location_name"] forState:UIControlStateNormal];
                lblAddressForPickup.text = [NSString stringWithFormat:@"Address:%@, %@ %@",[dict objectForKey:@"street"],[dict objectForKey:@"block"], [dict objectForKey:@"building"]];
            lblPhoneNumForPickup.text = [NSString stringWithFormat:@"Phone : %@", [dict objectForKey:@"telephones"]];
                selectedAddressId = [dict objectForKey:@"location_id"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onUpdateDateViewClose:(id)sender {
    updateDateView.hidden = YES;
}

- (IBAction)onUpdateDateTime:(id)sender {
    updateDateView.hidden = YES;
    NSDate *myDate = dateTimePick.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    arrDate = [prettyVersion componentsSeparatedByString:@","];
    lblTimeToPlan.text = arrDate[2];
    lblDayOfWeekToPlan.text = arrDate[0];
    lblDateToPlan.text = arrDate[1];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd,hh:mm"];
    NSArray *sendDate = [[dateFormat stringFromDate:myDate] componentsSeparatedByString:@","];
    scheduleDate = sendDate[0];
    scheduleTime = sendDate[1];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [[Communication sharedManager] SetOrders:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType areaId:[_areaId integerValue] restroId:[_restroId integerValue] locationId:[_locationId integerValue] redeemType:_redeemType couponCode:_couponCode scheduleDate:scheduleDate scheduleTime:scheduleTime paymentMethod:paymentMethod addressId:[selectedAddressId integerValue] extraDirection:@"" successed:successed failure:failure];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onAddressEdit:(id)sender {
}

- (IBAction)onSavedAddressName:(id)sender {
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
        btnCheckCreditCard.selected = NO;
        btnCheckCash.selected = NO;
    }
}

- (IBAction)onCheckCreditCard:(id)sender {
    btnCheckCreditCard.selected = !btnCheckCreditCard.selected;
    if (btnCheckCreditCard.selected == YES) {
        paymentMethod = 3;
        btnCheckKnet.selected = NO;
        btnCheckCash.selected = NO;
    }
}

- (IBAction)onCheckPayPal:(id)sender {
    btnCheckPayPal.selected = !btnCheckPayPal.selected;
}

- (IBAction)onBtnCheckDateTime:(id)sender {
    btnCheckDateTime.selected = !btnCheckDateTime.selected;
}

- (IBAction)onvDateTimeView:(id)sender {
    updateDateView.hidden = NO;
}

@end
