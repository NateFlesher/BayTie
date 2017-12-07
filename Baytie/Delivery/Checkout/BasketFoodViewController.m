//
//  BasketFoodViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "BasketFoodViewController.h"
#import "MainMenuViewController.h"
#import "DeliveryCheckOutViewController.h"
#import "FoodItemForDeliveryCell.h"
#import "UIImageView+AFNetworking.h"
#import "SelectedDeliveryResViewController.h"
#import "ValItemCell.h"
#import "CatergoryCell.h"

@interface BasketFoodViewController ()<UITextFieldDelegate, UITextViewDelegate,FoodItemForDeliveryCellDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *arrDeliveryItems;
    
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

@implementation BasketFoodViewController

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
    updateItemView.hidden = YES;
    scrViewToEdit.hidden = YES;
    [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 64.0f)];
    showKeyboard = NO;
    redeemType = 0;
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    arrDeliveryItems = [[NSMutableArray alloc] init];
    
    arrCategories = [[NSMutableArray alloc] init];
    currentSelectedVar = [[NSMutableDictionary alloc] init];
    selectedVars = [[NSMutableArray alloc] init];

    totalPrice = 0;
    discountPrice = 0;
    chargesPrice = 0;
    
    origingalPrice = 0;
    allPrice = 0;
    amount = 1;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    [self initialAllParts];
    
    lblRestroName.text = _selectedRestroName;
    txtVieworderNotes.text = @"Order Note";
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
            lblLoyaltyPoints.text = [NSString stringWithFormat:@"Gained/Used:%@/%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"gained_points"] integerValue]],[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"used_points"] integerValue]]];
            lblLoyalBalance.text = [NSString stringWithFormat:@"Balance:%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"balance"] integerValue]]];
            lblMataamPoints.text = [NSString stringWithFormat:@"Gained/Used:%@/%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"mataam"] objectForKey:@"gained_points"] integerValue]], [APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"used_points"] integerValue]]];
            lblMataamBalance.text = [NSString stringWithFormat:@"Balance:%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"mataam"] objectForKey:@"balance"] integerValue]]];
            
        }
//        else if ([[_responseObject objectForKey:@"code"] integerValue]) {
//            [self showAlert:_responseObject[@"message"] :@"Error"];
//        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetOrdersPoint:APPDELEGATE.access_token restroId:[_restroId integerValue] locationId:[_locationId integerValue] serviceType:APPDELEGATE.serviceType successed:successed failure:failure];
}
- (void)getOrdersDiscont{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            lblDiscount.text =[APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"discount_amount"] floatValue]];
            discountPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"discount_amount"] floatValue];
            
            lblGrandTotal.text =[APPDELEGATE getFloatToString:totalPrice + chargesPrice - discountPrice];
            
        }
        else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            lblGrandTotal.text =[APPDELEGATE getFloatToString:totalPrice + chargesPrice - discountPrice];
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
            
//            if (txtCouponCode.text && txtCouponCode.text.length) {
                [self getOrdersDiscont];
//            }else{
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                lblGrandTotal.text = [NSString stringWithFormat:@"%.3f", totalPrice + chargesPrice - discountPrice];
//            }
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //[self showAlert:_responseObject[@"message"] :@"Error"];
        }
