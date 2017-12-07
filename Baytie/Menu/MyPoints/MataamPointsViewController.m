//
//  MataamPointsViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "MataamPointsViewController.h"
#import "PointsCell.h"
#import "UIImageView+AFNetworking.h"
@interface MataamPointsViewController (){
    NSMutableArray *arrMataamPoints;
}

@end

@implementation MataamPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrMataamPoints = [[NSMutableArray alloc] init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMataamPoints];
}
- (void)getMataamPoints{
    [arrMataamPoints removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            arrMataamPoints = [_responseObject objectForKey:@"resource"];
            [mataamPointsTableView reloadData];
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
    
    [[Communication sharedManager] GetOrdersMyPoints:APPDELEGATE.access_token serviceType:0 pointType:3 successed:successed failure:failure];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrMataamPoints count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"PointsItem";
    PointsCell *cell = (PointsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrMataamPoints objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [PointsCell sharedCell];
    }
    [cell setPointsItem:dict];
    if (![[dict objectForKey:@"restaurant"] isKindOfClass:[NSNull class]]) {
        if (![[[dict objectForKey:@"restaurant"] objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]]) {
            NSArray *arrForUrl = [[[dict objectForKey:@"restaurant"] objectForKey:@"restro_logo"]componentsSeparatedByString:@"/"];
            NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
            [cell.logoImage setImageWithURL:[NSURL URLWithString:logoUrl]];
        }
        
        cell.lblRestroName.text = [[dict objectForKey:@"restaurant"] objectForKey:@"restro_name"];
    }
    cell.lblOrderNo.text = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"order"] objectForKey:@"order_no"]];
    cell.lblAmout.text = [APPDELEGATE getFloatToString:[[[dict objectForKey:@"order"] objectForKey:@"total"] floatValue]];
    //cell.lblDateTime.text = [NSString stringWithFormat:@"%@ %@", [[dict objectForKey:@"order"] objectForKey:@"delivery_date"], [[dict objectForKey:@"order"] objectForKey:@"delivery_time"]];
    cell.lblDateTime.text = [[dict objectForKey:@"order"] objectForKey:@"updated_time"];
    cell.lblGainedPoint.text = [APPDELEGATE getIntToStringForPoint:[[dict objectForKey:@"gained_mataam_point"] integerValue]];
    cell.lblBalance.text =[APPDELEGATE getIntToStringForPoint:[[dict objectForKey:@"balance_mataam_point"] integerValue]];
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

- (IBAction)onBackMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
