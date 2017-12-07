//
//  ReservationResMainViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ReservationResMainViewController.h"
#import "MainMenuViewController.h"
#import "ReservationRestroCell.h"
#import "SelectedReservationResViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DeliverySelectedResInfoViewController.h"

@interface ReservationResMainViewController ()<ReservationRestroCellDelegate>{
    NSString *currentRestroID;
    
    NSMutableArray *allRestros;
    NSMutableArray *searchedRestros;
    NSMutableArray *filteredRestros;
}

@end

@implementation ReservationResMainViewController

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
    return 90.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"ReservationRestroItem";
    ReservationRestroCell *cell = (ReservationRestroCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [searchedRestros objectAtIndex:indexPath.row];
    currentRestroID = [dict objectForKey:@"location_id"];
    if (cell == nil) {
        cell = [ReservationRestroCell sharedCell];
    }
    if ([APPDELEGATE.availableSwippingCellsById containsObject:currentRestroID]) {
        [cell isSwipingCell:YES];
    }else{
        [cell isSwipingCell:NO];
    }
    cell.delegate = self;
    [cell setCurWorkoutsItem:dict];
    if (![[dict objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]]) {
        NSLog(@"logo url : %@",[dict objectForKey:@"restro_logo"]);
        NSArray *arrForUrl = [[dict objectForKey:@"restro_logo"] componentsSeparatedByString:@"/"];
        
        NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
        [cell.restroLogoImage setImageWithURL:[NSURL URLWithString:logoUrl]];
    }
    cell.lblRestroImage.text = [dict objectForKey:@"restro_name"];
    switch ([[dict objectForKey:@"status"] integerValue]) {
        case 0://close
            [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
            cell.lblStatus.text = @"Close";
            break;
        case 1://open
            [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
            cell.lblStatus.text = @"Open";
            break;
        case 2://busy
            [cell.statusImage setImage:[UIImage imageNamed:@"status_open_red.png"]];
            cell.lblStatus.text = @"Busy";
            break;
            
        default:
            break;
    }
    if ([dict objectForKey:@"busy"] && [[dict objectForKey:@"busy"] integerValue] == 1) {
        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_red.png"]];
        cell.lblStatus.text = @"Busy";
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
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblStatus.text = @"Open";
                    }else{
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblStatus.text = @"Close";
                    }
                }else{
                    [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblStatus.text = @"Close";
                }
                break;
            case 2:
                if (![[dict objectForKey:@"monday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"monday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblStatus.text = @"Open";
                    }else{
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblStatus.text = @"Close";
                    }
                }else{
                    [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblStatus.text = @"Close";
                }
                break;
            case 3:
                if (![[dict objectForKey:@"tuesday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"tuesday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblStatus.text = @"Open";
                    }else{
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblStatus.text = @"Close";
                    }
                }else{
                    [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblStatus.text = @"Close";
                }
                break;
            case 4:
                if (![[dict objectForKey:@"wednesday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"wednesday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblStatus.text = @"Open";
                    }else{
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblStatus.text = @"Close";
                    }
                }else{
                    [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblStatus.text = @"Close";
                }
                break;
            case 5:
                if (![[dict objectForKey:@"thursday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"thursday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblStatus.text = @"Open";
                    }else{
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblStatus.text = @"Close";
                    }
                }else{
                    [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblStatus.text = @"Close";
                }
                break;
            case 6:
                if (![[dict objectForKey:@"friday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"friday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblStatus.text = @"Open";
                    }else{
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblStatus.text = @"Close";
                    }
                }else{
                    [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblStatus.text = @"Close";
                }
                break;
            case 7:
                if (![[dict objectForKey:@"saturday_from"] isKindOfClass:[NSNull class]] && ![[dict objectForKey:@"saturday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[dict objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        cell.lblStatus.text = @"Open";
                    }else{
                        [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        cell.lblStatus.text = @"Close";
                    }
                }else{
                    [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    cell.lblStatus.text = @"Close";
                }
                break;
                
            default:
                [cell.statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                cell.lblStatus.text = @"Close";
                break;
        }
    }
    //NSString *rateValue = [deliveryResItem objectForKey:@""];
    if (![[dict objectForKey:@"rating"] isKindOfClass:[NSNull class]]) {
        [cell.ratingImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%d.png",(int)roundf([[dict objectForKey:@"rating"] floatValue])]]];
    }else{
        [cell.ratingImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%d.png",0]]];
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
                    cell.featureImage.hidden = YES;
                    cell.promoImage.hidden = YES;
                    break;
                case 3://1,1,"
                    if ([arr[0] boolValue]) {
                        cell.featureImage.hidden = NO;
                    }else{
                        cell.featureImage.hidden = YES;
                    }
                    cell.promoImage.hidden = YES;
                    break;
                case 4://1,1,1,"
                    if ([arr[0] boolValue]) {
                        cell.featureImage.hidden = NO;
                    }else{
                        cell.featureImage.hidden = YES;
                    }
                    if ([arr[1] boolValue]) {
                        cell.promoImage.hidden = NO;
                    }else{
                        cell.promoImage.hidden = YES;
                    }
                    break;
                case 5://1,1,1,1,"
                    if ([arr[1] boolValue]) {
                        cell.featureImage.hidden = NO;
                    }else{
                        cell.featureImage.hidden = YES;
                    }
                    if ([arr[2] boolValue]) {
                        cell.promoImage.hidden = NO;
                    }else{
                        cell.promoImage.hidden = YES;
                    }
                    break;
                default:
                    break;
            }
        }else{
            cell.featureImage.hidden = YES;
            cell.promoImage.hidden = YES;
        }
    }
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:cell action:@selector(swipeLeft:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:gestureR];
    
    if (![[dict objectForKey:@"slots"] isKindOfClass:[NSNull class]]) {
        NSArray *arr = [dict objectForKey:@"slots"];
        
        [cell.slot1 setTitle:[[arr objectAtIndex:0] objectForKey:@"time"] forState:UIControlStateNormal];
        [cell.slot2 setTitle:[[arr objectAtIndex:1] objectForKey:@"time"] forState:UIControlStateNormal];
        [cell.slot3 setTitle:[[arr objectAtIndex:2] objectForKey:@"time"] forState:UIControlStateNormal];
        [cell.slot4 setTitle:[[arr objectAtIndex:3] objectForKey:@"time"] forState:UIControlStateNormal];
        [cell.slot5 setTitle:[[arr objectAtIndex:4] objectForKey:@"time"] forState:UIControlStateNormal];
        
        if ([[[arr objectAtIndex:0] objectForKey:@"available"] boolValue]) {
            cell.slot1.enabled =  YES;
        }else{
            cell.slot1.enabled =  NO;
        }
        if ([[[arr objectAtIndex:1] objectForKey:@"available"] boolValue]) {
            cell.slot2.enabled =  YES;
        }else{
            cell.slot2.enabled =  NO;
        }
        if ([[[arr objectAtIndex:2] objectForKey:@"available"] boolValue]) {
            cell.slot3.enabled =  YES;
        }else{
            cell.slot3.enabled =  NO;
        }
        if ([[[arr objectAtIndex:3] objectForKey:@"available"] boolValue]) {
            cell.slot4.enabled =  YES;
        }else{
            cell.slot4.enabled =  NO;
        }
        if ([[[arr objectAtIndex:4] objectForKey:@"available"] boolValue]) {
            cell.slot5.enabled =  YES;
        }else{
            cell.slot5.enabled =  NO;
        }
    }else{
        cell.slot1.enabled =  NO;
        cell.slot2.enabled =  NO;
        cell.slot3.enabled =  NO;
        cell.slot4.enabled =  NO;
        cell.slot5.enabled =  NO;
    }
    
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
    DeliverySelectedResInfoViewController *viewcontroller = [[DeliverySelectedResInfoViewController alloc] initWithNibName:@"DeliverySelectedResInfoViewController" bundle:nil];
    viewcontroller.restroDetails = dict;
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
- (IBAction)onBack:(id)sender {
    [APPDELEGATE.availableSwippingCellsById removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark DeliveryResCellDelegate
- (void)onRestorRatingSetting:(NSString *)rate id:(NSString *)_id{
    if ([APPDELEGATE.availableSwippingCellsById containsObject:_id]) {
        [APPDELEGATE.availableSwippingCellsById removeObject:_id];
    }
    NSLog(@"index cancel : %@", currentRestroID);
}
- (void)onReloadTableView{
    [reservationResTableView reloadData];
}
- (void)onSlotSelected:(NSDictionary *)dic index:(NSInteger)_index{
    [APPDELEGATE.availableSwippingCellsById removeAllObjects];
    SelectedReservationResViewController *viewcontroller = [[SelectedReservationResViewController alloc] initWithNibName:@"SelectedReservationResViewController" bundle:nil];
    viewcontroller.selectedRestroDict = dic;
    viewcontroller.areaId = _areaId;
    viewcontroller.persionsNumber = _persionsNumber;
    viewcontroller.dateForReservation = _dateForReservation;
    viewcontroller.timeForReservation = _timeForReservation;
    viewcontroller.dateForReserveTimes = _dateForReserveTimes;
    viewcontroller.slotIndex = _index;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}
- (IBAction)onFilterAll:(id)sender {
    [self.view endEditing:YES];
    [btnFilterAll setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    btnFilterFeatured.selected = NO;
    btnFilterPromo.selected =  NO;
    btnFilterRating.selected = NO;
    
    [searchedRestros removeAllObjects];
    searchedRestros =[allRestros mutableCopy];
    [reservationResTableView reloadData];
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
    [reservationResTableView reloadData];
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
    [reservationResTableView reloadData];
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
    [reservationResTableView reloadData];
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
    [reservationResTableView reloadData];
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
    
    [reservationResTableView reloadData];
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
    
    [reservationResTableView reloadData];
}
@end

