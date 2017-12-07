//
//  SettingAddressViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/16/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SettingAddressViewController.h"

@interface SettingAddressViewController ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{
    NSMutableArray *arrAddresNames;
    NSString *selectedCityId;
    NSString *selectedAreaId;
    NSString *selectedAddressId;
    
    NSMutableArray *cities;
    NSMutableArray *areas;
    
    NSMutableArray *AllSavedAddress;
    BOOL isNewAddress;
    
    BOOL isSelectedCity;
}

@end

@implementation SettingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    showKeyboard = NO;
    CityAreaView.hidden = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [scrView addGestureRecognizer:gesture];
    arrAddresNames = [[NSMutableArray alloc] init];
    cities = [[NSMutableArray alloc] init];
    areas = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [APPDELEGATE.lstCityIds count]; i ++) {
        NSArray *oneAreaIds = [APPDELEGATE.lstCityIds objectAtIndex:i];
        NSArray *oneAreaNames = [APPDELEGATE.lstCity objectAtIndex:i];
        NSMutableDictionary *madeOneCity = [[NSMutableDictionary alloc] init];
        [madeOneCity setObject:[oneAreaNames objectAtIndex:0] forKey:@"city_name"];
        [madeOneCity setObject:[oneAreaIds objectAtIndex:0] forKey:@"city_id"];
        [cities addObject:madeOneCity];
    }
    
    [AreaSelectedTableView reloadData];
    lblCityArea.text = @"City";
    isSelectedCity = YES;
    isNewAddress = NO;
    
    selectedCityId = @"";
    selectedAreaId = @"";
    selectedAddressId = @"";
    
    AllSavedAddress = [[NSMutableArray alloc] init];
    
    if (_addressInfo) {
        [btnSave setTitle:@"UPDATE" forState:UIControlStateNormal];
        txtAddressName.text = [_addressInfo objectForKey:@"address_name"];
        selectedCityId = [_addressInfo objectForKey:@"city_id"];
        selectedAreaId = [_addressInfo objectForKey:@"area_id"];
        for (int i = 0 ; i < [APPDELEGATE.lstCityIds count]; i ++)
        {
            NSArray *areaIdsArray = [APPDELEGATE.lstCityIds objectAtIndex:i];
            NSArray *areaNamesArray = [APPDELEGATE.lstCity objectAtIndex:i];
            for (int j = 0; j < [areaIdsArray count]; j ++) {
                if (j == 0) {
                    if ([selectedCityId isEqualToString:[areaIdsArray objectAtIndex:0]]) {
                        txtCityName.text = [areaNamesArray objectAtIndex:0];
                    }
                }else{
                    if ([selectedAreaId isEqualToString:[areaIdsArray objectAtIndex:j]]) {
                        txtAreaName.text = [areaNamesArray objectAtIndex:j];
                    }
                }
            }
        }
        txtStreetName.text = [_addressInfo objectForKey:@"street"];
        txtBlock.text = [_addressInfo objectForKey:@"block"];
        txtHouse.text = [_addressInfo objectForKey:@"house"];
        txtFloor.text = [_addressInfo objectForKey:@"floor"];
        txtApart.text = [_addressInfo objectForKey:@"appartment"];
        txtDirection.text = [_addressInfo objectForKey:@"extra_directions"];
        selectedAddressId = [_addressInfo objectForKey:@"id"];
    }else{
        [btnSave setTitle:@"SAVE" forState:UIControlStateNormal];
    };
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (!showKeyboard)
    {
        showKeyboard = YES;
        [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f)];
        //        if (IS_IPHONE_5) {
        //            [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
        //        } else [srcView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtAddressName)
    {
        [txtStreetName becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (textField == txtCityName)
    {
        [txtAreaName becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == txtAreaName)
    {
        [txtStreetName becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == txtStreetName)
    {
        [txtBlock becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == txtBlock)
    {
        [txtHouse becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == txtHouse)
    {
        [txtFloor becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 20) animated:YES];
    }else if (textField == txtFloor)
    {
        [txtApart becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 50) animated:YES];
    }else if (textField == txtApart)
    {
        [txtDirection becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 160) animated:YES];
    }
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == txtDirection)
    {
        [scrView setContentOffset:CGPointMake(0, 160) animated:YES];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtFloor)
    {
        [scrView setContentOffset:CGPointMake(0, 20) animated:YES];
    }else if (textField == txtApart)
    {
        [scrView setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    return YES;
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
    [self.view endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSLog(@"%@", _responseObject);
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }else{
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
        
    };
    
    [[Communication sharedManager] SaveUserAddress:APPDELEGATE.access_token addressId:selectedAddressId addressName:txtAddressName.text cityId:selectedCityId areaId:selectedAreaId street:txtStreetName.text block:txtBlock.text house:txtHouse.text floor:txtFloor.text appartment:txtApart.text extraDirections:txtDirection.text successed:successed failure:failure];
}

- (IBAction)onCityNames:(id)sender {
    [self.view endEditing:YES];
    CityAreaView.hidden = NO;
    isSelectedCity = YES;
    lblCityArea.text = @"City";
    [AreaSelectedTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if ([tableView isEqual:AddressNameTableview]) {
//        return [arrAddresNames count];
//    }else
    if (isSelectedCity) {
        return [cities count];
    }else{
        return [areas count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([tableView isEqual:AddressNameTableview]) {
//        static NSString *simpleTableIdentifier = @"AddressNameItem";
//        UITableViewCell *cell = [AddressNameTableview dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//        }
//        cell.textLabel.text = [[arrAddresNames objectAtIndex:indexPath.row] objectForKey:@"address_name"];
//        cell.backgroundColor = [UIColor clearColor];
//        [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
//        return cell;
//    }else
    
    static NSString *simpleTableIdentifier = @"CityNameItem";
    UITableViewCell *cell = [AreaSelectedTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
   if (isSelectedCity) {
        cell.textLabel.text = [[cities objectAtIndex:indexPath.row] objectForKey:@"city_name"];
        cell.backgroundColor = [UIColor clearColor];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        return cell;
    }else{
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = [[areas objectAtIndex:indexPath.row] objectForKey:@"area_name"];
        cell.backgroundColor = [UIColor clearColor];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"jella");
//    if ([tableView isEqual:AddressNameTableview]) {
//        txtAddressName.text = [[arrAddresNames objectAtIndex:indexPath.row] objectForKey:@"address_name"];
//        AddressNameTableview.hidden = YES;
//        selectedAddressId = [[arrAddresNames objectAtIndex:indexPath.row] objectForKey:@"id"];
//        NSLog(@"seelctedAddressid : %@", selectedAddressId);
//        [self realodScreenViewForAddress:[[arrAddresNames objectAtIndex:indexPath.row] objectForKey:@"id"]];
//    }else
    
    if (isSelectedCity) {
        [areas removeAllObjects];
        txtCityName.text = [[cities objectAtIndex:indexPath.row] objectForKey:@"city_name"];
        selectedCityId = [[cities objectAtIndex:indexPath.row] objectForKey:@"city_id"];
        
        for (int i = 0 ; i < [APPDELEGATE.lstCityIds count]; i ++) {
            NSArray *oneAreaNames = [APPDELEGATE.lstCity objectAtIndex:i];
            NSArray *oneAreaIds = [APPDELEGATE.lstCityIds objectAtIndex:i];
            if ([selectedCityId isEqualToString:[oneAreaIds objectAtIndex:0]]) {
                for (int j = 1 ; j < [oneAreaNames count]; j ++) {
                    NSMutableDictionary *madeOneArea = [[NSMutableDictionary alloc] init];
                    [madeOneArea setObject:[oneAreaNames objectAtIndex:j] forKey:@"area_name"];
                    [madeOneArea setObject:[oneAreaIds objectAtIndex:j] forKey:@"area_id"];
                    [areas addObject:madeOneArea];
                }
            }
        }
        CityAreaView.hidden = YES;
        [AreaSelectedTableView reloadData];
        
    }else{
        CityAreaView.hidden = YES;
        txtAreaName.text = [[areas objectAtIndex:indexPath.row] objectForKey:@"area_name"];
        selectedAreaId = [[areas objectAtIndex:indexPath.row] objectForKey:@"area_id"];
    }
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
- (void) realodScreenViewForAddress:(NSString *)addressId{
    if ([addressId integerValue] == 0) {
        txtAddressName.placeholder = @"Enter sub Address Name.";
        txtAddressName.text = @"";
        txtCityName.text = @"";
        txtAreaName.text = @"";
        txtStreetName.text = @"";
        txtBlock.text = @"";
        txtHouse.text = @"";
        txtFloor.text = @"";
        txtApart.text = @"";
        txtDirection.text = @"";
        selectedCityId = @"";
        selectedAreaId = @"";
    }else{
        for (int k = 0 ; k < [AllSavedAddress count]; k ++) {
            NSDictionary *dictAddress = [AllSavedAddress objectAtIndex:k];
            if ([[dictAddress objectForKey:@"id"] isEqualToString:addressId]) {
                txtAddressName.text = [dictAddress objectForKey:@"address_name"];
                
                selectedCityId = [dictAddress objectForKey:@"city_id"];
                selectedAreaId = [dictAddress objectForKey:@"area_id"];
                for (int i = 0 ; i < [APPDELEGATE.lstCityIds count]; i ++)
                {
                    NSArray *areaIdsArray = [APPDELEGATE.lstCityIds objectAtIndex:i];
                    NSArray *areaNamesArray = [APPDELEGATE.lstCity objectAtIndex:i];
                    for (int j = 0; j < [areaIdsArray count]; j ++) {
                        if (j == 0) {
                            if ([selectedCityId isEqualToString:[areaIdsArray objectAtIndex:0]]) {
                                txtCityName.text = [areaNamesArray objectAtIndex:0];
                            }
                        }else{
                            if ([selectedAreaId isEqualToString:[areaIdsArray objectAtIndex:j]]) {
                                txtAreaName.text = [areaNamesArray objectAtIndex:j];
                            }
                        }
                    }
                }
                txtStreetName.text = [dictAddress objectForKey:@"street"];
                txtBlock.text = [dictAddress objectForKey:@"block"];
                txtHouse.text = [dictAddress objectForKey:@"house"];
                txtFloor.text = [dictAddress objectForKey:@"floor"];
                txtApart.text = [dictAddress objectForKey:@"appartment"];
                txtDirection.text = [dictAddress objectForKey:@"extra_directions"];
                selectedAddressId = [dictAddress objectForKey:@"id"];
            }
        }
    }
    
}
- (IBAction)onAreaName:(id)sender {
    [self.view endEditing:YES];
    CityAreaView.hidden = NO;
    lblCityArea.text = @"Area";
    isSelectedCity = NO;
    [AreaSelectedTableView reloadData];
}

- (IBAction)onCityAreaViewClose:(id)sender {
    CityAreaView.hidden= YES;
}
@end
