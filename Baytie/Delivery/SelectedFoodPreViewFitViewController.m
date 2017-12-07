//
//  SelectedFoodPreViewFitViewController.m
//  Baytie
//
//  Created by stepanekdavid on 1/17/17.
//  Copyright © 2017 Lovisa. All rights reserved.
//

#import "SelectedFoodPreViewFitViewController.h"
#import "MainMenuViewController.h"
#import "BasketFoodViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "Communication.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "ValItemCell.h"
#import "CatergoryCell.h"
@interface SelectedFoodPreViewFitViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *cells;
    NSMutableArray *heighsForEachCell;
    
    int amount;
    NSMutableArray *arrCategories;
    NSMutableDictionary *currentSelectedVar;
    
    NSMutableArray * selectedVars;
    
    
    CGFloat allPrice;
    CGFloat origingalPrice;
    
    UIView *footView;
    
    BOOL isVar;
}
@end

@implementation SelectedFoodPreViewFitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    arrCategories = [[NSMutableArray alloc] init];
    currentSelectedVar = [[NSMutableDictionary alloc] init];
    selectedVars = [[NSMutableArray alloc] init];
    
    amount = 1;
    showKeyboard = NO;
    lblSelectedRestroName.text = _selectedRestroName;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    origingalPrice = 0;
    
    categoryItemView.hidden = YES;
    
    isVar = NO;
    allPrice = 0;
    //[self initUpdatedViews];
    
    
    PlatTableView.translatesAutoresizingMaskIntoConstraints = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    [self getFoodInfo];
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [PlatTableView setTableFooterView:footView];
}
- (void)getFoodInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            if ([cells count]) {
                [cells removeAllObjects];
                [heighsForEachCell removeAllObjects];
            }
            cells = [[NSMutableArray alloc] init];
            heighsForEachCell = [[NSMutableArray alloc] init];
            
            [cells addObject:foodLogoView];
            [heighsForEachCell addObject:@(188.0f)];
            
            if (![[[_responseObject objectForKey:@"resource"] objectForKey:@"image"] isKindOfClass:[NSNull class]])
            {
                NSArray *arrForUrl = [[[_responseObject objectForKey:@"resource"] objectForKey:@"image"] componentsSeparatedByString:@"/"];
                if ([arrForUrl count] >= 3) {
                    NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
                    [foodItemProfileImage setImageWithURL:[NSURL URLWithString:logoUrl]];
                }
            }
            if ([[_responseObject objectForKey:@"resource"] objectForKey:@"description"] && ![[[_responseObject objectForKey:@"resource"] objectForKey:@"description"] isEqualToString:@""]) {
                CGRect textRect = [[[_responseObject objectForKey:@"resource"] objectForKey:@"description"] boundingRectWithSize:CGSizeMake(320, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
                
                [lblFoodItemDetails setFrame:CGRectMake(16, 31, 296, textRect.size.height)];
                [foodDetailView setFrame:CGRectMake(0, 0, 320,  40 + textRect.size.height)];
                
                [cells addObject:foodDetailView];
                [heighsForEachCell addObject:@(40 + textRect.size.height)];
                lblFoodItemDetails.text = [[_responseObject objectForKey:@"resource"] objectForKey:@"description"];
            }
            if ([[[_responseObject objectForKey:@"resource"] objectForKey:@"price_type"] integerValue] == 2) {
                if ([[_responseObject objectForKey:@"resource"] objectForKey:@"price"] && [[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] floatValue] > 0) {
                    foodItemPrice.hidden = NO;
                    foodItemPrice.text = [APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] floatValue]];
                    origingalPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] integerValue];
                    
                    [cells addObject:foodPriceView];
                    [heighsForEachCell addObject:@(40.0f)];
                }
            }
            
            
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
                    [oneVar setObject:arrOneVal forKey:@"selected"];
                    [selectedVars addObject:oneVar];
                    
                }
                
                
                [choiceCategoriesTableView reloadData];
                
                [choiceCategoriesTableView setFrame:CGRectMake(8, 31, 303, 40 * [arrCategories count])];
                [foodCategoryView setFrame:CGRectMake(0, 0, 320,  33 + 40 * [arrCategories count])];
                
                [cells addObject:foodCategoryView];
                [heighsForEachCell addObject:@(33 + 40 * [arrCategories count])];
                
            }
            [cells addObject:specialRequestQtyView];
            [heighsForEachCell addObject:@(140.0f)];
            [cells addObject:addToCartView];
            [heighsForEachCell addObject:@(85.0f)];
            
            [PlatTableView reloadData];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [self showAlert:_responseObject[@"message"] :@"Error"];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetRestaurantsFoodItem:APPDELEGATE.access_token foodItemId:[[_deliveryFoodsItem objectForKey:@"id"] integerValue] successed:successed failure:failure];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
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
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        footView.frame = CGRectMake(0, 0, 320, kbSize.height);
        
        [PlatTableView setTableFooterView:footView];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        showKeyboard = NO;
        [self.view endEditing:YES];
        footView.frame = CGRectMake(0, 0, 320, 0);
        
        [PlatTableView setTableFooterView:footView];
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        showKeyboard = NO;
        [self.view endEditing:YES];
        footView.frame = CGRectMake(0, 0, 320, 0);
        
        [PlatTableView setTableFooterView:footView];
    }
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onFoodBasket:(id)sender {
    //    if (!txtSpecialRequest.text.length)
    //    {
    //        [self showAlert:@"Please input Special Request!" :@"Input Error" :nil];
    //        return;
    //    }
    
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
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            
            BasketFoodViewController *vc = [[BasketFoodViewController alloc] initWithNibName:@"BasketFoodViewController" bundle:nil];
            vc.restroId = [[_responseObject objectForKey:@"resource"] objectForKey:@"restro_id"];
            vc.locationId = _locationId;
            vc.selectedRestroName = _selectedRestroName;
            vc.areaId = _areaId;
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            nc.navigationBar.translucent = NO;
            [self presentViewController:nc animated:YES completion:nil];
            
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
    
    [[Communication sharedManager] SetOrdersCart:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType productId:[[_deliveryFoodsItem objectForKey:@"id"] integerValue] quantity:[lblAmount.text integerValue] variationIds:variationIDS spacialRequest:txtSpecialRequest.text successed:successed failure:failure];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtSpecialRequest) {
        UITableViewCell *cell = (UITableViewCell *)[[[textField superview] superview] superview];
        
        footView.frame = CGRectMake(0, 0, 320, 170);
        
        [PlatTableView setTableFooterView:footView];
        
        [PlatTableView scrollToRowAtIndexPath:[PlatTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txtSpecialRequest) {
        [self.view endEditing:YES];
    }
    return YES;
}
- (IBAction)onDiscount:(id)sender {
    amount--;
    if (amount < 1) {
        amount = 1;
    }
    lblAmount.text = [NSString stringWithFormat:@"%d", amount];
    NSInteger sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] integerValue];
        }
    }
    allPrice = sum + origingalPrice;
    //foodItemPrice.text = [APPDELEGATE getFloatToString: allPrice * amount];
}

