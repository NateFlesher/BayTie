//
//  SelectedCateringResViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCateringResViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UIView *navView;
    __weak IBOutlet UITableView *cateringFoodMenuTableView;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onCateringResInfo:(id)sender;
- (IBAction)onCateringBasket:(id)sender;

@property (nonatomic, retain) NSString *locationId;
@property (nonatomic, retain) NSString *restroId;
@property (nonatomic, retain) NSString *areaId;
@property (weak, nonatomic) IBOutlet UILabel *lblRestroName;
@end