//        else if ([[_responseObject objectForKey:@"code"] integerValue]) {
//            [self showAlert:_responseObject[@"message"] :@"Error"];
//        }
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
    [arrDeliveryItems removeAllObjects];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            arrDeliveryItems = [[_responseObject objectForKey:@"resource"] mutableCopy];
            [deliveryItemsTableView reloadData];
            if ([arrDeliveryItems count] <= 0) {
                deliveryItemsTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
                btnCheckCoupon.enabled = NO;
                btnLoyaltyPoint.enabled = NO;
                btnMataamPoint.enabled = NO;
            }else{
                deliveryItemsTableView.hidden = NO;
                [deliveryItemsTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrDeliveryItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrDeliveryItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrDeliveryItems count], 320, 446)];
                btnCheckCoupon.enabled = YES;
                btnLoyaltyPoint.enabled = YES;
                btnMataamPoint.enabled = YES;
            }
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            //[self showAlert:_responseObject[@"message"] :@"Error"];
            btnCheckCoupon.enabled = NO;
            btnLoyaltyPoint.enabled = NO;
            btnMataamPoint.enabled = NO;
            
            deliveryItemsTableView.hidden = YES;
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
            [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ];
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        btnCheckCoupon.enabled = NO;
        btnLoyaltyPoint.enabled = NO;
        btnMataamPoint.enabled = NO;
        deliveryItemsTableView.hidden = YES;
        [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        [moveView setFrame:CGRectMake(0, 0, 320, 446)];
        
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
        if ([arrDeliveryItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f + 70 * [arrDeliveryItems count])];
        }
        
        
        [scrViewToEdit setContentSize:CGSizeMake(320, scrViewToEdit.frame.size.height + 216.0f)];
        //        if (IS_IPHONE_5) {
        //            [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
        //        } else [srcView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        if ([arrDeliveryItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrDeliveryItems count])];
        }
        [scrViewToEdit setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        if ([arrDeliveryItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrDeliveryItems count])];
        }
        [scrViewToEdit setContentSize:CGSizeMake(0, 0)];
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
    }else if([tableView isEqual:deliveryItemsTableView])
        return [arrDeliveryItems count];
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:itemTableView]) {
        return 40.0f;
    }else if ([tableView isEqual:CategoryItemTableView]){
        return 35.0f;
    }else if([tableView isEqual:deliveryItemsTableView])
        return 71.0f;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:deliveryItemsTableView]){
        static NSString *simpleTableIdentifier = @"FoodItemForDeliveryItem";
        FoodItemForDeliveryCell *cell = (FoodItemForDeliveryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSDictionary *dict = [arrDeliveryItems objectAtIndex:indexPath.row];
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
                cell.lblCatergoryName.text = [NSString stringWithFormat:@"%@ (optional)", [dict objectForKey:@"name"]];
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
        cell.valPrice.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
        //}
        for (int i = 0 ; i < [selectedVars count]; i ++) {
            NSMutableDictionary *dictone = [[selectedVars objectAtIndex:i] mutableCopy];
            if ([[dictone objectForKey:@"id"] integerValue] == [[currentSelectedVar objectForKey:@"id"] integerValue]) {
                NSMutableArray *arrOneVal = [[dictone objectForKey:@"selected"] mutableCopy];
                if ([arrOneVal containsObject:dict]) {
                    [cell.imgOption setImage:[UIImage imageNamed:@"checked_green.png"]];
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
            currentItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * amount];
            
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
    if (textField == txtSpecalRequestToEdit)
    {
        [scrViewToEdit setContentOffset:CGPointMake(0, 100) animated:YES];
    }else if (textField == txtCouponCode){
        if ([arrDeliveryItems count] > 2) {
            [scrView setContentOffset:CGPointMake(0, 70 * ([arrDeliveryItems count]-2)) animated:YES];
        }
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == txtVieworderNotes) {
        if ([arrDeliveryItems count] <= 0) {
            [scrView setContentOffset:CGPointMake(0, 120) animated:YES];
        }else{
            [scrView setContentOffset:CGPointMake(0, 120 + 70 * [arrDeliveryItems count]) animated:YES];
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrDeliveryItems count])];
        }
    }
    if ([textView.text isEqualToString:@"Order Note"]) {
        txtVieworderNotes.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
         txtVieworderNotes.text = @"Order Note";
    }
    return YES;
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onCheckCoupon:(id)sender {
    btnCheckCoupon.selected = !btnCheckCoupon.selected;
    if (btnCheckCoupon.selected == YES) {
        redeemType = 1;
        txtCouponCode.enabled = YES;
        btnRedeemCoupon.enabled = YES;
        btnLoyaltyPoint.selected = NO;
        btnMataamPoint.selected = NO;
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
        btnMataamPoint.selected = NO;
        btnCheckCoupon.selected = NO;
    }else{
        redeemType = 0;
    }
    [self getOrdersSum];
}

- (IBAction)onMataamPoints:(id)sender {
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    btnMataamPoint.selected = !btnMataamPoint.selected;
    if (btnMataamPoint.selected == YES) {
        redeemType = 3;
        btnLoyaltyPoint.selected = NO;
        btnCheckCoupon.selected = NO;
    }else{
        redeemType = 0;
    }
    [self getOrdersSum];
}

- (IBAction)onContinue:(id)sender {
    if ([arrDeliveryItems count] > 0) {
        if (btnCheckCoupon.selected == YES) {
            if (!txtCouponCode.text.length)
            {
                [self showAlert:@"Please input Coupcode." :@"Input Error"];
                return;
            }
        }
        if ([arrDeliveryItems count] <= 0) {
            [self showAlert:@"Please add items." :@"Error"];
            return;
        }
        //    if (!txtVieworderNotes.text.length || [txtVieworderNotes.text isEqualToString:@"Order Note"]) {
        //        [self showAlert:@"Please input Note." :@"Input Error"];
        //        return;
        //    }
        
        DeliveryCheckOutViewController *vc = [[DeliveryCheckOutViewController alloc] initWithNibName:@"DeliveryCheckOutViewController" bundle:nil];
        vc.areaId = _areaId;
        vc.restroId = _restroId;
        vc.locationId = _locationId;
        vc.selectedRestroName = _selectedRestroName;
        vc.couponCode = txtCouponCode.text;
        vc.redeemType = redeemType;
        vc.discount = lblDiscount.text;
        vc.total = lblSubTotal.text;
        vc.deliveryCharges = lblDeliveryCharges.text;
        vc.grandTotal = lblGrandTotal.text;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.navigationBar.translucent = NO;
        [self presentViewController:nc animated:YES completion:nil];
    }else{
        [self showAlert:@"Oops! Your Cart is empty." :@"Mataam"];
    }
}

- (IBAction)onUseCoupon:(id)sender {
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
            
            origingalPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] integerValue];
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
                currentItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * [[dic objectForKey:@"quantity"] integerValue]];
            }
            //[self initUpdatedViews];
            
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
    updateItemView.hidden = NO;
    scrViewToEdit.hidden = NO;
