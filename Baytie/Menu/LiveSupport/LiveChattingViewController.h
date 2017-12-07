//
//  LiveChattingViewController.h
//  Baytie
//
//  Created by stepanekdavid on 9/29/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"

@interface LiveChattingViewController : UIViewController<UIBubbleTableViewDataSource>{
    
    IBOutlet UIView *navView;
    __weak IBOutlet UIBubbleTableView *bubbleTableView;
    __weak IBOutlet UITextView *txtMessage;
    
    __weak IBOutlet NSLayoutConstraint *keyboardHegith;
    
    NSMutableArray *bubbleData;
    
    IBOutlet UIView *noConnectionView;
}
- (IBAction)onMessageSend:(id)sender;
- (IBAction)onBackMenu:(id)sender;
- (IBAction)onRetryConnect:(id)sender;

@end
