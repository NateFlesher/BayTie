//
//  CustomerProfileViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/13/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "CustomerProfileViewController.h"
#import "Communication.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Resize.h"
@interface CustomerProfileViewController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
{
    BOOL showKeyboard;
}
@end

@implementation CustomerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showControllers:NO];
    showKeyboard = NO;
    birthdayView.hidden = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [scrView addGestureRecognizer:gesture];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCurrentUserProfile];
}
- (void)getCurrentUserProfile{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[Communication sharedManager] GetUsersMe:APPDELEGATE.access_token successed:^(id _responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([_responseObject[@"code"] integerValue] == 0) {
            NSDictionary *dict = [_responseObject objectForKey:@"resource"];
            lblFName.text = [[dict objectForKey:@"profile"] objectForKey:@"f_name"];
            lblLName.text = [[dict objectForKey:@"profile"] objectForKey:@"l_name"];
            lblEmail.text = [dict objectForKey:@"email"];
            lblHomeNumber.text = [[dict objectForKey:@"profile"] objectForKey:@"home_number"];
            lblMobileNumber.text = [dict objectForKey:@"mobile_no"];
            if ([[[dict objectForKey:@"profile"] objectForKey:@"gender"] boolValue]) {
                lblSex.text = @"Male";
            }else{
                lblSex.text = @"Female";
            }
            lblBirthDay.text = [[dict objectForKey:@"profile"] objectForKey:@"birthdate"];
            
            [profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://82.223.68.80/%@",[[dict objectForKey:@"profile"] objectForKey:@"image"]]]];
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }
    } failure:^(NSError *_error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (!showKeyboard)
    {
        showKeyboard = YES;
        [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 236.0f)];
        //        if (IS_IPHONE_5) {
        //            [srcView setContentOffset:CGPointMake(0, 60) animated:YES];
        //        } else [srcView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}

-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtfNamePro)
    {
        [txtlNamePro becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 00) animated:YES];
    }
    else if (textField == txtlNamePro)
    {
        [txtEmailPro becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 20) animated:YES];
    }else if (textField == txtEmailPro)
    {
        [txtHomeNumPro becomeFirstResponder];
        [scrView setContentOffset:CGPointMake(0, 60) animated:YES];
    }else if (textField == txtHomeNumPro)
    {
        [self.view endEditing:YES];
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == txtfNamePro)
    {
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (textField == txtlNamePro)
    {
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (textField == txtEmailPro)
    {
        [scrView setContentOffset:CGPointMake(0, 20) animated:YES];
    }else if (textField == txtHomeNumPro)
    {
        [scrView setContentOffset:CGPointMake(0, 60) animated:YES];
    }else if (textField == txtBirthday){
        [scrView setContentOffset:CGPointMake(0, 160) animated:YES];
    }
    return YES;
}

- (void)showControllers:(BOOL)isShow{
    txtfNamePro.hidden = !isShow;
    txtlNamePro.hidden = !isShow;
    txtEmailPro.hidden = !isShow;
    txtHomeNumPro.hidden = !isShow;
    sexSelectedView.hidden = !isShow;
    btnProfileSave.hidden = !isShow;
    btnProfileEdit.hidden = isShow;
    txtBirthday.hidden = !isShow;
    btnBirthdayView.hidden = !isShow;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onProfileEdit:(id)sender {
    [self showControllers:YES];
    txtfNamePro.text = lblFName.text;
    txtlNamePro.text = lblLName.text;
    txtEmailPro.text = lblEmail.text;
    txtHomeNumPro.text = lblHomeNumber.text;
    if ([lblSex.text isEqualToString:@"Male"]) {
        btnMalePro.selected = YES;
        btnFemalePro.selected = NO;
    }else{
        btnFemalePro.selected = YES;
        btnMalePro.selected = NO;
    }
    txtBirthday.text = lblBirthDay.text;
}

- (IBAction)onProfileSave:(id)sender {
    if (!txtfNamePro.text.length)
    {
        [self showAlert:@"Please input Fist Name" :@"Input Error" :nil];
        return;
    }
    if (!txtlNamePro.text.length)
    {
        [self showAlert:@"Please input Last Name" :@"Input Error" :nil];
        return;
    }
    if (!txtEmailPro.text.length)
    {
        [self showAlert:@"Please input Email address" :@"Input Error" :nil];
        return;
    }
    if ([txtEmailPro.text rangeOfString:@" "].length != 0) {
        [self showAlert:@"Email field contains space. Please input again" :@"Input Error" :nil];
        return;
    }
    if (![self checkEmail:txtEmailPro]) {
        return;
    }
    if (!txtHomeNumPro.text.length)
    {
        [self showAlert:@"Please input Home Number" :@"Input Error" :nil];
        return;
    }
    
    [self.view endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSLog(@"%@", _responseObject);
        
        if ([[_responseObject objectForKey:@"code"] integerValue] == 0)
        {
            [self showControllers:NO];
            lblFName.text = txtfNamePro.text;
            lblLName.text = txtlNamePro.text;
            lblEmail.text = txtEmailPro.text;
            lblHomeNumber.text = txtHomeNumPro.text;
            if (btnMalePro.selected) {
                lblSex.text = @"Male";
            }else{
                lblSex.text = @"Female";
            }
            lblBirthDay.text = txtBirthday.text;
        }else if ([[_responseObject objectForKey:@"code"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:_responseObject[@"message"] :@"Login Error"];
        }else{
            [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
            [ self  showAlert: @"No Internet Connection." :@"Oops!"] ;
        }
    };
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {        
        [ MBProgressHUD hideHUDForView : self.navigationController.view animated : YES ] ;
        [ self  showAlert: @"No Internet Connection" :@"Oops!" :nil] ;
        
    };
    
    [[Communication sharedManager] UpdateProfile:APPDELEGATE.access_token firstName:txtfNamePro.text lastName:txtlNamePro.text userEmail:txtEmailPro.text homeNumber:txtHomeNumPro.text mobileNumber:lblMobileNumber.text gender:btnMalePro.selected?1:0 birthdate:txtBirthday.text successed:successed failure:failure];
    
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (BOOL)checkEmail:(UITextField *)checkText
{
    BOOL filter = YES ;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if([emailTest evaluateWithObject:checkText.text] == NO)
    {
        [self showAlert:@"Please enter a valid email address." :@"Error" :nil];
        return NO ;
    }
    
    return YES ;
}
- (IBAction)onMaleSelected:(id)sender {
    btnMalePro.selected = !btnMalePro.selected;
    if (btnMalePro.selected) {
        btnFemalePro.selected = NO;
    }else{
        btnFemalePro.selected = YES;
    }
}

- (IBAction)onFemaleSelected:(id)sender {
    btnFemalePro.selected = !btnFemalePro.selected;
    if (btnFemalePro.selected) {
        btnMalePro.selected = NO;
    }else{
        btnMalePro.selected = YES;
    }
}

- (IBAction)onProfileChange:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take profile photo", @"Choose from library", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onSetBirthday:(id)sender {
    birthdayView.hidden = NO;
}

- (IBAction)onCloseBirthdayView:(id)sender {
    birthdayView.hidden = YES;
}

- (IBAction)onUpdateBirthday:(id)sender {
    NSDate *myDate = birthDatePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY/MM/dd"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"time : %@", prettyVersion);
    txtBirthday.text =prettyVersion;
    birthdayView.hidden = YES;
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    
    //    if (buttonIndex == actionSheet.destructiveButtonIndex) {
    //        if (_photoMode == TAG_PROFILE_IMAGE){
    //            //[self removePhoto];
    //        }else if (_photoMode == TAG_WALLPAPER){
    //            // [self removeWallpaper];
    //        }
    //        return;
    //    }
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == actionSheet.numberOfButtons - 3) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.allowsEditing = YES;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    } else if (buttonIndex == actionSheet.numberOfButtons - 2) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.allowsEditing = YES;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    }
    
    imgPicker.delegate = self;
    
    // [self saveData];
    [self presentViewController:imgPicker animated:YES completion:nil];
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationDefault];
    image = [image fixOrientation];
    
    if (![UIImageJPEGRepresentation(image, 0.5f) writeToFile:[NSTemporaryDirectory() stringByAppendingString:@"/image.jpg"] atomically:YES]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save information. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^(void){
        [self uploadPhoto:image];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)uploadPhoto:(UIImage *)img{
    [MBProgressHUD showHUDAddedTo:APPDELEGATE.window animated:YES];
    void (^successed)(id responseObject) = ^(id responseObject) {
        [MBProgressHUD hideHUDForView:APPDELEGATE.window animated:YES];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [profileImage setImage:img];
        } else {
            [self showAlert:[responseObject objectForKey:@"message"] :@"Error" :nil];
        }
    };
    
    void (^failure)(NSError* error) = ^(NSError* error) {
        [MBProgressHUD hideHUDForView:APPDELEGATE.window animated:YES];
    };
    
    [[Communication sharedManager] UploadProfieImage:APPDELEGATE.access_token image:UIImageJPEGRepresentation(img, 0.5) successed:successed failure:failure];
    
}
@end
