//
//  CateringSelectedResInfoViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "CateringSelectedResInfoViewController.h"
#import "MainMenuViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ReviewsOfUserCell.h"

@interface CateringSelectedResInfoViewController (){
    NSMutableArray *reviewsOfUser;
}

@end

@implementation CateringSelectedResInfoViewController
@synthesize restroDetails;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    reviewsView.hidden = YES;
    reviewsOfUser = [[NSMutableArray alloc] init];
    lblRestroName.text = [restroDetails objectForKey:@"restro_name"];
    if ([restroDetails objectForKey:@"cuisines"]) {
        NSString *allCuines = @"";
        for (NSDictionary *dc in [restroDetails objectForKey:@"cuisines"]) {
            if ([allCuines isEqualToString:@""]) {
                allCuines = [dc objectForKey:@"name"];
            }else{
                allCuines = [NSString stringWithFormat:@"%@, %@", allCuines, [dc objectForKey:@"name"]];
            }
        }
        lblCuisines.text = allCuines;
    }
    if (![[restroDetails objectForKey:@"restro_logo"] isKindOfClass:[NSNull class]])
    {
        NSArray *arrForUrl = [[restroDetails objectForKey:@"restro_logo"] componentsSeparatedByString:@"/"];
        NSString *logoUrl = [NSString stringWithFormat:@"http://82.223.68.80/%@/%@", arrForUrl[arrForUrl.count-2], arrForUrl[arrForUrl.count-1]];
        [logoImage setImageWithURL:[NSURL URLWithString:logoUrl]];
    }
    
    lblDescriptionForRestro.text = [restroDetails objectForKey:@"restro_description"];
    
    featuredImage.hidden = YES;
    promoImage.hidden = YES;
    if ([restroDetails objectForKey:@"restro_status"]) {
        NSString *string = @"" ;
        NSUInteger x = [[restroDetails objectForKey:@"restro_status"] integerValue];
        
        while (x>0) {
            string = [[NSString stringWithFormat: @"%lu,", x&1] stringByAppendingString:string];
            x = x >> 1;
        }
        NSArray *arr = [string componentsSeparatedByString:@","];
        if (arr.count > 1) {
            
            switch (arr.count) {
                case 2://1,"
                    featuredImage.hidden = YES;
                    promoImage.hidden = YES;
                    break;
                case 3://1,1,"
                    if ([arr[0] boolValue]) {
                        featuredImage.hidden = NO;
                    }else{
                        featuredImage.hidden = YES;
                    }
                    promoImage.hidden = YES;
                    break;
                case 4://1,1,1,"
                    if ([arr[0] boolValue]) {
                        featuredImage.hidden = NO;
                    }else{
                        featuredImage.hidden = YES;
                    }
                    if ([arr[1] boolValue]) {
                        promoImage.hidden = NO;
                    }else{
                        promoImage.hidden = YES;
                    }
                    break;
                case 5://1,1,1,1,"
                    if ([arr[1] boolValue]) {
                        featuredImage.hidden = NO;
                    }else{
                        featuredImage.hidden = YES;
                    }
                    if ([arr[2] boolValue]) {
                        promoImage.hidden = NO;
                    }else{
                        promoImage.hidden = YES;
                    }
                    break;
                default:
                    break;
            }
        }else{
            featuredImage.hidden = YES;
            promoImage.hidden = YES;
        }
    }
    paymentDimage.hidden = YES;
    paymentCimage.hidden = YES;
    paymentKimage.hidden = YES;
    if (![[restroDetails objectForKey:@"payment_method"] isKindOfClass:[NSNull class]]) {
        NSArray *paymentParsArray = [[restroDetails objectForKey:@"payment_method"] componentsSeparatedByString:@","];
        switch ([paymentParsArray count]) {
            case 1:
                paymentDimage.hidden = NO;
                [paymentDimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                break;
            case 2:
                paymentDimage.hidden = NO;
                [paymentDimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                if ([paymentParsArray[1] integerValue] !=4) {
                    paymentCimage.hidden = NO;
                    [paymentCimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[1]]]];
                }
                break;
            case 3:
                paymentDimage.hidden = NO;
                [paymentDimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                paymentCimage.hidden = NO;
                [paymentCimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[1]]]];
                if ([paymentParsArray[2] integerValue] !=4) {
                    paymentKimage.hidden = NO;
                    [paymentKimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[2]]]];
                }
                break;
            case 4:
                paymentDimage.hidden = NO;
                [paymentDimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[0]]]];
                paymentCimage.hidden = NO;
                [paymentCimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[1]]]];
                if ([paymentParsArray[2] integerValue] !=4) {
                    paymentKimage.hidden = NO;
                    [paymentKimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"payment_%@_img.png",paymentParsArray[2]]]];
                }
                break;
                
            default:
                paymentCimage.hidden = YES;
                paymentKimage.hidden = YES;
                paymentDimage.hidden = YES;
                break;
        }
    }
    switch (APPDELEGATE.dayType) {
        case 1:
            if (![[restroDetails objectForKey:@"sunday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"sunday_to"] isKindOfClass:[NSNull class]]) {
                lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", [restroDetails objectForKey:@"sunday_from"],[restroDetails objectForKey:@"sunday_to"]];
            }
            break;
        case 2:
            if (![[restroDetails objectForKey:@"monday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"monday_to"] isKindOfClass:[NSNull class]]) {
                lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", [restroDetails objectForKey:@"monday_from"],[restroDetails objectForKey:@"monday_to"]];
            }
            break;
        case 3:
            if (![[restroDetails objectForKey:@"tuesday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"tuesday_to"] isKindOfClass:[NSNull class]]) {
                lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", [restroDetails objectForKey:@"tuesday_from"],[restroDetails objectForKey:@"tuesday_to"]];
            }
            break;
        case 4:
            if (![[restroDetails objectForKey:@"wednesday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"wednesday_to"] isKindOfClass:[NSNull class]]) {
                lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", [restroDetails objectForKey:@"wednesday_from"],[restroDetails objectForKey:@"wednesday_to"]];
            }
            break;
        case 5:
            if (![[restroDetails objectForKey:@"thursday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"thursday_to"] isKindOfClass:[NSNull class]]) {
                lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", [restroDetails objectForKey:@"thursday_from"],[restroDetails objectForKey:@"thursday_to"]];
            }
            break;
        case 6:
            if (![[restroDetails objectForKey:@"friday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"friday_to"] isKindOfClass:[NSNull class]]) {
                lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", [restroDetails objectForKey:@"friday_from"],[restroDetails objectForKey:@"friday_to"]];
            }
            break;
        case 7:
            if (![[restroDetails objectForKey:@"saturday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"saturday_to"] isKindOfClass:[NSNull class]]) {
                lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", [restroDetails objectForKey:@"saturday_from"],[restroDetails objectForKey:@"saturday_to"]];
            }
            break;
            
        default:
            lblWorkingTime.text = [NSString stringWithFormat:@"%@ - %@", @"E",@"E"];
            break;
    }
    if (![[restroDetails objectForKey:@"rating"] isKindOfClass:[NSNull class]]) {
        switch ((int)roundf([[restroDetails objectForKey:@"rating"] floatValue])) {
            case 0:
                [starImage1 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage2 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage3 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage4 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage5 setImage:[UIImage imageNamed:@"blank_star.png"]];
                break;
            case 1:
                [starImage1 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage2 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage3 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage4 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage5 setImage:[UIImage imageNamed:@"blank_star.png"]];
                break;
            case 2:
                [starImage1 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage2 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage3 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage4 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage5 setImage:[UIImage imageNamed:@"blank_star.png"]];
                break;
            case 3:
                [starImage1 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage2 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage3 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage4 setImage:[UIImage imageNamed:@"blank_star.png"]];
                [starImage5 setImage:[UIImage imageNamed:@"blank_star.png"]];
                break;
            case 4:
                [starImage1 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage2 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage3 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage4 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage5 setImage:[UIImage imageNamed:@"blank_star.png"]];
                break;
            case 5:
                [starImage1 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage2 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage3 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage4 setImage:[UIImage imageNamed:@"fill_star.png"]];
                [starImage5 setImage:[UIImage imageNamed:@"fill_star.png"]];
                break;
            default:
                break;
        }
    }else{
        [starImage1 setImage:[UIImage imageNamed:@"blank_star.png"]];
        [starImage2 setImage:[UIImage imageNamed:@"blank_star.png"]];
        [starImage3 setImage:[UIImage imageNamed:@"blank_star.png"]];
        [starImage4 setImage:[UIImage imageNamed:@"blank_star.png"]];
        [starImage5 setImage:[UIImage imageNamed:@"blank_star.png"]];
    }
    if ([restroDetails objectForKey:@"busy"] && [[restroDetails objectForKey:@"busy"] integerValue] == 1) {
        [statusImage setImage:[UIImage imageNamed:@"status_open_red.png"]];
        lblStatusForRestro.text = @"Busy";
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mmaa"];
        NSInteger fromTime = 0;
        NSInteger toTime = 0;
        NSInteger currentTime = 0;
        switch (APPDELEGATE.dayType) {
            case 1:
                if (![[restroDetails objectForKey:@"sunday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"sunday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        lblStatusForRestro.text = @"Open";
                    }else{
                        [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        lblStatusForRestro.text = @"Close";
                    }
                }else{
                    [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    lblStatusForRestro.text = @"Close";
                }
                break;
            case 2:
                if (![[restroDetails objectForKey:@"monday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"monday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        lblStatusForRestro.text = @"Open";
                    }else{
                        [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        lblStatusForRestro.text = @"Close";
                    }
                }else{
                    [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    lblStatusForRestro.text = @"Close";
                }
                break;
            case 3:
                if (![[restroDetails objectForKey:@"tuesday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"tuesday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        lblStatusForRestro.text = @"Open";
                    }else{
                        [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        lblStatusForRestro.text = @"Close";
                    }
                }else{
                    [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    lblStatusForRestro.text = @"Close";
                }
                break;
            case 4:
                if (![[restroDetails objectForKey:@"wednesday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"wednesday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        lblStatusForRestro.text = @"Open";
                    }else{
                        [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        lblStatusForRestro.text = @"Close";
                    }
                }else{
                    [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    lblStatusForRestro.text = @"Close";
                }
                break;
            case 5:
                if (![[restroDetails objectForKey:@"thursday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"thursday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        lblStatusForRestro.text = @"Open";
                    }else{
                        [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        lblStatusForRestro.text = @"Close";
                    }
                }else{
                    [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    lblStatusForRestro.text = @"Close";
                }
                break;
            case 6:
                if (![[restroDetails objectForKey:@"friday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"friday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        lblStatusForRestro.text = @"Open";
                    }else{
                        [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        lblStatusForRestro.text = @"Close";
                    }
                }else{
                    [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    lblStatusForRestro.text = @"Close";
                }
                break;
            case 7:
                if (![[restroDetails objectForKey:@"saturday_from"] isKindOfClass:[NSNull class]] && ![[restroDetails objectForKey:@"saturday_to"] isKindOfClass:[NSNull class]]) {
                    fromTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_from"]]];
                    toTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:[restroDetails objectForKey:@"sunday_to"]]];
                    currentTime = [APPDELEGATE secondOfTheDay:[formatter dateFromString:APPDELEGATE.currentTime]];
                    if (currentTime > fromTime && currentTime < toTime) {
                        [statusImage setImage:[UIImage imageNamed:@"status_open_green.png"]];
                        lblStatusForRestro.text = @"Open";
                    }else{
                        [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                        lblStatusForRestro.text = @"Close";
                    }
                }else{
                    [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                    lblStatusForRestro.text = @"Close";
                }
                break;
                
            default:
                [statusImage setImage:[UIImage imageNamed:@"status_open_black.png"]];
                lblStatusForRestro.text = @"Close";
                break;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    
    [self getReviews];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)getReviews{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0) {
            lblReviewsCount.text = [NSString stringWithFormat:@"%lu reviews", [[_responseObject objectForKey:@"resource"] count]];
            reviewsOfUser = [_responseObject objectForKey:@"resource"];
            [reviewTableView reloadData];
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        
    } ;
    
    [[Communication sharedManager] GetRestaurantsRating:APPDELEGATE.access_token locationId:[[restroDetails objectForKey:@"location_id"] integerValue] restroId:[[restroDetails objectForKey:@"restro_id"] integerValue] successed:successed failure:failure];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [reviewsOfUser count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"ReviewOfUserItem";
    ReviewsOfUserCell *cell = (ReviewsOfUserCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [reviewsOfUser objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [ReviewsOfUserCell sharedCell];
    }
    [cell setReviewsItem:dict];
    cell.lblUserName.text = [dict objectForKey:@"user_name"];
    cell.lblMsg.text = [dict objectForKey:@"msg"];
    [cell.ratingImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%@.png",[dict objectForKey:@"star_value"]]]];
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

- (IBAction)onMenuForRestro:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    MainMenuViewController *viewcontroller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onReviewChecking:(id)sender {
    reviewsView.hidden = NO;
}

- (IBAction)onCloseReviewView:(id)sender {
    reviewsView.hidden = YES;
}
@end
