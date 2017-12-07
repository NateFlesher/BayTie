//
//  SelectedDeliveryResViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedDeliveryResViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UIView *navView;
    
    __weak IBOutlet UITableView *deliveryFoodMenuTableView;
    
}

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onDeliveryResInfo:(id)sender;
- (IBAction)onDeliveryBasket:(id)sender;

@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *restroId;
@property (nonatomic, retain) NSString *locationId;

@property (weak, nonatomic) IBOutlet UILabel *lblRestroName;

@end
