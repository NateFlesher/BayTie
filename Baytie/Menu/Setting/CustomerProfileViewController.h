//
//  CustomerProfileViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerProfileViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UITextField *txtfNamePro;
    __weak IBOutlet UITextField *txtlNamePro;
    __weak IBOutlet UITextField *txtEmailPro;
    __weak IBOutlet UITextField *txtHomeNumPro;
    __weak IBOutlet UIView *sexSelectedView;
    __weak IBOutlet UIButton *btnMalePro;
    __weak IBOutlet UIButton *btnFemalePro;
    __weak IBOutlet UITextField *txtBirthday;

    __weak IBOutlet UILabel *lblFName;
    __weak IBOutlet UILabel *lblLName;
    __weak IBOutlet UILabel *lblEmail;
    __weak IBOutlet UILabel *lblHomeNumber;
    __weak IBOutlet UILabel *lblMobileNumber;
    __weak IBOutlet UILabel *lblSex;
    __weak IBOutlet UILabel *lblBirthDay;
    
    __weak IBOutlet UIButton *btnProfileEdit;
    __weak IBOutlet UIButton *btnProfileSave;
    __weak IBOutlet UIImageView *profileImage;
    
    
    __weak IBOutlet UIButton *btnBirthdayView;
    
    
    //date view
    __weak IBOutlet UIView *birthdayView;
    __weak IBOutlet UIDatePicker *birthDatePicker;
    
}
- (IBAction)onBack:(id)sender;
- (IBAction)onProfileEdit:(id)sender;
- (IBAction)onProfileSave:(id)sender;

- (IBAction)onMaleSelected:(id)sender;
- (IBAction)onFemaleSelected:(id)sender;
- (IBAction)onProfileChange:(id)sender;

- (IBAction)onSetBirthday:(id)sender;

- (IBAction)onCloseBirthdayView:(id)sender;
- (IBAction)onUpdateBirthday:(id)sender;
@end
