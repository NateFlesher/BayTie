//
//  SelectedPickupResViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPickupResViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    IBOutlet UIView *navView;
    __weak IBOutlet UITableView *pickupFoodMenuTableView;
}

@property (weak, nonatomic) IBOutlet UILabel *lblRestroName;
- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSelectedResInfo:(id)sender;
- (IBAction)onGoToCart:(id)sender;
@property (nonatomic, retain) NSString *restroId;
@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *areaId;
@end
