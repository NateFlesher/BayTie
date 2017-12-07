//
//  CateringResMainViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "CateringResMainViewController.h"
#import "MainMenuViewController.h"
#import "DeliveryResCell.h"
#import "SelectedCateringResViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CateringResMainViewController ()<DeliveryResCellDelegate>{
    NSString *currentRestroID;
    NSMutableArray *allRestros;
    NSMutableArray *searchedRestros;
    NSMutableArray *filteredRestros;
}

@end

@implementation CateringResMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    currentRestroID = @"";
    
    allRestros = [[NSMutableArray alloc] init];
    searchedRestros = [[NSMutableArray alloc] init];
    filteredRestros = [[NSMutableArray alloc] init];
    
    allRestros = [_foundRestroLists mutableCopy];
    searchedRestros = [_foundRestroLists mutableCopy];
    filteredRestros = [_foundRestroLists mutableCopy];
    
    UISwipeGestureRecognizer* gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gestureR];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)hideKeyBoard{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [searchedRestros count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"DeliveryResItem";
    DeliveryResCell *cell = (DeliveryResCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [searchedRestros objectAtIndex:indexPath.row];
    currentRestroID = [dict objectForKey:@"location_id"];
    if (cell == nil) {
        cell = [DeliveryResCell sharedCell];
    }
    if ([APPDELEGATE.availableSwippingCellsById containsObject:currentRestroID]) {
        [cell isSwipingCell:YES];
    }else{
        [cell isSwipingCell:NO];
    }
    cell.delegate = self;
    [cell setCurWorkoutsItem:dict];
    if (![[dict objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]]) {
        NSArray *arrForUrl = [[dict objectForKey:@"restro_logo"] componentsSeparatedByString:@"/"];
        NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
        [cell.restroLogo setImageWithURL:[NSURL URLWithString:logoUrl]];
    }
    cell.restroName.text = [dict objectForKey:@"restro_name"];
    cell.lblMinOrder.text = [APPDELEGATE getFloatToString:[[dict objectForKey:@"min_order"] floatValue]];
    cell.lblDeliveryTime.text = [NSString stringWithFormat:@"%@ min", [dict objectForKey:@"order_time"]];
    if ([dict objectForKey:@"busy"] && [[dict objectForKey:@"busy"] integerValue] == 1) {
        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_red.png"]];
        cell.lblRestroStatus.text = @"Busy";
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mmaa"];
        NSInteger fromTime = 0;
        NSInteger toTime = 0;
        NSInteger currentTime = 0;
        switch (APPDELEGATE.dayType) {
            case 1:
                if (![[dict objectForKey:@"sunday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"sunday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblRestroStatus.text = @"Open";
                    }else{
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblRestroStatus.text = @"Close";
                    }
                }else{
                    [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblRestroStatus.text = @"Close";
                }
                break;
            case 2:
                if (![[dict objectForKey:@"monday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"monday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblRestroStatus.text = @"Open";
                    }else{
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblRestroStatus.text = @"Close";
                    }
                }else{
                    [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblRestroStatus.text = @"Close";
                }
                break;
            case 3:
                if (![[dict objectForKey:@"tuesday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"tuesday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblRestroStatus.text = @"Open";
                    }else{
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblRestroStatus.text = @"Close";
                    }
                }else{
                    [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblRestroStatus.text = @"Close";
                }
                break;
            case 4:
                if (![[dict objectForKey:@"wednesday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"wednesday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblRestroStatus.text = @"Open";
                    }else{
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblRestroStatus.text = @"Close";
                    }
                }else{
                    [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblRestroStatus.text = @"Close";
                }
                break;
            case 5:
                if (![[dict objectForKey:@"thursday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"thursday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblRestroStatus.text = @"Open";
                    }else{
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblRestroStatus.text = @"Close";
                    }
                }else{
                    [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblRestroStatus.text = @"Close";
                }
                break;
            case 6:
                if (![[dict objectForKey:@"friday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"friday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblRestroStatus.text = @"Open";
                    }else{
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblRestroStatus.text = @"Close";
                    }
                }else{
                    [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblRestroStatus.text = @"Close";
                }
                break;
            case 7:
                if (![[dict objectForKey:@"saturday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"saturday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblRestroStatus.text = @"Open";
                    }else{
                        [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblRestroStatus.text = @"Close";
                    }
                }else{
                    [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblRestroStatus.text = @"Close";
                }
                break;
                
            default:
                [cell.restroStatusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                cell.lblRestroStatus.text = @"Close";
                break;
        }
    }
    //NSString *rateValue = [deliveryResItem objectForKey:@""];
    if (![[dict objectForKey:@"rating"] isKindOfClass:[NSNull class]]) {
        [cell.restroRatingImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%d.png",(int)roundf([[dict objectForKey:@"rating"] floatValue])]]];
    }else{
        [cell.restroRatingImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%d.png",0]]];
    }
    
    if ([dict objectForKey:@"restro_status"]) {
        NSString *string = @"" ;
        NSUInteger x = [[dict objectForKey:@"restro_status"] integerValue];
        
        while (x>0) {
            string = [[NSString stringWithFormat: @"%lu,", x&1] stringByAppendingString:string];
            x = x >> 1;
        }
        NSArray *arr = [string componentsSeparatedByString:@","];
        if (arr.count > 1) {
            
            NSLog(@"binay : %@ - > %@", [dict objectForKey:@"restro_status"], arr);
            switch (arr.count) {
                case 2://1,"
                    cell.restroFeaturedImage.hidden = YES;
                    cell.restroBowImage.hidden = YES;
                    break;
                case 3://1,1,"
                    if ([arr[0] boolValue]) {
                        cell.restroFeaturedImage.hidden = NO;
                    }else{
                        cell.restroFeaturedImage.hidden = YES;
                    }
                    cell.restroBowImage.hidden = YES;
                    break;
                case 4://1,1,1,"
                    if ([arr[0] boolValue]) {
                        cell.restroFeaturedImage.hidden = NO;
                    }else{
                        cell.restroFeaturedImage.hidden = YES;
                    }
                    if ([arr[1] boolValue]) {
                        cell.restroBowImage.hidden = NO;
                    }else{
                        cell.restroBowImage.hidden = YES;
                    }
                    break;
                case 5://1,1,1,1,"
                    if ([arr[1] boolValue]) {
                        cell.restroFeaturedImage.hidden = NO;
                    }else{
                        cell.restroFeaturedImage.hidden = YES;
                    }
                    if ([arr[2] boolValue]) {
                        cell.restroBowImage.hidden = NO;
                    }else{
                        cell.restroBowImage.hidden = YES;
                    }
                    break;
                default:
                    break;
            }
        }else{
            cell.restroFeaturedImage.hidden = YES;
            cell.restroBowImage.hidden = YES;
        }
    }
    
    cell.restroPaymentC.hidden = YES;
    cell.restroPaymentD.hidden = YES;
    cell.restroPaymentK.hidden = YES;
    if (![[dict objectForKey:@"payment_method"] isKindOfClass:[NSNull class]]) {
        NSArray *paymentParsArray = [[dict objectForKey:@"payment_method"] componentsSeparatedByString:@","];
        switch ([paymentParsArray count]) {
            case 1:
                cell.restroPaymentC.hidden = NO;
                [cell.restroPaymentC setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                break;
            case 2:
                cell.restroPaymentC.hidden = NO;
                [cell.restroPaymentC setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                if ([paymentParsArray[1] integerValue] !=4) {
                    cell.restroPaymentD.hidden = NO;
                    [cell.restroPaymentD setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[1]]]];
                }
                break;
            case 3:
                cell.restroPaymentC.hidden = NO;
                [cell.restroPaymentC setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                cell.restroPaymentD.hidden = NO;
                [cell.restroPaymentD setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[1]]]];
                if ([paymentParsArray[2] integerValue] !=4) {
                    cell.restroPaymentK.hidden = NO;
                    [cell.restroPaymentK setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[2]]]];
                }
                break;
            case 4:
                cell.restroPaymentC.hidden = NO;
                [cell.restroPaymentC setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                cell.restroPaymentD.hidden = NO;
                [cell.restroPaymentD setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[1]]]];
                if ([paymentParsArray[2] integerValue] !=4) {
                    cell.restroPaymentK.hidden = NO;
                    [cell.restroPaymentK setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[2]]]];
                }
                break;
                
            default:
                cell.restroPaymentD.hidden = YES;
                cell.restroPaymentK.hidden = YES;
                cell.restroPaymentC.hidden = YES;
                break;
        }
    }
    
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:cell action:@selector(swipeLeft:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:gestureR];
    
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
    NSDictionary *dict = [searchedRestros objectAtIndex:indexPath.row];
    
    [APPDELEGATE.availableSwippingCellsById removeAllObjects];
    SelectedCateringResViewController *viewcontroller = [[SelectedCateringResViewController alloc] initWithNibName:@"SelectedCateringResViewController" bundle:nil];
    viewcontroller.restroId = [dict objectForKey:@"restro_id"];
    viewcontroller.locationId = [dict objectForKey:@"location_id"];
    viewcontroller.areaId = _areaId;
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}
- (IBAction)onBack:(id)sender {
    [APPDELEGATE.availableSwippingCellsById removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
#pragma mark DeliveryResCellDelegate
- (void)onRestorRatingSetting:(NSString *)rate id:(NSString *)_id{
    if ([APPDELEGATE.availableSwippingCellsById containsObject:_id]) {
        [APPDELEGATE.availableSwippingCellsById removeObject:_id];
    }
    NSLog(@"index cancel : %@", currentRestroID);
}
- (void)onReloadTableView{
    [cateringResTableView reloadData];
}
- (IBAction)onFilterAll:(id)sender {
    [self.view endEditing:YES];
    [btnFilterAll setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    btnFilterFeatured.selected = NO;
    btnFilterPromo.selected =  NO;
    btnFilterRating.selected = NO;
    
    [searchedRestros removeAllObjects];
    searchedRestros =[allRestros mutableCopy];
    [cateringResTableView reloadData];
}

- (IBAction)onFilterFeatured:(id)sender {
    [self.view endEditing:YES];
    [btnFilterAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFilterFeatured.selected = YES;
    btnFilterPromo.selected =  NO;
    btnFilterRating.selected = NO;
    
    [searchedRestros removeAllObjects];
    [filteredRestros removeAllObjects];
    for (NSDictionary *dict in allRestros) {
        if ([dict objectForKey:@"restro_status"]) {
            NSString *string = @"" ;
            NSUInteger x = [[dict objectForKey:@"restro_status"] integerValue];
            
            while (x>0) {
                string = [[NSString stringWithFormat: @"%lu,", x&1] stringByAppendingString:string];
                x = x >> 1;
            }
            NSArray *arr = [string componentsSeparatedByString:@","];
            if (arr.count > 1) {
                
                switch (arr.count) {
                    case 2://1,"
                        break;
                    case 3://1,1,"
                        if ([arr[0] boolValue]) {
                            [filteredRestros addObject:dict];
                        }
                        break;
                    case 4://1,1,1,"
                        if ([arr[0] boolValue]) {
                            [filteredRestros addObject:dict];
                        }
                        break;
                    case 5://1,1,1,1,"
                        if ([arr[1] boolValue]) {
                            [filteredRestros addObject:dict];
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    searchedRestros = [filteredRestros mutableCopy];
    [cateringResTableView reloadData];
}

- (IBAction)onFilterPromo:(id)sender {
    [self.view endEditing:YES];
    [btnFilterAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFilterFeatured.selected = NO;
    btnFilterPromo.selected =  YES;
    btnFilterRating.selected = NO;
    [self.view endEditing:YES];
    [searchedRestros removeAllObjects];
    [filteredRestros removeAllObjects];
    for (NSDictionary *dict in allRestros) {
        if ([dict objectForKey:@"restro_status"]) {
            NSString *string = @"" ;
            NSUInteger x = [[dict objectForKey:@"restro_status"] integerValue];
            
            while (x>0) {
                string = [[NSString stringWithFormat: @"%lu,", x&1] stringByAppendingString:string];
                x = x >> 1;
            }
            NSArray *arr = [string componentsSeparatedByString:@","];
            if (arr.count > 1) {
                
                NSLog(@"binay : %@ - > %@", [dict objectForKey:@"restro_status"], arr);
                switch (arr.count) {
                    case 2://1,"
                        break;
                    case 3://1,1,"
                        break;
                    case 4://1,1,1,"
                        if ([arr[1] boolValue]) {
                            [filteredRestros addObject:dict];
                        }
                        break;
                    case 5://1,1,1,1,"
                        if ([arr[2] boolValue]) {
                            [filteredRestros addObject:dict];
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    searchedRestros = [filteredRestros mutableCopy];
    [cateringResTableView reloadData];
}

- (IBAction)onFilterRating:(id)sender {
    [self.view endEditing:YES];
    [btnFilterAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFilterFeatured.selected = NO;
    btnFilterPromo.selected =  NO;
    btnFilterRating.selected = YES;
    [searchedRestros removeAllObjects];
    [filteredRestros removeAllObjects];
    for (NSDictionary *dict in allRestros) {
        if ([dict objectForKey:@"rating"] && ![[dict objectForKey:@"rating"] isKindOfClass:[NSNull class]]) {
            if ([[dict objectForKey:@"rating"] integerValue] > 0) {
                [filteredRestros addObject:dict];
            }
        }
    }
    searchedRestros = [filteredRestros mutableCopy];
    [cateringResTableView reloadData];
}

#pragma - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    [searchedRestros removeAllObjects];
    
    searchedRestros =[filteredRestros mutableCopy];
    [cateringResTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [restroSearchBar resignFirstResponder];
    if (searchBar.text.length != 0) {
        searchedRestros = [NSMutableArray new];
        for (NSDictionary *restro in filteredRestros) {
            NSString *name = @"";
            name = [restro objectForKey:@"restro_name"];
            if ([[name lowercaseString] rangeOfString:searchBar.text.lowercaseString].location != NSNotFound) {
                [searchedRestros addObject:restro];
            }
        }
    } else {
        [searchedRestros removeAllObjects];
        
        searchedRestros =[filteredRestros mutableCopy];
    }
    
    [cateringResTableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0) {
        searchedRestros = [NSMutableArray new];
        for (NSDictionary *restro in filteredRestros) {
            NSString *name = @"";
            name = [restro objectForKey:@"restro_name"];
            if ([[name lowercaseString] rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [searchedRestros addObject:restro];
            }
        }
    } else {
        [searchedRestros removeAllObjects];
        searchedRestros =[filteredRestros mutableCopy];
    }
    
    [cateringResTableView reloadData];
}
@end
