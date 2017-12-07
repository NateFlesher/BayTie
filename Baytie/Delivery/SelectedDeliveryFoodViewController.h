//
//  SelectedDeliveryFoodViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedDeliveryFoodViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UIView *navView;
    __weak IBOutlet UITableView *KindsSelectedFoodTableView;
    
    
    __weak IBOutlet UILabel *lblParFoodName;
    __weak IBOutlet UILabel *lblRestroName;
    
}

@property (nonatomic, retain) NSDictionary *parMenuFoodItem;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *restroId;

- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onDeliveryGoToCart:(id)sender;

@end
