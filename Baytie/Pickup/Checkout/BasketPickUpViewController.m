//
//  BasketPickUpViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "BasketPickUpViewController.h"
#import "MainMenuViewController.h"
#import "PickUpCheckOutViewController.h"
#import "FoodItemForDeliveryCell.h"
#import "ValItemCell.h"
#import "CatergoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "SelectedPickupResViewController.h"
#import "ValItemCell.h"

@interface BasketPickUpViewController ()<UITextFieldDelegate, UITextViewDelegate,FoodItemForDeliveryCellDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *arrPickupItems;
    
    NSDictionary *currentItemDictToEdit;
    
    NSInteger amount;
    NSMutableArray *arrCategories;
    NSMutableDictionary *currentSelectedVar;
    
    NSMutableArray * selectedVars;
    
    NSInteger redeemType;
    
    CGFloat totalPrice;
    CGFloat discountPrice;
    CGFloat chargesPrice;
    CGFloat allPrice;
    CGFloat origingalPrice;
    BOOL isVar;
}


@end

@implementation BasketPickUpViewController
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
    //editItemView.hidden = YES;
    itemEditScrolView.hidden = YES;
    [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 64.0f)];
    
    
    totalPrice = 0;
    discountPrice = 0;
    chargesPrice = 0;
    
    allPrice = 0;
    showKeyboard = NO;
    redeemType = 0;
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    arrPickupItems = [[NSMutableArray alloc] init];
    arrCategories = [[NSMutableArray alloc] init];
    currentSelectedVar = [[NSMutableDictionary alloc] init];
    selectedVars = [[NSMutableArray alloc] init];
    origingalPrice = 0;
    allPrice = 0;
    amount = 1;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    [self initialAllParts];
    lblRestroName.text = _selectedRestroName;
    
    txtViewOrderNotes.text = @"Order Note";
    categoryItemView.hidden = YES;
}
- (void)initialAllParts{
    [self getOrdersPoint];
    [self getOrdersSum];
}
- (void)getOrdersPoint{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            lblLoyaltyPoints.text = [NSString stringWithFormat:@"Gained/Used:%@/%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"gained_points"] integerValue]], [APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"used_points"] integerValue]]];
            lblLoyalBalance.text = [NSString stringWithFormat:@"Balance:%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"balance"] integerValue]]];
            lblMataamPoints.text = [NSString stringWithFormat:@"Gained/Used:%@/%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"mataam"] objectForKey:@"gained_points"] integerValue]], [APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"used_points"] integerValue]]];
            lblMataamBalance.text = [NSString stringWithFormat:@"Balance:%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"mataam"] objectForKey:@"balance"] integerValue]]];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            //[self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetOrdersPoint:APPDELEGATE.access_token restroId:[_restroId integerValue] locationId:[_locationId integerValue] serviceType:APPDELEGATE.serviceType successed:successed failure:failure];
}
- (void)getOrdersDiscont{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            lblDiscount.text = [APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"discount_amount"] floatValue]];
            discountPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"discount_amount"] floatValue];
            
            lblGrandTotal.text =[APPDELEGATE getFloatToString:totalPrice + chargesPrice - discountPrice];
            
        }
        else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            lblGrandTotal.text = [APPDELEGATE getFloatToString:totalPrice + chargesPrice - discountPrice];
            //[self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetOrdersDiscount:APPDELEGATE.access_token restroId:[_restroId integerValue] locationId:[_locationId integerValue] serviceType:APPDELEGATE.serviceType redeemType:redeemType couponCode:txtCouponCode.text successed:successed failure:failure];
}
- (void)getOrdersSum{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            lblDeliveryCharges.text = [APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"charge_amount"] floatValue]];
            lblSubTotal.text = [APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"total_amount"] floatValue]];
            totalPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"total_amount"] floatValue];
            chargesPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"charge_amount"] floatValue];
            
           // if (txtCouponCode.text && txtCouponCode.text.length) {
                [self getOrdersDiscont];
