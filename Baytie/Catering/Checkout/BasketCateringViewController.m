//
//  BasketCateringViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "BasketCateringViewController.h"
#import "MainMenuViewController.h"
#import "CateringCheckOutViewController.h"

#import "FoodItemForDeliveryCell.h"
#import "ParentCityAndFoodCell.h"
#import "ChildCityAndFoodCell.h"
#import "SelectedCateringResViewController.h"

#import "UIImageView+AFNetworking.h"
@interface BasketCateringViewController ()<UITextFieldDelegate, UITextViewDelegate,FoodItemForDeliveryCellDelegate,UIGestureRecognizerDelegate>{
    
    NSMutableArray *arrCateringItems;
    
    NSDictionary *currentItemDictToEdit;
    
    NSInteger redeemType;
    
    CGFloat totalPrice;
    CGFloat discountPrice;
    CGFloat chargesPrice;
    
    CGFloat allPrice;
    CGFloat originalPrice;
    NSInteger amount;
}

@end

@implementation BasketCateringViewController
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
    //addIemView.hidden = YES;
    addItemScrollView.hidden = YES;
    [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 64.0f)];
    showKeyboard = NO;
    redeemType = 0;
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    arrCateringItems = [[NSMutableArray alloc] init];
    
    totalPrice = 0;
    discountPrice = 0;
    chargesPrice = 0;
    
    allPrice = 0;
    originalPrice = 0;
    amount = 0;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    [self initialAllParts];
    
    lblRestroName.text = _selectedRestroName;
    
    txtViewOrderNotes.text = @"Order Note";
    
}
- (void)initialAllParts{
    [self getOrdersPoint];
    //[self getOrdersDiscont];
    [self getOrdersSum];
}
- (void)getOrdersPoint{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            lblLoyaltyPoint.text = [NSString stringWithFormat:@"Gained/Used:%@/%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"gained_points"] integerValue]], [APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"used_points"] integerValue]]];
            
            lblLoyaltyBalance.text = [NSString stringWithFormat:@"Balance:%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"balance"] integerValue]]];
            
            lblMataamPoint.text = [NSString stringWithFormat:@"Gained/Used:%@/%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"mataam"] objectForKey:@"gained_points"] integerValue]], [APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"loyalty"] objectForKey:@"used_points"] integerValue]]];
            
            lblMataamBlance.text = [NSString stringWithFormat:@"Balance:%@",[APPDELEGATE getIntToStringForPoint:[[[[_responseObject objectForKey:@"resource"] objectForKey:@"mataam"] objectForKey:@"balance"] integerValue]]];
            
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
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            lblDiscount.text = [APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"discount_amount"] floatValue]];
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
            lblDeliveryCharges.text =[APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"charge_amount"] floatValue]];
            lblSubTotal.text =[APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"total_amount"] floatValue]];
            
            totalPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"total_amount"] floatValue];
            chargesPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"charge_amount"] floatValue];
            
            //if (txtCouponCode.text && txtCouponCode.text.length) {
                [self getOrdersDiscont];