//    
//    currentItemPriceToEdit.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
    lblQtyToEdit.text = [dic objectForKey:@"quantity"];
    txtSpecalRequestToEdit.text = [dic objectForKey:@"spacial_request"];
}
- (void)onOrderCartDeleteItem:(NSDictionary *)dic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            for (int i = 0 ; i < [arrDeliveryItems count]; i ++) {
                NSDictionary *dict = [arrDeliveryItems objectAtIndex:i];
                if ([[dict objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                    [arrDeliveryItems removeObjectAtIndex:i];
                }
            }
            [deliveryItemsTableView reloadData];
            if ([arrDeliveryItems count] <= 0) {
                deliveryItemsTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            }else{
                deliveryItemsTableView.hidden = NO;
                [deliveryItemsTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrDeliveryItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrDeliveryItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrDeliveryItems count], 320, 446)];
            }
            if ([arrDeliveryItems count] <= 0) {
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
- (IBAction)editItemViewClose:(id)sender {
    updateItemView.hidden = YES;
    scrViewToEdit.hidden = YES;
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onUpdateCurrentItem:(id)sender {
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
            
            updateItemView.hidden = YES;
            scrViewToEdit.hidden = YES;
            for (int i = 0 ; i < [arrDeliveryItems count]; i ++) {
                NSDictionary *dict = [arrDeliveryItems objectAtIndex:i];
                if ([[dict objectForKey:@"id"] isEqualToString:[currentItemDictToEdit objectForKey:@"id"]]) {
                    NSMutableDictionary *modifyDict = [[NSMutableDictionary alloc] init];
                    modifyDict = [[arrDeliveryItems objectAtIndex:i] mutableCopy];
                    [modifyDict setObject:lblQtyToEdit.text forKey:@"quantity"];
                    [modifyDict setObject:txtSpecalRequestToEdit.text forKey:@"spacial_request"];
                    [modifyDict setObject:@(allPrice * amount) forKey:@"price"];
                    [arrDeliveryItems replaceObjectAtIndex:i withObject:modifyDict];
                }
            }
            [deliveryItemsTableView reloadData];
            if ([arrDeliveryItems count] <= 0) {
                deliveryItemsTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            }else{
                deliveryItemsTableView.hidden = NO;
                [deliveryItemsTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrDeliveryItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrDeliveryItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrDeliveryItems count], 320, 446)];
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
    [[Communication sharedManager] PutCurrentItemToEdit:APPDELEGATE.access_token cartId:[[currentItemDictToEdit objectForKey:@"id"] integerValue] serviceType:APPDELEGATE.serviceType productId:[[currentItemDictToEdit objectForKey:@"product_id"] integerValue] quantity:[lblQtyToEdit.text integerValue] variationIds:variationIDS spacialRequest:txtSpecalRequestToEdit.text successed:successed failure:failure];
}

- (IBAction)onMinusQty:(id)sender {
    NSInteger currentIndex = [lblQtyToEdit.text integerValue];
    if (currentIndex == 1) {
        lblQtyToEdit.text = @"1";
    }else{
        currentIndex --;
        lblQtyToEdit.text = [NSString stringWithFormat:@"%ld",(long)currentIndex];
    }
    amount = currentIndex;
    CGFloat sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] floatValue];
        }
    }
    allPrice = sum + origingalPrice;
    //currentItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * [lblQtyToEdit.text integerValue]];
}

- (IBAction)onPlusQty:(id)sender {
    NSInteger currentIndex = [lblQtyToEdit.text integerValue];
    currentIndex ++;
    lblQtyToEdit.text = [NSString stringWithFormat:@"%ld",(long)currentIndex];
    
    amount = currentIndex;
    CGFloat sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] floatValue];
        }
    }
    allPrice = sum + origingalPrice;
    //currentItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * [lblQtyToEdit.text integerValue]];
}

- (IBAction)onAddItems:(id)sender {
    SelectedDeliveryResViewController *viewcontroller = [[SelectedDeliveryResViewController alloc] initWithNibName:@"SelectedDeliveryResViewController" bundle:nil];
    viewcontroller.restroId = _restroId;
    viewcontroller.locationId = _locationId;
    viewcontroller.areaId = _areaId;
    [self.navigationController pushViewController:viewcontroller animated:YES];
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
    currentItemPriceToEdit.text = [APPDELEGATE getFloatToString:allPrice * amount];
}
@end