//            }else{
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                lblGrandTotal.text = [NSString stringWithFormat:@"KD %.1f", totalPrice + chargesPrice - discountPrice];
//            }
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //[self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetOrdersSum:APPDELEGATE.access_token restroId:[_restroId integerValue] locationId:[_locationId integerValue] areaId:[_areaId integerValue] serviceType:APPDELEGATE.serviceType successed:successed failure:failure];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self getFetchAllItems];
}
- (void)getFetchAllItems{
    [arrPickupItems removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            arrPickupItems = [[_responseObject objectForKey:@"resource"] mutableCopy];
            [pickupItemsTableView reloadData];
            if ([arrPickupItems count]<=0) {
                pickupItemsTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
                btnCheckCoupon.enabled = NO;
                btnLoyaltyPoint.enabled = NO;
                btnMataamPoints.enabled = NO;
            }else{
                btnCheckCoupon.enabled = YES;
                btnLoyaltyPoint.enabled = YES;
                btnMataamPoints.enabled = YES;
                pickupItemsTableView.hidden = NO;
                [pickupItemsTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrPickupItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrPickupItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrPickupItems count], 320, 446)];
            }
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            //[self showAlert:_responseObject[@"message"] :@"Error"];
            pickupItemsTableView.hidden = YES;
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
            [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            btnCheckCoupon.enabled = NO;
            btnLoyaltyPoint.enabled = NO;
            btnMataamPoints.enabled = NO;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        pickupItemsTableView.hidden = YES;
        [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        [moveView setFrame:CGRectMake(0, 0, 320, 446)];
        btnCheckCoupon.enabled = NO;
        btnLoyaltyPoint.enabled = NO;
        btnMataamPoints.enabled = NO;
        
    } ;
    
    [[Communication sharedManager] GetFetchAllOrdersCart:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType restroId:[_restroId integerValue] locationId:[_locationId integerValue] successed:successed failure:failure];
    
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
        if ([arrPickupItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f + 70 * [arrPickupItems count])];
        }
        [itemEditScrolView setContentSize:CGSizeMake(320, itemEditScrolView.frame.size.height + 216.0f)];
        //        if (IS_IPHONE_5) {
        //            [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
        //        } else [srcView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        if ([arrPickupItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrPickupItems count])];
        }
        [itemEditScrolView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        if ([arrPickupItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrPickupItems count])];
        }
        [itemEditScrolView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
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
    if ([tableView isEqual:itemTableView]) {
        return [arrCategories count];
    }else if ([tableView isEqual:CategoryItemTableView]){
        return [[currentSelectedVar objectForKey:@"details"] count];
    }else if([tableView isEqual:pickupItemsTableView])
        return [arrPickupItems count];
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:itemTableView]) {
        return 40.0f;
    }else if ([tableView isEqual:CategoryItemTableView]){
        return 35.0f;
    }else if([tableView isEqual:pickupItemsTableView])
        return 71.0f;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:pickupItemsTableView]){
        static NSString *simpleTableIdentifier = @"FoodItemForDeliveryItem";
        FoodItemForDeliveryCell *cell = (FoodItemForDeliveryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSDictionary *dict = [arrPickupItems objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [FoodItemForDeliveryCell sharedCell];
        }
        [cell setOrderCartItem:dict];
        cell.delegate = self;
        cell.lblItemName.text = [[dict objectForKey:@"item"] objectForKey:@"name"];
        cell.lblItemQty.text =[NSString stringWithFormat:@"Qty : %@", [dict objectForKey:@"quantity"]];
        CGFloat totalPriceSum = [[dict objectForKey:@"price"] floatValue];
        cell.ItemTotal.text = [APPDELEGATE getFloatToString:totalPriceSum];
        if ([[dict objectForKey:@"price"] integerValue] == 0) {
            cell.ItemTotal.hidden = YES;
        }else{
            cell.ItemTotal.hidden = NO;
        }
        if (![[[dict objectForKey:@"item"] objectForKey:@"image"] isKindOfClass:[NSNull class]])
        {
            NSArray *arrForUrl = [[[dict objectForKey:@"item"] objectForKey:@"image"] componentsSeparatedByString:@"/"];
            if (arrForUrl.count >= 2) {
                NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
                [cell.itemImage setImageWithURL:[NSURL URLWithString:logoUrl]];
            }
        }
        return cell;
    }else if ([tableView isEqual:itemTableView]) {
        static NSString *simpleTableIdentifier = @"CatergoryItem";
        CatergoryCell *cell = (CatergoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [CatergoryCell sharedCell];
        }
        NSDictionary *dict = [arrCategories objectAtIndex:indexPath.row];
        [cell setCurWorkoutsItem:dict];
            if ([[dict objectForKey:@"is_mandatory"] boolValue]) {
                cell.lblCatergoryName.text = [NSString stringWithFormat:@"%@ (Required)", [dict objectForKey:@"name"]];
            }else{
            cell.lblCatergoryName.text = [NSString stringWithFormat:@"%@ (optional)", [dict objectForKey:@"name"]];;
            }
        
        return cell;
    }else if ([tableView isEqual:CategoryItemTableView]){static NSString *simpleTableIdentifier = @"ValItemItem";
        ValItemCell *cell = (ValItemCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [ValItemCell sharedCell];
        }
        NSDictionary *dict = [[currentSelectedVar objectForKey:@"details"] objectAtIndex:indexPath.row];
        [cell setCurWorkoutsItem:dict];
        cell.valName.text = [dict objectForKey:@"title"];
        //        if ([[currentSelectedVar objectForKey:@"is_mandatory"] boolValue]) {
        //            cell.valPrice.hidden = YES;
        //        }else{
        //            cell.valPrice.hidden = NO;
        cell.valPrice.text = [NSString stringWithFormat:@"KD %@",[dict objectForKey:@"price"]];
        //}
        for (int i = 0 ; i < [selectedVars count]; i ++) {
            NSMutableDictionary *dictone = [[selectedVars objectAtIndex:i] mutableCopy];
            if ([[dictone objectForKey:@"id"] integerValue] == [[currentSelectedVar objectForKey:@"id"] integerValue]) {
                NSMutableArray *arrOneVal = [[dictone objectForKey:@"selected"] mutableCopy];
                if ([arrOneVal containsObject:dict]) {
                    [cell.imgOption setImage:[UIImage imageNamed:@"checked_blue.png"]];
                }else{
                    [cell.imgOption setImage:[UIImage imageNamed:@"unchecked_blue.png"]];
                }
            }
        }
        return cell;
    }

    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:itemTableView]) {
        
        currentSelectedVar = [arrCategories objectAtIndex:indexPath.row];
        categoryItemView.hidden = NO;
        if ([[currentSelectedVar objectForKey:@"is_multiple"] boolValue]) {
            categoryItemDoneBtn.hidden = NO;
        }else{
            categoryItemDoneBtn.hidden = YES;
        }
        [CategoryItemTableView reloadData];
    }else if ([tableView isEqual:CategoryItemTableView]){
        if ([[currentSelectedVar objectForKey:@"is_multiple"] boolValue]) {
            NSDictionary *dic = [[currentSelectedVar objectForKey:@"details"] objectAtIndex:indexPath.row];
            for (int i = 0 ; i < [selectedVars count]; i ++) {
                NSMutableDictionary *dict = [[selectedVars objectAtIndex:i] mutableCopy];
                if ([[dict objectForKey:@"id"] integerValue] == [[currentSelectedVar objectForKey:@"id"] integerValue]) {
                    NSMutableArray *arrOneVal = [[dict objectForKey:@"selected"] mutableCopy];
                    if ([arrOneVal containsObject:dic]) {
                        [arrOneVal removeObject:dic];
                    }else{
                        [arrOneVal addObject:dic];
                    }
                    [dict setObject:arrOneVal forKey:@"selected"];
                    [selectedVars replaceObjectAtIndex:i withObject:dict];
                }
            }
            [CategoryItemTableView reloadData];
        }else{
            NSDictionary *dic = [[currentSelectedVar objectForKey:@"details"] objectAtIndex:indexPath.row];
            for (int i = 0 ; i < [selectedVars count]; i ++) {
                NSMutableDictionary *dict = [[selectedVars objectAtIndex:i] mutableCopy];
                if ([[dict objectForKey:@"id"] integerValue] == [[currentSelectedVar objectForKey:@"id"] integerValue]) {
                    NSMutableArray *arrOneVal = [[dict objectForKey:@"selected"] mutableCopy];
                    if ([arrOneVal containsObject:dic]) {
                        [arrOneVal removeObject:dic];
                    }else{
                        [arrOneVal removeAllObjects];
                        [arrOneVal addObject:dic];
                    }
                    [dict setObject:arrOneVal forKey:@"selected"];
                    [selectedVars replaceObjectAtIndex:i withObject:dict];
                }
            }
            CGFloat sum = 0;
            for (NSDictionary *dict in selectedVars) {
                for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
                    sum = sum + [[dc objectForKey:@"price"] floatValue];
                }
            }
            allPrice = sum + origingalPrice;
            lblItemPriceToEdit.text =[APPDELEGATE getFloatToString:allPrice * amount];
            categoryItemView.hidden = YES;
        }
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtSpecialRequestToEdit)
    {
        [itemEditScrolView setContentOffset:CGPointMake(0, 100) animated:YES];
    }else if (textField == txtCouponCode){
        if ([arrPickupItems count] > 2) {
            [scrView setContentOffset:CGPointMake(0, 70 * ([arrPickupItems count]-2)) animated:YES];
        }
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == txtViewOrderNotes) {
        if ([arrPickupItems count] <= 0) {
            [scrView setContentOffset:CGPointMake(0, 120) animated:YES];
        }else{
            [scrView setContentOffset:CGPointMake(0, 120 + 70 * [arrPickupItems count]) animated:YES];
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrPickupItems count])];
        }
    }
    if ([textView.text isEqualToString:@"Order Note"]) {
        txtViewOrderNotes.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        txtViewOrderNotes.text = @"Order Note";
    }
    return YES;
}