//            }else{
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                lblGrandTotal.text = [NSString stringWithFormat:@"KD %.1f", totalPrice + chargesPrice - discountPrice];
//            }
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           // [self showAlert:_responseObject[@"message"] :@"Error"];
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
    [arrCateringItems removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            arrCateringItems = [[_responseObject objectForKey:@"resource"] mutableCopy];
            [itemTableView reloadData];
            if ([arrCateringItems count] <= 0) {
                itemTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
                checkRedeemCoupon.enabled = NO;
                checkLoyalityPoints.enabled = NO;
                checkMataamPoints.enabled = NO;
            }else{
                checkRedeemCoupon.enabled = YES;
                checkLoyalityPoints.enabled = YES;
                checkMataamPoints.enabled = YES;
                itemTableView.hidden = NO;
                [itemTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrCateringItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrCateringItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrCateringItems count], 320, 446)];
            }
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            //[self showAlert:_responseObject[@"message"] :@"Error"];
            itemTableView.hidden = YES;
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
            [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            checkRedeemCoupon.enabled = NO;
            checkLoyalityPoints.enabled = NO;
            checkMataamPoints.enabled = NO;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        itemTableView.hidden = YES;
        [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        [moveView setFrame:CGRectMake(0, 0, 320, 446)];
        checkRedeemCoupon.enabled = NO;
        checkLoyalityPoints.enabled = NO;
        checkMataamPoints.enabled = NO;
        
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
        if ([arrCateringItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 216.0f + 70 * [arrCateringItems count])];
        }
        [addItemScrollView setContentSize:CGSizeMake(320, addItemScrollView.frame.size.height + 216.0f)];
        //        if (IS_IPHONE_5) {
        //            [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
        //        } else [srcView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        if ([arrCateringItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrCateringItems count])];
        }
        [addItemScrollView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        if ([arrCateringItems count] <= 0) {
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        }else{
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrCateringItems count])];
        }
        [addItemScrollView setContentSize:CGSizeMake(0, 0)];
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
    if([tableView isEqual:itemTableView])
        return [arrCateringItems count];
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:itemTableView])
        return 71.0f;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:itemTableView]){
        static NSString *simpleTableIdentifier = @"FoodItemForDeliveryItem";
        FoodItemForDeliveryCell *cell = (FoodItemForDeliveryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSDictionary *dict = [arrCateringItems objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [FoodItemForDeliveryCell sharedCell];
        }
        [cell setOrderCartItem:dict];
        cell.delegate = self;
        cell.lblItemName.text = [[dict objectForKey:@"item"] objectForKey:@"name"];
        cell.lblItemQty.text =[NSString stringWithFormat:@"Qty : %@", [dict objectForKey:@"quantity"]];
        cell.ItemTotal.text = [APPDELEGATE getFloatToString:[[dict objectForKey:@"price"] floatValue]];

        if ([[dict objectForKey:@"price"] integerValue] == 0) {
            cell.ItemTotal.hidden = YES;
        }else{
            cell.ItemTotal.hidden = NO;
        }
        if (![[[dict objectForKey:@"item"] objectForKey:@"image"] isKindOfClass:[NSNull class]])
        {            
            NSArray *arrForUrl = [[[dict objectForKey:@"item"] objectForKey:@"image"] componentsSeparatedByString:@"/"];
            if (arrForUrl.count >=2) {
                NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
                [cell.itemImage setImageWithURL:[NSURL URLWithString:logoUrl]];
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
    //    SelectedDeliveryResViewController *viewcontroller = [[SelectedDeliveryResViewController alloc] initWithNibName:@"SelectedDeliveryResViewController" bundle:nil];
    //    [self.navigationController pushViewController:viewcontroller animated:YES];
    
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
    if (textField == txtSpecialRequest)
    {
        [addItemScrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }else if (textField == txtCouponCode){
        if ([arrCateringItems count] > 2) {
            [scrView setContentOffset:CGPointMake(0, 70 * ([arrCateringItems count]-2)) animated:YES];
        }
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == txtViewOrderNotes) {
        if ([arrCateringItems count] <= 0) {
            [scrView setContentOffset:CGPointMake(0, 120) animated:YES];
        }else{
            [scrView setContentOffset:CGPointMake(0, 120 + 70 * [arrCateringItems count]) animated:YES];
            [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrCateringItems count])];
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
- (IBAction)onAddItem:(id)sender {
}

- (IBAction)onUserCoupon:(id)sender {
    [self.view endEditing:YES];
    [self getOrdersSum];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCheckRedeem:(id)sender {
    checkRedeemCoupon.selected = !checkRedeemCoupon.selected;
    if (checkRedeemCoupon.selected == YES) {
        redeemType = 1;
        txtCouponCode.enabled = YES;
        btnRedeemCoupon.enabled = YES;
        checkLoyalityPoints.selected = NO;
        checkMataamPoints.selected = NO;
    }else{
        redeemType = 0;
        txtCouponCode.enabled = NO;
        btnRedeemCoupon.enabled = NO;
    }
}

- (IBAction)onCheckLoyality:(id)sender {
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    checkLoyalityPoints.selected = !checkLoyalityPoints.selected;
    if (checkLoyalityPoints.selected == YES) {
        redeemType = 2;
        checkMataamPoints.selected = NO;
        checkRedeemCoupon.selected = NO;
    }else{
        redeemType = 0;
    }
    [self getOrdersSum];
}

- (IBAction)onCheckMataam:(id)sender {
    txtCouponCode.enabled = NO;
    btnRedeemCoupon.enabled = NO;
    checkMataamPoints.selected = !checkMataamPoints.selected;
    if (checkMataamPoints.selected == YES) {
        redeemType = 3;
        checkLoyalityPoints.selected = NO;
        checkRedeemCoupon.selected = NO;
    }else{
        redeemType = 0;
    }
    [self getOrdersSum];
}

- (IBAction)onContinue:(id)sender {
    if ([arrCateringItems count] > 0) {
        if (checkRedeemCoupon.selected == YES) {
            if (!txtCouponCode.text.length)
            {
                [self showAlert:@"Please input Coupcode." :@"Input Error"];
                return;
            }
        }
        if ([arrCateringItems count] <= 0) {
            [self showAlert:@"Please add items." :@"Error"];
            return;
        }
        //    if (!txtViewOrderNotes.text.length || [txtViewOrderNotes.text isEqualToString:@"Order Note"]) {
        //        [self showAlert:@"Please input Note." :@"Input Error"];
        //        return;
        //    }
        CateringCheckOutViewController *vc = [[CateringCheckOutViewController alloc] initWithNibName:@"CateringCheckOutViewController" bundle:nil];
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
        [self showAlert:@"Oops! Your cart is empty." :@"Mataam"];
    }
}

- (IBAction)onEditItemCloseView:(id)sender {
    addItemScrollView.hidden = YES;
}

- (IBAction)onMinusQty:(id)sender {
    
    NSInteger currentIndex = [lblQty.text integerValue];
    if (currentIndex == 1) {
        lblQty.text = @"1";
    }else{
        currentIndex --;
        lblQty.text = [NSString stringWithFormat:@"%ld",(long)currentIndex];
    }
    //lblPriceToEdit.text = [NSString stringWithFormat:@"%.3f",originalPrice * currentIndex];
}

- (IBAction)onPlusQty:(id)sender {
    
    NSInteger currentIndex = [lblQty.text integerValue];
    currentIndex ++;
    lblQty.text = [NSString stringWithFormat:@"%ld",(long)currentIndex];
    //lblPriceToEdit.text = [NSString stringWithFormat:@"%.3f",originalPrice * currentIndex];
}

- (IBAction)onUpdateItemToEdit:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            
            addItemScrollView.hidden = YES;
            for (int i = 0 ; i < [arrCateringItems count]; i ++) {
                NSDictionary *dict = [arrCateringItems objectAtIndex:i];
                if ([[dict objectForKey:@"id"] isEqualToString:[currentItemDictToEdit objectForKey:@"id"]]) {
                    NSMutableDictionary *modifyDict = [[NSMutableDictionary alloc] init];
                    modifyDict = [[arrCateringItems objectAtIndex:i] mutableCopy];
                    [modifyDict setObject:lblQty.text forKey:@"quantity"];
                    [modifyDict setObject:txtSpecialRequest.text forKey:@"spacial_request"];
                    [arrCateringItems replaceObjectAtIndex:i withObject:modifyDict];
                }
            }
            [itemTableView reloadData];
            if ([arrCateringItems count] <= 0) {
                itemTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            }else{
                itemTableView.hidden = NO;
                [itemTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrCateringItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrCateringItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrCateringItems count], 320, 446)];
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
    [[Communication sharedManager] PutCurrentItemToEdit:APPDELEGATE.access_token cartId:[[currentItemDictToEdit objectForKey:@"id"] integerValue] serviceType:APPDELEGATE.serviceType productId:[[currentItemDictToEdit objectForKey:@"product_id"] integerValue] quantity:[lblQty.text integerValue] variationIds:@"" spacialRequest:txtSpecialRequest.text successed:successed failure:failure];
}

- (IBAction)onAddItems:(id)sender {
    SelectedCateringResViewController *viewcontroller = [[SelectedCateringResViewController alloc] initWithNibName:@"SelectedCateringResViewController" bundle:nil];
    viewcontroller.restroId = _restroId;
    viewcontroller.locationId = _locationId;
    viewcontroller.areaId = _areaId;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
#pragma mark FoodItemForDeliveryCellDelegate
- (void)onOrderCartEditItem:(NSDictionary *)dic{
    
    currentItemDictToEdit = dic;
    addItemScrollView.hidden = NO;
    lblPriceToEdit.text =[APPDELEGATE getFloatToString:[[dic objectForKey:@"price"] floatValue] * [[dic objectForKey:@"quantity"] integerValue]];
    originalPrice = [[dic objectForKey:@"price"] floatValue];
    lblQty.text = [dic objectForKey:@"quantity"];
    txtSpecialRequest.text = [dic objectForKey:@"spacial_request"];
}
- (void)onOrderCartDeleteItem:(NSDictionary *)dic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            for (int i = 0 ; i < [arrCateringItems count]; i ++) {
                NSDictionary *dict = [arrCateringItems objectAtIndex:i];
                if ([[dict objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                    [arrCateringItems removeObjectAtIndex:i];
                }
            }
            [itemTableView reloadData];
            if ([arrCateringItems count] <= 0) {
                itemTableView.hidden = YES;
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
                [moveView setFrame:CGRectMake(0, 0, 320, 446)];
            }else{
                itemTableView.hidden = NO;
                [itemTableView setFrame:CGRectMake(0, 0, 320, 70 * [arrCateringItems count])];
                [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 70 * [arrCateringItems count])];
                [moveView setFrame:CGRectMake(0, 70 * [arrCateringItems count], 320, 446)];
            }
            if ([arrCateringItems count] <= 0) {
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
@end