- (IBAction)onCount:(id)sender {
    amount++;
    lblAmount.text = [NSString stringWithFormat:@"%d", amount];
    NSInteger sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] integerValue];
        }
    }
    allPrice = sum + origingalPrice;
    //foodItemPrice.text = [APPDELEGATE getFloatToString: allPrice * amount];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:choiceCategoriesTableView]) {
        return [arrCategories count];
    }else if ([tableView isEqual:CategoryItemTableView]){
        return [[currentSelectedVar objectForKey:@"details"] count];
    }else if ([tableView isEqual:PlatTableView]){
        return [cells count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:choiceCategoriesTableView]) {
        return 40.0f;
    }else if ([tableView isEqual:CategoryItemTableView]){
        return 35.0f;
    }
    return [heighsForEachCell[indexPath.row] floatValue];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:choiceCategoriesTableView]) {
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
    }else if ([tableView isEqual:CategoryItemTableView]){
        static NSString *simpleTableIdentifier = @"ValItemItem";
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
        cell.valPrice.text = [APPDELEGATE getFloatToString: [[dict objectForKey:@"price"] floatValue]];
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
    }else if ([tableView isEqual:PlatTableView]){
        static NSString *simpleTableIdentifier = @"ComponentsItem";
        UITableViewCell *cell = [PlatTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = selectionColor;
        for (UIView *subView in cell.subviews) {
            [subView removeFromSuperview];
        }
        [cell addSubview:cells[indexPath.row]];
        
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
    if ([tableView isEqual:choiceCategoriesTableView]) {
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
            NSInteger sum = 0;
            for (NSDictionary *dict in selectedVars) {
                for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
                    sum = sum + [[dc objectForKey:@"price"] floatValue];
                }
            }
            allPrice = sum + origingalPrice;
            foodItemPrice.text = [APPDELEGATE getFloatToString: allPrice * amount];
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
- (IBAction)onCategoryItemViewClose:(id)sender {
    categoryItemView.hidden = YES;
}

- (IBAction)onCategoryItemViewDone:(id)sender {
    categoryItemView.hidden = YES;
    NSInteger sum = 0;
    for (NSDictionary *dict in selectedVars) {
        for (NSDictionary *dc in [dict objectForKey:@"selected"]) {
            sum = sum + [[dc objectForKey:@"price"] integerValue];
        }
    }
    allPrice = sum + origingalPrice;
    foodItemPrice.text = [APPDELEGATE getFloatToString: allPrice * amount];
}
@end