- (IBAction)onAddItems:(id)sender {
    SelectedPickupResViewController *viewcontroller = [[SelectedPickupResViewController alloc] initWithNibName:@"SelectedPickupResViewController" bundle:nil];
    viewcontroller.restroId = _restroId;
    viewcontroller.locationId = _locationId;
    viewcontroller.areaId = _areaId;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCheckCoupon:(id)sender {
    btnCheckCoupon.selected = !btnCheckCoupon.selected;
    if (btnCheckCoupon.selected == YES) {
        redeemType = 1;
        txtCouponCode.enabled = YES;
        btnRedeemCoupon.enabled = YES;
        btnLoyaltyPoint.selected = NO;
        btnMataamPoints.selected = NO;
    }else{
        redeemType = 0;
        txtCouponCode.enabled = NO;
        btnRedeemCoupon.enabled = NO;
    }
}

- (IBAction)onLoyaltyPoints:(id)sender {
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    btnLoyaltyPoint.selected = !btnLoyaltyPoint.selected;
    if (btnLoyaltyPoint.selected == YES) {
        redeemType = 2;
        btnMataamPoints.selected = NO;
        btnCheckCoupon.selected = NO;
    }else{
        redeemType = 0;
    }
    [self getOrdersSum];
}

- (IBAction)onMataamPoints:(id)sender {
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    btnMataamPoints.selected = !btnMataamPoints.selected;
    if (btnMataamPoints.selected == YES) {
        redeemType = 3;
        btnLoyaltyPoint.selected = NO;
        btnCheckCoupon.selected = NO;
    }else{
        redeemType = 0;
    }
    [self getOrdersSum];
}

- (IBAction)onMinusToEdit:(id)sender {
    NSInteger currentIndex = [lblItemCountToEdit.text integerValue];
    if (currentIndex == 1) {
        lblItemCountToEdit.text = @"1";
    }else{
        currentIndex --;
        lblItemCountToEdit.text = [NSString stringWithFormat:@"%ld",(long)currentIndex];
    }
    amount = currentIndex;
    CGFloat sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] floatValue];
        }
    }
    allPrice = sum + origingalPrice;
    //lblItemPriceToEdit.text =[APPDELEGATE getFloatToString:allPrice * [lblItemCountToEdit.text integerValue]];
}

