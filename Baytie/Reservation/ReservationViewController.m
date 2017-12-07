//
//  ReservationViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "ReservationViewController.h"
#import "MainMenuViewController.h"
#import "ReservationResMainViewController.h"
#import "ParentCityAndFoodCell.h"
#import "ChildCityAndFoodCell.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"

#import "Communication.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface ReservationViewController (){
    int count;
    NSString *selectedAreaId;
    NSMutableArray * restroFoodCategory;
    NSMutableArray * tmpRestorFoodCategory;
    NSString *dateTimeForReservation;
    NSString *timeForReservation;
    NSArray *arrDate;
    NSString *dateForReserveTimes;
    
    
    SKSTableView *reservationFoodSelectedTableView;
    SKSTableView *reservationCitySelectedTableView;
    
    NSArray *searchedlstCity;
    NSArray *searchedLstFood;
    NSArray *searchedlstCityIds;
    NSArray *searchedLstFoodIds;
    
    
    NSMutableArray *arryFoodCaregory;
}

@end

@implementation ReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    selectedAreaId = @"";
    restroFoodCategory = [[NSMutableArray alloc] init];
    tmpRestorFoodCategory = [[NSMutableArray alloc] init];
    reservationFoodSelectedView.hidden = YES;
    reservationCitySelectedView.hidden = YES;
    reservationDateTimeView.hidden = YES;
    
    count = 1;
    
    NSDate *myDate = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    arrDate = [prettyVersion componentsSeparatedByString:@","];
    lblDayOfWeekReservation.text = arrDate[0];
    lblTimeForReservation.text = arrDate[2];
    lblDateForReservation.text = arrDate[1];
    [dateFormat setDateFormat:@"MMM d yyyy, hh:mm aa"];
    NSArray *sendDate = [[dateFormat stringFromDate:myDate] componentsSeparatedByString:@","];
    dateTimeForReservation = sendDate[0];
    timeForReservation = sendDate[1];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:myDate];
    APPDELEGATE.dayType = [comps weekday];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateForReserveTimes = [dateFormat stringFromDate:myDate];
    
    
    [dateFormat setDateFormat:@"hh:mmaa"];
    APPDELEGATE.currentTime = [dateFormat stringFromDate:myDate];
    
    searchedlstCity = APPDELEGATE.lstCity;
    searchedlstCityIds = APPDELEGATE.lstCityIds;
    searchedLstFood = APPDELEGATE.lstFood;
    searchedLstFoodIds = APPDELEGATE.lstFoodIds;
    
    
    arryFoodCaregory = [[NSMutableArray alloc] init];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:214.0f/255.0f green:29.0f/255.0f blue:8.0f/255.0f alpha:1.0f]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:reservationCitySelectedTableView]) {
        return [searchedlstCity count];
    }else if ([tableView isEqual:reservationFoodSelectedTableView]) {
        return [searchedLstFood count];
    }
    return 0;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}
- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:reservationCitySelectedTableView]) {
        return [searchedlstCity[indexPath.row] count] - 1;
    }else if ([tableView isEqual:reservationFoodSelectedTableView]) {
        return [searchedLstFood[indexPath.row] count] - 1;
    }
    return 0;
}
- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return YES;
    }
    
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ParentCityAndFoodItem";
    ParentCityAndFoodCell *cell = (ParentCityAndFoodCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [ParentCityAndFoodCell sharedCell];
    }
    if ([tableView isEqual:reservationCitySelectedTableView]) {
        [cell setCurWorkoutsItem:searchedlstCity[indexPath.row][0]];
        if ([searchedlstCity[indexPath.row] count] > 0)
            cell.expandable = YES;
        else
            cell.expandable = NO;
    }else if ([tableView isEqual:reservationFoodSelectedTableView]) {
        [cell setCurWorkoutsItem:searchedLstFood[indexPath.row][0]];
        if ([searchedLstFood[indexPath.row] count] > 0)
            cell.expandable = YES;
        else
            cell.expandable = NO;
    }
    
    
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"ChildCityAndFoodItem";
    ChildCityAndFoodCell *cell = (ChildCityAndFoodCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [ChildCityAndFoodCell sharedCell];
    }
    if ([tableView isEqual:reservationCitySelectedTableView]) {
        
        [cell setCurWorkoutsItem:[NSString stringWithFormat:@"%@", searchedlstCity[indexPath.row][indexPath.subRow]]];
        NSString *currentSelectedAreaStr = [[searchedlstCityIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
        if ([selectedAreaId isEqualToString:currentSelectedAreaStr]) {
            [cell.imgOption setImage:[UIImage imageNamed:@"checked_red.png"]];
        }else{
            [cell.imgOption setImage:[UIImage imageNamed:@"unchecked_blue.png"]];
        }
    }else if ([tableView isEqual:reservationFoodSelectedTableView]) {
        
        [cell setCurWorkoutsItem:[NSString stringWithFormat:@"%@", searchedLstFood[indexPath.row][indexPath.subRow]]];
        NSString *currentSelectedFoodCategoryStr = [[searchedLstFoodIds objectAtIndex:indexPath.row] objectAtIndex:0];
        NSString *currentSelectedFoodItemStr = [[searchedLstFoodIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
        if ([restroFoodCategory containsObject:[NSString stringWithFormat:@"%@_%@",currentSelectedFoodCategoryStr, currentSelectedFoodItemStr]]) {
            [cell.imgOption setImage:[UIImage imageNamed:@"checked_red.png"]];
        }else{
            [cell.imgOption setImage:[UIImage imageNamed:@"unchecked_blue.png"]];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
    if ([tableView isEqual:reservationCitySelectedTableView]) {
        if ([selectedAreaId isEqualToString:[[searchedlstCityIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow]]) {
            selectedAreaId = @"";
            [btnReservationCitySelectedView setTitle:@"City, Area" forState:UIControlStateNormal];
            [btnReservationCitySelectedView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            selectedAreaId = [[searchedlstCityIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
            
            [btnReservationCitySelectedView setTitle:[NSString stringWithFormat:@"%@, %@", [[searchedlstCity objectAtIndex:indexPath.row] objectAtIndex:0], [[searchedlstCity objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow]] forState:UIControlStateNormal];
            
            [btnReservationCitySelectedView setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        }
        [reservationCitySelectedTableView reloadData];
        reservationCitySelectedView.hidden = YES;
    }else if ([tableView isEqual:reservationFoodSelectedTableView]) {
        NSString *selectedFoodCategoryStr = [[searchedLstFoodIds objectAtIndex:indexPath.row] objectAtIndex:0];
        NSString *selectedFoodItemStr = [[searchedLstFoodIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
        if ([restroFoodCategory containsObject:[NSString stringWithFormat:@"%@_%@",selectedFoodCategoryStr, selectedFoodItemStr]]) {
            [restroFoodCategory removeObject:[NSString stringWithFormat:@"%@_%@",selectedFoodCategoryStr, selectedFoodItemStr]];
        }else{
            [restroFoodCategory addObject:[NSString stringWithFormat:@"%@_%@",selectedFoodCategoryStr, selectedFoodItemStr]];
        }
        NSString *strFoodCategory = [[searchedLstFood objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
        if ([arryFoodCaregory containsObject:strFoodCategory]) {
            [arryFoodCaregory removeObject:strFoodCategory];
        }else{
            [arryFoodCaregory addObject:strFoodCategory];
        }
        [reservationFoodSelectedTableView reloadData];
    }
}
- (IBAction)onMinusReservation:(id)sender {
    count--;
    if (count<1) {
        count = 1;
    }
    lblCountReservation.text = [NSString stringWithFormat:@"%d",count];
}

- (IBAction)onPlusReservation:(id)sender {
    count++;
    lblCountReservation.text = [NSString stringWithFormat:@"%d",count];
}



- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onFindRestaurants:(id)sender {
    NSMutableArray *arrAreaIdsForFiltering = [[NSMutableArray alloc] init];
    NSMutableArray *arrCityIdsForFiltering = [[NSMutableArray alloc] init];
    NSMutableArray *arrCuisinessIdsForFiltering = [[NSMutableArray alloc] init];
    NSMutableArray *arrFoodtypesIdsForFiltering = [[NSMutableArray alloc] init];
    NSMutableArray *arrRestroCategoriesIdsForFiltering = [[NSMutableArray alloc] init];
    
    NSString *areaIdsForFiltering = @"";
    NSString *cityIdsForFiltering = @"";
    NSString *cuisinessIdsForFiltering = @"";
    NSString *foodtypesIdsForFiltering = @"";
    NSString *restroCategoriesIdsForFiltering = @"";
    
    for (NSString *dictForFtCuCa in restroFoodCategory) {
        NSArray *arrFtCuCa = [dictForFtCuCa componentsSeparatedByString:@"_"];
        if (![arrCuisinessIdsForFiltering containsObject:arrFtCuCa[1]] && [arrFtCuCa[0] isEqualToString:@"CUISINE"]) {
            [arrCuisinessIdsForFiltering addObject:arrFtCuCa[1]];
        }
        if (![arrFoodtypesIdsForFiltering containsObject:arrFtCuCa[1]] && [arrFtCuCa[0] isEqualToString:@"FOOD TYPE"]) {
            [arrFoodtypesIdsForFiltering addObject:arrFtCuCa[1]];
        }
        if (![arrRestroCategoriesIdsForFiltering containsObject:arrFtCuCa[1]] && [arrFtCuCa[0] isEqualToString:@"RESTAURANT CATEGORY"]) {
            [arrRestroCategoriesIdsForFiltering addObject:arrFtCuCa[1]];
        }
    }
    
    int i = 0;
    for (i = 0; i < [arrAreaIdsForFiltering count]; i ++) {
        if ([areaIdsForFiltering isEqualToString:@""]) {
            areaIdsForFiltering = [arrAreaIdsForFiltering objectAtIndex:i];
        }else{
            areaIdsForFiltering = [NSString stringWithFormat:@"%@,%@",areaIdsForFiltering, [arrAreaIdsForFiltering objectAtIndex:i]];
        }
    }
    for (i = 0; i < [arrCityIdsForFiltering count]; i ++) {
        if ([cityIdsForFiltering isEqualToString:@""]) {
            cityIdsForFiltering = [arrCityIdsForFiltering objectAtIndex:i];
        }else{
            cityIdsForFiltering = [NSString stringWithFormat:@"%@,%@",cityIdsForFiltering, [arrCityIdsForFiltering objectAtIndex:i]];
        }
    }
    for (i = 0; i < [arrCuisinessIdsForFiltering count]; i ++) {
        if ([cuisinessIdsForFiltering isEqualToString:@""]) {
            cuisinessIdsForFiltering = [arrCuisinessIdsForFiltering objectAtIndex:i];
        }else{
            cuisinessIdsForFiltering = [NSString stringWithFormat:@"%@,%@",cuisinessIdsForFiltering, [arrCuisinessIdsForFiltering objectAtIndex:i]];
        }
    }
    for (i = 0; i < [arrFoodtypesIdsForFiltering count]; i ++) {
        if ([foodtypesIdsForFiltering isEqualToString:@""]) {
            foodtypesIdsForFiltering = [arrFoodtypesIdsForFiltering objectAtIndex:i];
        }else{
            foodtypesIdsForFiltering = [NSString stringWithFormat:@"%@,%@",foodtypesIdsForFiltering, [arrFoodtypesIdsForFiltering objectAtIndex:i]];
        }
    }
    for (i = 0; i < [arrRestroCategoriesIdsForFiltering count]; i ++) {
        if ([restroCategoriesIdsForFiltering isEqualToString:@""]) {
            restroCategoriesIdsForFiltering = [arrRestroCategoriesIdsForFiltering objectAtIndex:i];
        }else{
            restroCategoriesIdsForFiltering = [NSString stringWithFormat:@"%@,%@",restroCategoriesIdsForFiltering, [arrRestroCategoriesIdsForFiltering objectAtIndex:i]];
        }
    }
    
    if ([selectedAreaId isEqualToString:@""]) {
        [self showAlert:@"Please Select Area" :@"Error"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            ReservationResMainViewController *viewcontroller = [[ReservationResMainViewController alloc] initWithNibName:@"ReservationResMainViewController" bundle:nil];
            viewcontroller.foundRestroLists = [_responseObject objectForKey:@"resource"];
            viewcontroller.areaId = selectedAreaId;
            viewcontroller.persionsNumber = lblCountReservation.text;
            viewcontroller.dateForReservation = dateTimeForReservation;
            viewcontroller.timeForReservation = timeForReservation;
            viewcontroller.dateForReserveTimes = dateForReserveTimes;
            [self.navigationController pushViewController:viewcontroller animated:YES];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [self showAlert:_responseObject[@"message"] :@"Finding failed!"];
            [restroFoodCategory removeAllObjects];
            [reservationCitySelectedTableView reloadData];
            [reservationFoodSelectedTableView reloadData];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    if (![AppDelegate sharedDelegate].strDeviceToken)
    {
        [AppDelegate sharedDelegate].strDeviceToken = @"Simulator Test";
    }
    NSString *peopleNumber = lblCountReservation.text;
    NSString *reserveTime = [[dateForReserveTimes stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    [[Communication sharedManager] FindRestrestaurantsForReserve:APPDELEGATE.access_token restroArea:[selectedAreaId integerValue] cuisines:cuisinessIdsForFiltering foodTypes:foodtypesIdsForFiltering restroCategories:restroCategoriesIdsForFiltering serviceType:APPDELEGATE.serviceType reserveTime:reserveTime peopleNumber:[peopleNumber integerValue] successed:successed failure:failure];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onReservationFoodSelectedView:(id)sender {
    reservationFoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
    reservationFoodSelectedTableView.SKSTableViewDelegate = self;
    [reservationFoodSelectedView addSubview:reservationFoodSelectedTableView];
    reservationFoodSelectedView.hidden = NO;
}

- (IBAction)onReservationCitySelectedView:(id)sender {
    reservationCitySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
    reservationCitySelectedTableView.SKSTableViewDelegate = self;
    [reservationCitySelectedView addSubview:reservationCitySelectedTableView];
    reservationCitySelectedView.hidden = NO;
}
- (IBAction)onReservationFoodSelectedViewClose:(id)sender {
    [self.view endEditing:YES];
    reservationFoodSelectedTableView = nil;
    [reservationFoodSelectedTableView removeFromSuperview];
    reservationFoodSelectedView.hidden = YES;
    restroFoodCategory = [tmpRestorFoodCategory mutableCopy];
}

- (IBAction)onReservationCitySelectedViewClose:(id)sender {
    [self.view endEditing:YES];
    reservationCitySelectedTableView = nil;
    [reservationCitySelectedTableView removeFromSuperview];
    reservationCitySelectedView.hidden = YES;
}

- (IBAction)onReservationDateTimeView:(id)sender {
    reservationDateTimeView.hidden = NO;
}

- (IBAction)onReservationDateTimeClose:(id)sender {
    reservationDateTimeView.hidden = YES;
}

- (IBAction)onReservationDateTimeDone:(id)sender {
    reservationDateTimeView.hidden = YES;
    NSDate *myDate = dateTimePick.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    arrDate = [prettyVersion componentsSeparatedByString:@","];
    lblDayOfWeekReservation.text = arrDate[0];
    lblTimeForReservation.text = arrDate[2];
    lblDateForReservation.text = arrDate[1];
    [dateFormat setDateFormat:@"MMM d yyyy, hh:mm aa"];
    NSArray *sendDate = [[dateFormat stringFromDate:myDate] componentsSeparatedByString:@","];
    dateTimeForReservation = sendDate[0];
    timeForReservation = sendDate[1];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateForReserveTimes = [dateFormat stringFromDate:myDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:myDate];
    APPDELEGATE.dayType = [comps weekday];
    
    
    [dateFormat setDateFormat:@"hh:mmaa"];
    APPDELEGATE.currentTime = [dateFormat stringFromDate:myDate];
}

- (IBAction)onDoneFoodCategory:(id)sender {
    NSString *allFood = @"";
    if ([arryFoodCaregory count] > 0) {
        for (NSString *str in arryFoodCaregory) {
            if ([allFood isEqualToString:@""]) {
                allFood = str;
            }else{
                allFood  = [NSString stringWithFormat:@"%@,%@", allFood, str];
            }
        }
        [btnReservationFoodSelectedView setTitle:allFood forState:UIControlStateNormal];
        [btnReservationFoodSelectedView setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }else{
        [btnReservationFoodSelectedView setTitle:@"Cuisine, Food Type, Restaurant Category" forState:UIControlStateNormal];
        [btnReservationFoodSelectedView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [self.view endEditing:YES];
    reservationFoodSelectedTableView = nil;
    [reservationFoodSelectedTableView removeFromSuperview];
    reservationFoodSelectedView.hidden = YES;
    tmpRestorFoodCategory = [restroFoodCategory mutableCopy];
}
#pragma - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar isEqual:citySearchBar]) {
        reservationCitySelectedTableView = nil;
        [reservationCitySelectedTableView removeFromSuperview];
        citySearchBar.text = @"";
        [citySearchBar resignFirstResponder];
        
        searchedlstCity = APPDELEGATE.lstCity;
        searchedlstCityIds = APPDELEGATE.lstCityIds;
        
        reservationCitySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        reservationCitySelectedTableView.SKSTableViewDelegate = self;
        [reservationCitySelectedView addSubview:reservationCitySelectedTableView];
        
    }else if ([searchBar isEqual:foodSearchBar]){
        reservationFoodSelectedTableView = nil;
        [reservationFoodSelectedTableView removeFromSuperview];
        foodSearchBar.text = @"";
        [foodSearchBar resignFirstResponder];
        
        searchedLstFood = APPDELEGATE.lstFood;
        searchedLstFoodIds = APPDELEGATE.lstFoodIds;
        
        reservationFoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        reservationFoodSelectedTableView.SKSTableViewDelegate = self;
        [reservationFoodSelectedView addSubview:reservationFoodSelectedTableView];
    }}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar isEqual:citySearchBar]) {
        reservationCitySelectedTableView = nil;
        [reservationCitySelectedTableView removeFromSuperview];
        [citySearchBar resignFirstResponder];
        if (citySearchBar.text.length != 0) {
            NSMutableArray *tmpSearched = [NSMutableArray new];
            NSMutableArray *tmpSearchedIds = [NSMutableArray new];
            for (int i = 0 ; i < [APPDELEGATE.lstCity count]; i ++) {
                NSArray *oneCity = [[APPDELEGATE.lstCity objectAtIndex:i] copy];
                NSArray *oneCityIds = [[APPDELEGATE.lstCityIds objectAtIndex:i] copy];
                
                NSMutableArray *filteredArea = [NSMutableArray new];
                NSMutableArray *filteredAreaIds = [NSMutableArray new];
                [filteredArea addObject:oneCity[0]];
                [filteredAreaIds addObject:oneCityIds[0]];
                
                for (int j = 1 ; j < oneCity.count; j ++) {
                    NSString *strArea = oneCity[j];
                    if ([[strArea lowercaseString] rangeOfString:citySearchBar.text.lowercaseString].location != NSNotFound) {
                        [filteredArea addObject:oneCity[j]];
                        [filteredAreaIds addObject:oneCityIds[j]];
                    }
                }
                
                if ([filteredArea count] > 1) {
                    [tmpSearched addObject:[filteredArea copy]];
                    [tmpSearchedIds addObject:[filteredAreaIds copy]];
                }
            }
            searchedlstCity = [tmpSearched copy];
            searchedlstCityIds = [tmpSearchedIds copy];
        } else {
            searchedlstCity = APPDELEGATE.lstCity;
            searchedlstCityIds = APPDELEGATE.lstCityIds;
        }
        
        reservationCitySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        reservationCitySelectedTableView.SKSTableViewDelegate = self;
        [reservationCitySelectedView addSubview:reservationCitySelectedTableView];
    }else if ([searchBar isEqual:foodSearchBar]){
        reservationFoodSelectedTableView = nil;
        [reservationFoodSelectedTableView removeFromSuperview];
        [foodSearchBar resignFirstResponder];
        if (foodSearchBar.text.length != 0) {
            NSMutableArray *tmpSearched = [NSMutableArray new];
            NSMutableArray *tmpSearchedIds = [NSMutableArray new];
            for (int i = 0 ; i < [APPDELEGATE.lstFood count]; i ++) {
                NSArray *one = [[APPDELEGATE.lstFood objectAtIndex:i] copy];
                NSArray *oneIds = [[APPDELEGATE.lstFoodIds objectAtIndex:i] copy];
                
                NSMutableArray *filteredFood = [NSMutableArray new];
                NSMutableArray *filteredFoodIds = [NSMutableArray new];
                [filteredFood addObject:one[0]];
                [filteredFoodIds addObject:oneIds[0]];
                
                for (int j = 1 ; j < one.count; j ++) {
                    NSString *strFood = one[j];
                    if ([[strFood lowercaseString] rangeOfString:foodSearchBar.text.lowercaseString].location != NSNotFound) {
                        [filteredFood addObject:one[j]];
                        [filteredFoodIds addObject:oneIds[j]];
                    }
                }
                
                if ([filteredFood count] > 1) {
                    [tmpSearched addObject:[filteredFood copy]];
                    [tmpSearchedIds addObject:[filteredFoodIds copy]];
                }
            }
            searchedLstFood = [tmpSearched copy];
            searchedLstFoodIds = [tmpSearchedIds copy];
        } else {
            searchedLstFood = APPDELEGATE.lstFood;
            searchedLstFoodIds = APPDELEGATE.lstFoodIds;
        }
        
        reservationFoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        reservationFoodSelectedTableView.SKSTableViewDelegate = self;
        [reservationFoodSelectedView addSubview:reservationFoodSelectedTableView];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar isEqual:citySearchBar]) {
        reservationCitySelectedTableView = nil;
        [reservationCitySelectedTableView removeFromSuperview];
        if (citySearchBar.text.length != 0) {
            NSMutableArray *tmpSearched = [NSMutableArray new];
            NSMutableArray *tmpSearchedIds = [NSMutableArray new];
            for (int i = 0 ; i < [APPDELEGATE.lstCity count]; i ++) {
                NSArray *oneCity = [[APPDELEGATE.lstCity objectAtIndex:i] copy];
                NSArray *oneCityIds = [[APPDELEGATE.lstCityIds objectAtIndex:i] copy];
                
                NSMutableArray *filteredArea = [NSMutableArray new];
                NSMutableArray *filteredAreaIds = [NSMutableArray new];
                [filteredArea addObject:oneCity[0]];
                [filteredAreaIds addObject:oneCityIds[0]];
                
                for (int j = 1 ; j < oneCity.count; j ++) {
                    NSString *strArea = oneCity[j];
                    if ([[strArea lowercaseString] rangeOfString:citySearchBar.text.lowercaseString].location != NSNotFound) {
                        [filteredArea addObject:oneCity[j]];
                        [filteredAreaIds addObject:oneCityIds[j]];
                    }
                }
                
                if ([filteredArea count] > 1) {
                    [tmpSearched addObject:[filteredArea copy]];
                    [tmpSearchedIds addObject:[filteredAreaIds copy]];
                }
            }
            searchedlstCity = [tmpSearched copy];
            searchedlstCityIds = [tmpSearchedIds copy];
        } else {
            searchedlstCity = APPDELEGATE.lstCity;
            searchedlstCityIds = APPDELEGATE.lstCityIds;
        }
        
        reservationCitySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        reservationCitySelectedTableView.SKSTableViewDelegate = self;
        [reservationCitySelectedView addSubview:reservationCitySelectedTableView];
    }else if ([searchBar isEqual:foodSearchBar]){
        reservationFoodSelectedTableView = nil;
        [reservationFoodSelectedTableView removeFromSuperview];
        if (foodSearchBar.text.length != 0) {
            NSMutableArray *tmpSearched = [NSMutableArray new];
            NSMutableArray *tmpSearchedIds = [NSMutableArray new];
            for (int i = 0 ; i < [APPDELEGATE.lstFood count]; i ++) {
                NSArray *one = [[APPDELEGATE.lstFood objectAtIndex:i] copy];
                NSArray *oneIds = [[APPDELEGATE.lstFoodIds objectAtIndex:i] copy];
                
                NSMutableArray *filteredFood = [NSMutableArray new];
                NSMutableArray *filteredFoodIds = [NSMutableArray new];
                [filteredFood addObject:one[0]];
                [filteredFoodIds addObject:oneIds[0]];
                
                for (int j = 1 ; j < one.count; j ++) {
                    NSString *strFood = one[j];
                    if ([[strFood lowercaseString] rangeOfString:foodSearchBar.text.lowercaseString].location != NSNotFound) {
                        [filteredFood addObject:one[j]];
                        [filteredFoodIds addObject:oneIds[j]];
                    }
                }
                
                if ([filteredFood count] > 1) {
                    [tmpSearched addObject:[filteredFood copy]];
                    [tmpSearchedIds addObject:[filteredFoodIds copy]];
                }
            }
            searchedLstFood = [tmpSearched copy];
            searchedLstFoodIds = [tmpSearchedIds copy];
        } else {
            searchedLstFood = APPDELEGATE.lstFood;
            searchedLstFoodIds = APPDELEGATE.lstFoodIds;
        }
        
        reservationFoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        reservationFoodSelectedTableView.SKSTableViewDelegate = self;
        [reservationFoodSelectedView addSubview:reservationFoodSelectedTableView];
    }
}
@end
