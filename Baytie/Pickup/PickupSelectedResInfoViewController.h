//
//  PickupSelectedResInfoViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickupSelectedResInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UIView *navView;
    __weak IBOutlet UIView *reviewCheckingView;
    __weak IBOutlet UIImageView *restroLogoImage;
    __weak IBOutlet UILabel *lblRestroDescription;
    
    __weak IBOutlet UILabel *reviewCount;
    __weak IBOutlet UIImageView *star1Image;
    __weak IBOutlet UIImageView *star2Image;
    __weak IBOutlet UIImageView *star3Image;
    __weak IBOutlet UIImageView *star4Image;
    __weak IBOutlet UIImageView *star5Image;
    
    __weak IBOutlet UILabel *lblRestroStatus;
    __weak IBOutlet UIImageView *statusImage;
    __weak IBOutlet UIImageView *featureImage;
    __weak IBOutlet UIImageView *promoImage;
    __weak IBOutlet UIImageView *paymentD;
    __weak IBOutlet UIImageView *paymentC;
    __weak IBOutlet UIImageView *paymentK;
    __weak IBOutlet UILabel *lblCuisines;
    __weak IBOutlet UILabel *lblWorkingTime;
    
    __weak IBOutlet UITableView *reviewsTableView;
    
    __weak IBOutlet UILabel *restroName;
    
}

- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onReviewChecking:(id)sender;
- (IBAction)onCloseReviewView:(id)sender;
- (IBAction)onFoodMenu:(id)sender;
@property (nonatomic, retain) NSDictionary *restroDetails;
@end