- (IBAction)onPlusToEdit:(id)sender {
    NSInteger currentIndex = [lblItemCountToEdit.text integerValue];
    currentIndex ++;
    amount = currentIndex;
    CGFloat sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] floatValue];
        }
    }
    allPrice = sum + origingalPrice;
    lblItemCountToEdit.text = [NSString stringWithFormat:@"%ld",(long)currentIndex];
    //lblItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * [lblItemCountToEdit.text integerValue]];
}

- (IBAction)onContinue:(id)sender {
    if ([arrPickupItems count] > 0) {
        if (btnCheckCoupon.selected == YES) {
            if (!txtCouponCode.text.length)
            {
                [self showAlert:@"Please input Coupcode." :@"Input Error"];
                return;
            }
        }
        if ([arrPickupItems count] <= 0) {
            [self showAlert:@"Please add items." :@"Error"];
            return;
        }
        //    if (!txtViewOrderNotes.text.length || [txtViewOrderNotes.text isEqualToString:@"Order Note"]) {
        //        [self showAlert:@"Please input Note." :@"Input Error"];
        //        return;
        //    }
        PickUpCheckOutViewController *vc = [[PickUpCheckOutViewController alloc] initWithNibName:@"PickUpCheckOutViewController" bundle:nil];
        vc.areaId = _areaId;
        vc.restroId = _restroId;
        vc.locationId = _locationId;
        vc.selectedRestroName = _selectedRestroName;
        vc.couponCode = txtCouponCode.text;
        vc.redeemType = redeemType;
        vc.discount = lblDiscount.text;
        vc.total =lblSubTotal.text;
        vc.deliveryCharges = lblDeliveryCharges.text;
        vc.grandTotal = lblGrandTotal.text;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.navigationBar.translucent = NO;
        [self presentViewController:nc animated:YES completion:nil];
    }else{
        [self showAlert:@"Oops! Your Cart is empty." :@"Mataam"];
    }
}

