//
//  SetLanguageViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/16/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetLanguageViewController : UIViewController{

    __weak IBOutlet UIButton *btnCheckAraLag;
    __weak IBOutlet UIButton *btnCheckEngLag;
}
- (IBAction)onAraLag:(id)sender;
- (IBAction)onEngLag:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSetLanguage:(id)sender;

@end
