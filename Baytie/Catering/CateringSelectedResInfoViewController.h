//
//  CateringSelectedResInfoViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CateringSelectedResInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UIView *navView;
    __weak IBOutlet UIView *reviewsView;
    
    __weak IBOutlet UIImageView *logoImage;
    __weak IBOutlet UILabel *lblDescriptionForRestro;
    
    __weak IBOutlet UILabel *lblReviewsCount;
    __weak IBOutlet UIImageView *starImage1;
    __weak IBOutlet UIImageView *starImage2;
    __weak IBOutlet UIImageView *starImage3;
    __weak IBOutlet UIImageView *starImage4;
    __weak IBOutlet UIImageView *starImage5;
    
    __weak IBOutlet UILabel *lblRestroName;
    __weak IBOutlet UILabel *lblStatusForRestro;
    __weak IBOutlet UIImageView *statusImage;
    
    __weak IBOutlet UILabel *lblCuisines;
    __weak IBOutlet UILabel *lblWorkingTime;
    
    __weak IBOutlet UIImageView *featuredImage;
    __weak IBOutlet UIImageView *promoImage;
    
    __weak IBOutlet UIImageView *paymentDimage;
    __weak IBOutlet UIImageView *paymentCimage;
    __weak IBOutlet UIImageView *paymentKimage;
    
    __weak IBOutlet UITableView *reviewTableView;
    
}
- (IBAction)onMenuForRestro:(id)sender;

- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onReviewChecking:(id)sender;
- (IBAction)onCloseReviewView:(id)sender;

@property (nonatomic, retain) NSDictionary *restroDetails;
@end
