//
//  SelectedCateringFoodViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/14/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCateringFoodViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UIView *navView;
    __weak IBOutlet UILabel *txtParFoodName;    
    __weak IBOutlet UILabel *lblRestroName;
    __weak IBOutlet UITableView *CateringKindsSelectedFoodTableView;
}
@property (nonatomic, retain) NSDictionary *parMenuFoodItem;
@property (nonatomic, retain) NSString *selectedRestroName;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *restroId;
- (IBAction)onMenuView:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onBasketGoToCart:(id)sender;

@end
