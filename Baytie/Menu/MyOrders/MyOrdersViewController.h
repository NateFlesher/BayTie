//
//  MyOrdersViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrdersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    __weak IBOutlet UITableView *MyOrdersTableView;
    __weak IBOutlet UIView *ratingViewOfOrders;
    
    __weak IBOutlet UITextView *txtReview;
    
    __weak IBOutlet UIButton *btnStar1;
    __weak IBOutlet UIButton *btnStar2;
    __weak IBOutlet UIButton *btnStar3;
    __weak IBOutlet UIButton *btnStar4;
    __weak IBOutlet UIButton *btnStar5;
    
    __weak IBOutlet UIView *detailsOrdersView;
    
    //details
    
    __weak IBOutlet UIImageView *restroStatus;
    __weak IBOutlet UILabel *lblRestroStatus;
    __weak IBOutlet UIImageView *restroImg;
    __weak IBOutlet UILabel *restroName;
    __weak IBOutlet UILabel *orderStatus;
    __weak IBOutlet UILabel *lblOrderNm;
    __weak IBOutlet UILabel *lblOrderAmount;
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UILabel *lblPayment;
    __weak IBOutlet UILabel *lblDeliveryPersionName;
    __weak IBOutlet UILabel *lblDeliveryAddress;
    __weak IBOutlet UILabel *lblDeliveryPhoneNo;
    __weak IBOutlet UITableView *ItemTableView;
    __weak IBOutlet UIView *locationSelectedView;
    __weak IBOutlet UITableView *areaTableView;
}

- (IBAction)onBack:(id)sender;

- (IBAction)onRatingViewClose:(id)sender;
- (IBAction)onRateItForOrder:(id)sender;


- (IBAction)onGainStars:(id)sender;

- (IBAction)onCloseDetailsOrderView:(id)sender;

@end
