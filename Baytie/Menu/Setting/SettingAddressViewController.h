//
//  SettingAddressViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/16/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingAddressViewController : UIViewController{
    BOOL showKeyboard;
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UITextField *txtAddressName;
    __weak IBOutlet UITextField *txtCityName;
    __weak IBOutlet UITextField *txtAreaName;
    __weak IBOutlet UITextField *txtStreetName;
    __weak IBOutlet UITextField *txtBlock;
    __weak IBOutlet UITextField *txtHouse;
    __weak IBOutlet UITextField *txtFloor;
    __weak IBOutlet UITextField *txtApart;
    __weak IBOutlet UITextView *txtDirection;
    __weak IBOutlet UITableView *AreaSelectedTableView;
    __weak IBOutlet UIButton *btnSave;
    __weak IBOutlet UIView *CityAreaView;
    __weak IBOutlet UILabel *lblCityArea;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onCityNames:(id)sender;
- (IBAction)onAreaName:(id)sender;
- (IBAction)onCityAreaViewClose:(id)sender;

@property (nonatomic, retain) NSDictionary *addressInfo;
@end
