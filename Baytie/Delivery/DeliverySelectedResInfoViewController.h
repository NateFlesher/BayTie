//
//  DeliverySelectedResInfoViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverySelectedResInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UIView *navView;
    __weak IBOutlet UIView *reviewsView;
    
    __weak IBOutlet UILabel *lblRestroName;
    __weak IBOutlet UIImageView *restroProfileImage;
    __weak IBOutlet UILabel *lblRestroDetails;
    
    __weak IBOutlet UILabel *lblReviewsCounts;
    __weak IBOutlet UIImageView *star1;
    __weak IBOutlet UIImageView *star2;
    __weak IBOutlet UIImageView *star3;
    __weak IBOutlet UIImageView *star4;
    __weak IBOutlet UIImageView *star5;
    
    __weak IBOutlet UILabel *lblRestroStatus;
    __weak IBOutlet UIImageView *promoImage;
    __weak IBOutlet UIImageView *featuredImage;
    __weak IBOutlet UIImageView *paymentDimage;
    __weak IBOutlet UIImageView *paymentCimage;
    __weak IBOutlet UIImageView *paymentKimage;
    __weak IBOutlet UIImageView *restroStatusImage;
    __weak IBOutlet UILabel *lblCuisines;
    __weak IBOutlet UILabel *lblWorkingTime;
    
    
    __weak IBOutlet UITableView *reviewsTableView;
}


- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onReviewsChecking:(id)sender;
- (IBAction)onCloseReviewview:(id)sender;
- (IBAction)onFoodMenu:(id)sender;

@property (nonatomic, retain) NSDictionary *restroDetails;
@end
