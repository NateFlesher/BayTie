//
//  MyReservationsViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReservationsViewController : UIViewController{

    __weak IBOutlet UITableView *myReservationsTableView;
    __weak IBOutlet UIView *payViewForReservations;
    __weak IBOutlet UIView *detailsForReservations;
    
    //ratiingView
    __weak IBOutlet UIView *ratingView;
    __weak IBOutlet UITextView *txtReview;
    __weak IBOutlet UIButton *star1;
    __weak IBOutlet UIButton *star2;
    __weak IBOutlet UIButton *star3;
    __weak IBOutlet UIButton *star4;
    __weak IBOutlet UIButton *star5;
    
    //DetailsView
    __weak IBOutlet UIImageView *statusImageForDetails;
    __weak IBOutlet UIImageView *logoForDetails;
    __weak IBOutlet UILabel *lblStatusForDetails;
    __weak IBOutlet UIImageView *ratingForDetails;
    __weak IBOutlet UILabel *detailsForDetails;
    __weak IBOutlet UILabel *SatWorkingTimeForDetails;
    __weak IBOutlet UILabel *MonWorkingTimeForDetails;
    __weak IBOutlet UILabel *lblLocationForDetails;
    __weak IBOutlet UILabel *lblAddressForDetails;
    __weak IBOutlet UILabel *lblPhoneNumberForDetails;
    __weak IBOutlet UILabel *lblPersonNumberForDetails;
    __weak IBOutlet UILabel *lblReserveDateForDetails;
    __weak IBOutlet UILabel *lblReservationForDetails;
    
    //PaymentView
    __weak IBOutlet UILabel *lblLocationForPayment;
    __weak IBOutlet UILabel *lblAddressForPayment;
    __weak IBOutlet UILabel *lblPhoneForPayment;
    __weak IBOutlet UILabel *lblPersonNumForPayment;
    __weak IBOutlet UILabel *lblReserveDateForPayment;
    __weak IBOutlet UILabel *lblReservationTimeForPayment;
    __weak IBOutlet UIButton *btnPaymentKnetForPayment;
    __weak IBOutlet UIButton *btnPaymentCreditForPayment;
    __weak IBOutlet UILabel *lblPaymentAmountForPayment;
    
    
}

- (IBAction)onBack:(id)sender;
- (IBAction)onPayViewCancel:(id)sender;
- (IBAction)onDetailsViewCancel:(id)sender;

//RatingView
- (IBAction)onRatingViewClose:(id)sender;
- (IBAction)onRating:(id)sender;
//Payment
- (IBAction)onPaymentKnetForPayment:(id)sender;
- (IBAction)onPaymentCreditForPayment:(id)sender;

- (IBAction)onCheckout:(id)sender;

- (IBAction)onGainStars:(id)sender;
@end
