//
//  SelectedCateringPreViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "SelectedCateringPreViewController.h"
#import "MainMenuViewController.h"
#import "BasketCateringViewController.h"
#import "UIImageView+AFNetworking.h"
@interface SelectedCateringPreViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>{
    int amount;
    CGFloat allPrice;
    CGFloat originalPrice;
    NSMutableArray *cells;
    NSMutableArray *heighsForEachCell;
    UIView *footView;
}

@end

@implementation SelectedCateringPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    amount = 1;
    showKeyboard = NO;
    lblRestroName.text = _selectedRestroName;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    allPrice = 0;
    originalPrice = 0;
    
    PlatTableview.translatesAutoresizingMaskIntoConstraints = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    [self getFoodInfo];
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [PlatTableview setTableFooterView:footView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                [foodLogoImage setImageWithURL:[NSURL URLWithString:logoUrl]];
                }
            }
            if ([[_responseObject objectForKey:@"resource"] objectForKey:@"description"] && ![[[_responseObject objectForKey:@"resource"] objectForKey:@"description"] isEqualToString:@""]) {
                CGRect textRect = [[[_responseObject objectForKey:@"resource"] objectForKey:@"description"] boundingRectWithSize:CGSizeMake(320, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
                
                [lblFoodDetails setFrame:CGRectMake(16, 31, 296, textRect.size.height)];
                [foodDetailView setFrame:CGRectMake(0, 0, 320,  40 + textRect.size.height)];
                
                [cells addObject:foodDetailView];
                [heighsForEachCell addObject:@(40 + textRect.size.height)];
                lblFoodDetails.text = [[_responseObject objectForKey:@"resource"] objectForKey:@"description"];
            }
            
            if ([[[_responseObject objectForKey:@"resource"] objectForKey:@"price_type"] integerValue] == 2) {
                if ([[_responseObject objectForKey:@"resource"] objectForKey:@"price"] && [[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] floatValue] > 0) {
                    lblPriceForFood.hidden = NO;
                    lblPriceForFood.text = [APPDELEGATE getFloatToString:[[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] floatValue]];
                    originalPrice = [[[_responseObject objectForKey:@"resource"] objectForKey:@"price"] integerValue];
                    
                    [cells addObject:foodPriceView];
                    [heighsForEachCell addObject:@(40.0f)];
                }
            }
            
            [cells addObject:specialRequestQtyView];
            [heighsForEachCell addObject:@(267.0f)];
            [cells addObject:addToCartView];
            [heighsForEachCell addObject:@(85.0f)];
            
            [PlatTableview reloadData];
            
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
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
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
        
        [PlatTableview setTableFooterView:footView];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        showKeyboard = NO;
        [self.view endEditing:YES];
        footView.frame = CGRectMake(0, 0, 320, 0);
        
        [PlatTableview setTableFooterView:footView];
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        showKeyboard = NO;
        [self.view endEditing:YES];
        footView.frame = CGRectMake(0, 0, 320, 0);
        
        [PlatTableview setTableFooterView:footView];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtSpecialRequest) {
        UITableViewCell *cell = (UITableViewCell *)[[[textField superview] superview] superview];
        
        footView.frame = CGRectMake(0, 0, 320, 170);
        
        [PlatTableview setTableFooterView:footView];
        
        [PlatTableview scrollToRowAtIndexPath:[PlatTableview indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txtSpecialRequest) {
        [self.view endEditing:YES];
    }
    return YES;
}
- (IBAction)onMinusCount:(id)sender {
    amount--;
    if (amount < 1) {
        amount = 1;
    }
    lblCount.text = [NSString stringWithFormat:@"%d", amount];
    //lblPriceForFood.text = [APPDELEGATE getFloatToString:originalPrice * amount];
}

- (IBAction)onPlusCount:(id)sender {
    amount++;
    lblCount.text = [NSString stringWithFormat:@"%d", amount];
    //lblPriceForFood.text = [APPDELEGATE getFloatToString:originalPrice * amount];
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
- (IBAction)onclose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCateringBasket:(id)sender {
//    if (!txtSpecialRequest.text.length)
//    {
//        [self showAlert:@"Please input Special Request!" :@"Input Error" :nil];
//        return;
//    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            BasketCateringViewController *vc = [[BasketCateringViewController alloc] initWithNibName:@"BasketCateringViewController" bundle:nil];            
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
    [[Communication sharedManager] SetOrdersCart:APPDELEGATE.access_token serviceType:APPDELEGATE.serviceType productId:[[_deliveryFoodsItem objectForKey:@"id"] integerValue] quantity:[lblCount.text integerValue] variationIds:@"" spacialRequest:txtSpecialRequest.text successed:successed failure:failure];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:PlatTableview]){
        return [cells count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [heighsForEachCell[indexPath.row] floatValue];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:PlatTableview]){
        static NSString *simpleTableIdentifier = @"ComponentsItem";
        UITableViewCell *cell = [PlatTableview dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
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
@end
