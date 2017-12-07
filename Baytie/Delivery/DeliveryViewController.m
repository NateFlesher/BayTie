//
//  DeliveryViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "DeliveryViewController.h"
#import "MainMenuViewController.h"
#import "DeliveryResMainViewController.h"
#import "ParentCityAndFoodCell.h"
#import "ChildCityAndFoodCell.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"

#import "TESTViewController.h"

#import "Communication.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface DeliveryViewController ()<UISearchBarDelegate>{
    NSString *selectedRestroAreaIds;
    NSMutableArray * restroFoodCategory;
    NSMutableArray * tmpRestorFoodCategory;
    
    NSMutableArray * restroAreaIds;
    NSMutableArray * restroType;
    NSMutableArray * restroCuisine;
    NSMutableArray * restro_name;
    NSMutableArray * categoryId;
    
    NSArray *searchedlstCity;
    NSArray *searchedLstFood;
    NSArray *searchedlstCityIds;
    NSArray *searchedLstFoodIds;
    
    
    SKSTableView *citySelectedTableView;
    SKSTableView *FoodSelectedTableView;
    
    NSMutableArray *arryFoodCaregory;
}


@end

@implementation DeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    restroAreaIds = [[NSMutableArray alloc] init];
    restroType = [[NSMutableArray alloc] init];
    restroCuisine = [[NSMutableArray alloc] init];
    restro_name = [[NSMutableArray alloc] init];
    restroFoodCategory = [[NSMutableArray alloc] init];
    tmpRestorFoodCategory = [[NSMutableArray alloc] init];
    categoryId = [[NSMutableArray alloc] init];
    selectedRestroAreaIds = @"";
    citySelectedView.hidden = YES;
    foodSelectedView.hidden = YES;
    btnFindResGreenSub.hidden = YES;
    
    
    searchedlstCity = APPDELEGATE.lstCity;
    searchedlstCityIds = APPDELEGATE.lstCityIds;
    searchedLstFood = APPDELEGATE.lstFood;
    searchedLstFoodIds = APPDELEGATE.lstFoodIds;
    
    arryFoodCaregory = [[NSMutableArray alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    APPDELEGATE.dayType = [comps weekday];
    
    NSDate *myDate = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mmaa"];
    APPDELEGATE.currentTime = [dateFormat stringFromDate:myDate];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:107.0f/255.0f green:190.0f/255.0f blue:27.0f/255.0f alpha:1.0f]];
    
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
    if ([tableView isEqual:citySelectedTableView]) {
        return [searchedlstCity count];
    }else if ([tableView isEqual:FoodSelectedTableView]) {
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
    if ([tableView isEqual:citySelectedTableView]) {
        return [searchedlstCity[indexPath.row] count] - 1;
    }else if ([tableView isEqual:FoodSelectedTableView]) {
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
    if ([tableView isEqual:citySelectedTableView]) {
        [cell setCurWorkoutsItem:searchedlstCity[indexPath.row][0]];
        if ([searchedlstCity[indexPath.row] count] > 0)
            cell.expandable = YES;
        else
            cell.expandable = NO;
    }else if ([tableView isEqual:FoodSelectedTableView]) {
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
    if ([tableView isEqual:citySelectedTableView]) {
        [cell setCurWorkoutsItem:[NSString stringWithFormat:@"%@", searchedlstCity[indexPath.row][indexPath.subRow]]];
        NSString *currentSelectedAreaStr = [[searchedlstCityIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
        if ([selectedRestroAreaIds isEqualToString:currentSelectedAreaStr]) {
            [cell.imgOption setImage:[UIImage imageNamed:@"checked_green.png"]];
        }else{
            [cell.imgOption setImage:[UIImage imageNamed:@"unchecked_blue.png"]];
        }
    }else if ([tableView isEqual:FoodSelectedTableView]) {
        [cell setCurWorkoutsItem:[NSString stringWithFormat:@"%@", searchedLstFood[indexPath.row][indexPath.subRow]]];
        NSString *currentSelectedFoodCategoryStr = [[searchedLstFoodIds objectAtIndex:indexPath.row] objectAtIndex:0];
        NSString *currentSelectedFoodItemStr = [[searchedLstFoodIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
        if ([restroFoodCategory containsObject:[NSString stringWithFormat:@"%@_%@",currentSelectedFoodCategoryStr, currentSelectedFoodItemStr]]) {
            [cell.imgOption setImage:[UIImage imageNamed:@"checked_green.png"]];
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
    
    if ([tableView isEqual:citySelectedTableView]) {
        if ([selectedRestroAreaIds isEqualToString:[[searchedlstCityIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow]]) {
            selectedRestroAreaIds = @"";
            [btnCityArea setTitle:@"City, Area" forState:UIControlStateNormal];
            [btnCityArea setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            selectedRestroAreaIds = [[searchedlstCityIds objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow];
            
            [btnCityArea setTitle:[NSString stringWithFormat:@"%@, %@", [[searchedlstCity objectAtIndex:indexPath.row] objectAtIndex:0], [[searchedlstCity objectAtIndex:indexPath.row] objectAtIndex:indexPath.subRow]] forState:UIControlStateNormal];
            
            [btnCityArea setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        }
        NSLog(@"restroCityAndAreaIds   :     %@",selectedRestroAreaIds);
        [citySelectedTableView reloadData];
        citySelectedView.hidden = YES;
    }else if ([tableView isEqual:FoodSelectedTableView]) {
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
        
        if ([restroFoodCategory count] > 0) {
            btnFindResGreenSub.hidden = NO;
        }else{
            btnFindResGreenSub.hidden = YES;
        }
        
        NSLog(@"restroFoodCategory   :     %@",restroFoodCategory);
        [FoodSelectedTableView reloadData];
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onFindRestaurantsForDelivery:(id)sender {
    
    NSMutableArray *arrCuisinessIdsForFiltering = [[NSMutableArray alloc] init];
    NSMutableArray *arrFoodtypesIdsForFiltering = [[NSMutableArray alloc] init];
    NSMutableArray *arrRestroCategoriesIdsForFiltering = [[NSMutableArray alloc] init];
    
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
    if ([selectedRestroAreaIds isEqualToString:@""]) {
        [self showAlert:@"Please Select Area" :@"Error"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            DeliveryResMainViewController *viewcontroller = [[DeliveryResMainViewController alloc] initWithNibName:@"DeliveryResMainViewController" bundle:nil];
            viewcontroller.foundRestroLists = [_responseObject objectForKey:@"resource"];
            viewcontroller.areaId = selectedRestroAreaIds;
            [self.navigationController pushViewController:viewcontroller animated:YES];
            
        }else if ([[_responseObject objectForKey:@"code"] integerValue])
        {
            [self showAlert:_responseObject[@"message"] :@"Finding failed!"];
            [restroFoodCategory removeAllObjects];
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
    
    [[Communication sharedManager] FindRestrestaurants:APPDELEGATE.access_token restroArea:[selectedRestroAreaIds integerValue] cuisines:cuisinessIdsForFiltering foodTypes:foodtypesIdsForFiltering restroCategories:restroCategoriesIdsForFiltering serviceType:APPDELEGATE.serviceType successed:successed failure:failure];

    
    
//    TESTViewController *viewcontroller = [[TESTViewController alloc] initWithNibName:@"TESTViewController" bundle:nil];
//    [self.navigationController pushViewController:viewcontroller animated:YES];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onCitySelected:(id)sender {
    citySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
    citySelectedTableView.SKSTableViewDelegate = self;
    [citySelectedView addSubview:citySelectedTableView];
    citySelectedView.hidden = NO;
}

- (IBAction)onFoodCuisine:(id)sender {
    FoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
    FoodSelectedTableView.SKSTableViewDelegate = self;
    [foodSelectedView addSubview:FoodSelectedTableView];
    foodSelectedView.hidden = NO;
}

- (IBAction)onCloseCityView:(id)sender {
    [self.view endEditing:YES];
    citySelectedTableView = nil;
    [citySelectedTableView removeFromSuperview];
    citySelectedView.hidden = YES;
}

- (IBAction)onCloseFoodView:(id)sender {
    [self.view endEditing:YES];
    FoodSelectedTableView = nil;
    [FoodSelectedTableView removeFromSuperview];
    foodSelectedView.hidden = YES;
    restroFoodCategory = [tmpRestorFoodCategory mutableCopy];
}

- (IBAction)onDoneFoodCaregory:(id)sender {
    NSString *allFood = @"";
    if ([arryFoodCaregory count] > 0) {
        for (NSString *str in arryFoodCaregory) {
            if ([allFood isEqualToString:@""]) {
                allFood = str;
            }else{
                allFood  = [NSString stringWithFormat:@"%@,%@", allFood, str];
            }
        }
        [btnCuisineFood setTitle:allFood forState:UIControlStateNormal];
        [btnCuisineFood setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }else{
        [btnCuisineFood setTitle:@"Cuisine, Food Type, Restaurant Category" forState:UIControlStateNormal];
        [btnCuisineFood setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [self.view endEditing:YES];
    FoodSelectedTableView = nil;
    [FoodSelectedTableView removeFromSuperview];
    foodSelectedView.hidden = YES;
    
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
    if ([searchBar isEqual:CityAreaSearchBar]) {
        citySelectedTableView = nil;
        [citySelectedTableView removeFromSuperview];
        CityAreaSearchBar.text = @"";
        [CityAreaSearchBar resignFirstResponder];
        
        searchedlstCity = APPDELEGATE.lstCity;
        searchedlstCityIds = APPDELEGATE.lstCityIds;
        
        citySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        citySelectedTableView.SKSTableViewDelegate = self;
        [citySelectedView addSubview:citySelectedTableView];

    }else if ([searchBar isEqual:foodSearchBar]){
        FoodSelectedTableView = nil;
        [FoodSelectedTableView removeFromSuperview];
        foodSearchBar.text = @"";
        [foodSearchBar resignFirstResponder];
        
        searchedLstFood = APPDELEGATE.lstFood;
        searchedLstFoodIds = APPDELEGATE.lstFoodIds;
        
        FoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        FoodSelectedTableView.SKSTableViewDelegate = self;
        [foodSelectedView addSubview:FoodSelectedTableView];
    }}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar isEqual:CityAreaSearchBar]) {
        citySelectedTableView = nil;
        [citySelectedTableView removeFromSuperview];
        [CityAreaSearchBar resignFirstResponder];
        if (CityAreaSearchBar.text.length != 0) {
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
                    if ([[strArea lowercaseString] rangeOfString:CityAreaSearchBar.text.lowercaseString].location != NSNotFound) {
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
        
        citySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        citySelectedTableView.SKSTableViewDelegate = self;
        [citySelectedView addSubview:citySelectedTableView];
    }else if ([searchBar isEqual:foodSearchBar]){
        FoodSelectedTableView = nil;
        [FoodSelectedTableView removeFromSuperview];
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
        
        FoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        FoodSelectedTableView.SKSTableViewDelegate = self;
        [foodSelectedView addSubview:FoodSelectedTableView];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar isEqual:CityAreaSearchBar]) {
        citySelectedTableView = nil;
        [citySelectedTableView removeFromSuperview];
        if (CityAreaSearchBar.text.length != 0) {
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
                    if ([[strArea lowercaseString] rangeOfString:CityAreaSearchBar.text.lowercaseString].location != NSNotFound) {
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
        
        citySelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        citySelectedTableView.SKSTableViewDelegate = self;
        [citySelectedView addSubview:citySelectedTableView];
    }else if ([searchBar isEqual:foodSearchBar]){
        FoodSelectedTableView = nil;
        [FoodSelectedTableView removeFromSuperview];
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
        
        FoodSelectedTableView= [[SKSTableView alloc] initWithFrame:CGRectMake(26,104,269,368)];
        FoodSelectedTableView.SKSTableViewDelegate = self;
        [foodSelectedView addSubview:FoodSelectedTableView];
    }
}
@end
