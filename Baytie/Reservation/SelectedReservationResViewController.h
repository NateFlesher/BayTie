//
//  SelectedReservationResViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedReservationResViewController : UIViewController{

    __weak IBOutlet UILabel *lblRestroName;
    IBOutlet UIView *navView;
    __weak IBOutlet UIView *reservationsEditView;
    __weak IBOutlet UILabel *lblnumer;
    
    __weak IBOutlet UIImageView *logoImage;
    __weak IBOutlet UIImageView *statusImage;
    __weak IBOutlet UILabel *lblStatus;
    
    __weak IBOutlet UIImageView *ratingImage;
    __weak IBOutlet UILabel *lblDetailsForRes;
    __weak IBOutlet UILabel *lblWorkingTiemForWeekend;
    __weak IBOutlet UILabel *lblWorkingTimeForDays;
    
    
    __weak IBOutlet UIButton *btnLocation;
    __weak IBOutlet UILabel *lblAddressForReservation;
    __weak IBOutlet UILabel *lblPhoneNumberFor;
    __weak IBOutlet UILabel *lblReservationForPerson;
    
    __weak IBOutlet UILabel *lblReservationDate;
    __weak IBOutlet UILabel *lblReservationTime;
    __weak IBOutlet UILabel *lblPersions;
    
    __weak IBOutlet UIDatePicker *updateDatePick;
    
    __weak IBOutlet UILabel *timeSlot1;
    __weak IBOutlet UILabel *timeSlot2;
    __weak IBOutlet UILabel *timeSlot3;
    __weak IBOutlet UILabel *timeSlot4;
    __weak IBOutlet UILabel *timeslot5;
    
    __weak IBOutlet UIButton *btnTimeSlot1;
    __weak IBOutlet UIButton *btnTimeSlot2;
    __weak IBOutlet UIButton *btnTimeSlot3;
    __weak IBOutlet UIButton *btnTimeSlot4;
    __weak IBOutlet UIButton *btnTimeSlot5;
}
- (IBAction)onSelectedTime:(id)sender;



- (IBAction)onLocationForReservation:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onMakeReservation:(id)sender;

- (IBAction)onReservationsEditViewClose:(id)sender;
- (IBAction)onReservationUpdate:(id)sender;

- (IBAction)onMinusPsersons:(id)sender;
- (IBAction)onPlusPersons:(id)sender;

- (IBAction)onEdit:(id)sender;
@property (nonatomic, retain) NSDictionary *selectedRestroDict;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *persionsNumber;
@property (nonatomic, retain) NSString *dateForReservation;
@property (nonatomic, retain) NSString *timeForReservation;
@property (nonatomic, retain) NSString *dateForReserveTimes;
@property NSInteger slotIndex;
@end
