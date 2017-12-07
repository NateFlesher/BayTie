//
//  ViewController.h
//  RouteTrade
//
//  Created by stepanekdavid on 9/3/16.
//  Copyright © 2016 Sinday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
-(IBAction)btLoginClick:(id)sender;
-(IBAction)btSignupClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnlogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@end