- (IBAction)onEidtItemClose:(id)sender {
    itemEditScrolView.hidden = YES;
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onUpdateToEdit:(id)sender {
    BOOL isMondatory = NO;
    for (NSDictionary *dc in selectedVars) {
        if ([[dc objectForKey:@"is_mandatory"] boolValue]) {
            if ([[dc objectForKey:@"selected"] count] == 0) {
                isMondatory = YES;
            }
        }
    }
    
    if (isMondatory && [arrCategories count] > 0) {
        [self showAlert:@"Please select categories!" :@"Error" :nil];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            
            //updateItemView.hidden = YES;
            itemEditScrolView.hidden = YES;
            for (int i = 0 ; i < [arrPickupItems count]; i ++) {
                NSDictionary *dict = [arrPickupItems objectAtIndex:i];
                if ([[dict objectForKey:@"id"] isEqualToString:[currentItemDictToEdit objectForKey:@"id"]]) {
                    NSMutableDictionary *modifyDict = [[NSMutableDictionary alloc] init];
                    modifyDict = [[arrPickupItems objectAtIndex:i] mutableCopy];
                    [modifyDict setObject:lblItemCountToEdit.text forKey:@"quantity"];
                    [modifyDict setObject:txtSpecialRequestToEdit.text forKey:@"spacial_request"];
                    [arrPickupItems replaceObjectAtIndex:i withObject:modifyDict];
                }
            }
            [pickupItemsTableView reloadData];
            if ([arrPickupItems count] <= 0) {
                pickupItemsTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            }else{
                pickupItemsTableView.hidden = NO;
                [pickupItemsTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrPickupItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrPickupItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrPickupItems count], 320, 446)];
            }
            [self getOrdersSum];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    NSString *variationIDS = @"";
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            if ([variationIDS isEqualToString:@""]) {
                variationIDS = [dc objectForKey:@"id"];
            }else{
                variationIDS = [NSString stringWithFormat:@"%@,%@",variationIDS, [dc objectForKey:@"id"]];
            }
        }
    }
    [[Communication sharedManager] PutCurrentItemToEdit:APPDELEGATE.access_token cartId:[[currentItemDictToEdit objectForKey:@"id"] integerValue] serviceType:APPDELEGATE.serviceType productId:[[currentItemDictToEdit objectForKey:@"product_id"] integerValue] quantity:[lblItemCountToEdit.text integerValue] variationIds:variationIDS spacialRequest:txtSpecialRequestToEdit.text successed:successed failure:failure];
}

