//
//  FaqViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/27/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaqViewController : UIViewController{
    __weak IBOutlet UITableView *FAQContentTableView;
    __weak IBOutlet UIView *faqContentView;
    __weak IBOutlet UILabel *faqTitle;
    __weak IBOutlet UILabel *lblFaqDescription;
    __weak IBOutlet UITextView *txtFaqDes;
}

- (IBAction)onBackMenu:(id)sender;
- (IBAction)onContentViewClose:(id)sender;
@end