- (IBAction)onUserCoupon:(id)sender {
    [self.view endEditing:YES];
    [self getOrdersSum];
}
#pragma mark FoodItemForDeliveryCellDelegate
- (void)onOrderCartEditItem:(NSDictionary *)dic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            origingalPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] floatValue];
            if ([[_responseObject objectForKey:@"resource"] objectForKey:@"variations"] && [[[_responseObject objectForKey:@"resource"] objectForKey:@"variations"] count]>0) {
                isVar = YES;
                [arrCategories removeAllObjects];
                arrCategories = [[[_responseObject objectForKey:@"resource"] objectForKey:@"variations"] mutableCopy];
                [selectedVars removeAllObjects];
                for (NSDictionary *dic in arrCategories) {
                    NSMutableDictionary *oneVar = [[NSMutableDictionary alloc] init];
                    [oneVar setObject:[dic objectForKey:@"id"] forKey:@"id"];
                    [oneVar setObject:[dic objectForKey:@"is_mandatory"] forKey:@"is_mandatory"];
                    [oneVar setObject:[dic objectForKey:@"is_multiple"] forKey:@"is_multiple"];
                    [oneVar setObject:[dic objectForKey:@"name"] forKey:@"name"];
                    [oneVar setObject:[dic objectForKey:@"type"] forKey:@"type"];
                    NSMutableArray *arrOneVal = [[NSMutableArray alloc] init];
                    for (NSDictionary *dc in [dic objectForKey:@"details"]) {
                        if ([currentItemDictToEdit objectForKey:@"variation_ids"]) {
                            NSArray *arrV = [[NSString stringWithFormat:@"%@",[currentItemDictToEdit objectForKey:@"variation_ids"]] componentsSeparatedByString:@","];
                            for (int i = 0 ; i < arrV.count; i++) {
                                if ([[dc objectForKey:@"id"] integerValue] == [arrV[i] integerValue]) {
                                    [arrOneVal addObject:dc];
                                }
                            }
                        }
                    }
                    [oneVar setObject:arrOneVal forKey:@"selected"];
                    [selectedVars addObject:oneVar];
                    
                }
                
                [itemTableView reloadData];
                CGFloat sum = 0;
                for (NSDictionary *dict in selectedVars) {
                    for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
                        sum = sum + [[dc objectForKey:@"price"] floatValue];
                    }
                }
                allPrice = sum + origingalPrice;
                lblItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * [[dic objectForKey:@"quantity"] integerValue]];
                amount = [[dic objectForKey:@"quantity"] integerValue];
            }else{
                isVar = NO;
                
                allPrice = origingalPrice;
                lblItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * [[dic objectForKey:@"quantity"] integerValue]];
                amount = [[dic objectForKey:@"quantity"] integerValue];
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
    
    [[Communication sharedManager] GetRestaurantsFoodItem:APPDELEGATE.access_token foodItemId:[[dic objectForKey:@"product_id"] integerValue] successed:successed failure:failure];
    
    
    currentItemDictToEdit = dic;
    //updateItemView.hidden = NO;
    itemEditScrolView.hidden = NO;
    //lblItemPriceToEdit.text = [NSString stringWithFormat:@"KD %@",[dic objectForKey:@"price"]];
    lblItemCountToEdit.text = [dic objectForKey:@"quantity"];
    txtSpecialRequestToEdit.text = [dic objectForKey:@"spacial_request"];
}
- (void)onOrderCartDeleteItem:(NSDictionary *)dic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            for (int i = 0 ; i < [arrPickupItems count]; i ++) {
                NSDictionary *dict = [arrPickupItems objectAtIndex:i];
                if ([[dict objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                    [arrPickupItems removeObjectAtIndex:i];
                }
            }
            [pickupItemsTableView reloadData];
            if ([arrPickupItems count] <= 0) {
                pickupItemsTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            }else{
                pickupItemsTableView.hidden = NO;
                [pickupItemsTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrPickupItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrPickupItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrPickupItems count], 320, 446)];
            }
            if ([arrPickupItems count] <= 0) {
                lblDeliveryCharges.text = @"KD 0.000";
                lblSubTotal.text = @"KD 0.000";
                lblDiscount.text = @"KD 0.000";
                lblGrandTotal.text = @"KD 0.000";
            }
            [self getOrdersSum];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] DeleteCurrentItem:APPDELEGATE.access_token cartId:[[dic objectForKey:@"id"] integerValue] serviceType:APPDELEGATE.serviceType successed:successed failure:failure];
}
- (IBAction)onCategoryItemViewClose:(id)sender {
    categoryItemView.hidden = YES;
}

- (IBAction)onCategoryItemViewDone:(id)sender {
    categoryItemView.hidden = YES;
    CGFloat sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] floatValue];
        }
    }
    allPrice = sum + origingalPrice;
    lblItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * amount];
}
@end
