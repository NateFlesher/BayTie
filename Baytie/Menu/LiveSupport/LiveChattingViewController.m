//
//  LiveChattingViewController.m
//  Baytie
//
//  Created by stepanekdavid on 9/29/16.
//  Copyright © 2016 Lovisa. All rights reserved.
//

#import "LiveChattingViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import <SocketRocket/SocketRocket.h>
@interface LiveChattingViewController ()<UITextViewDelegate, SRWebSocketDelegate>{
    BOOL keyboardShown;
    
    SRWebSocket *webSocketLive;
    
    NSInteger liveChatMode; //1:login 2:create message 3:update message 4:delete message 5:read message 6:typing
}

@end

@implementation LiveChattingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
//    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
//    
//    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
//    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
//    
//    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
//    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] init];
    bubbleTableView.bubbleDataSource = self;
    bubbleTableView.snapInterval = 120;
    bubbleTableView.showAvatars = YES;
    
    liveChatMode = 0;
    
    noConnectionView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [bubbleTableView addGestureRecognizer:tapGesture];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    
    [self reconnect:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [webSocketLive close];
    webSocketLive = nil;
    liveChatMode = 0;
}

///--------------------------------------
#pragma mark - Actions
///--------------------------------------

- (IBAction)reconnect:(id)sender
{
    webSocketLive.delegate = nil;
    [webSocketLive close];
    
    webSocketLive = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://82.223.68.80:8080"]];
    webSocketLive.delegate = self;
    
    //self.title = @"Opening Connection...";
    [webSocketLive open];
}

- (void)sendPing:(id)sender;
{
    [webSocketLive sendPing:nil];
}

///--------------------------------------
#pragma mark - SRWebSocketDelegate
///--------------------------------------

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    //self.title = @"Connected!";
    [webSocketLive send:[NSString stringWithFormat:@"{\"event\":\"login\",\"data\":{\"access_token\":\"%@\"}}", APPDELEGATE.access_token]];
    NSLog(@"{\"event\":\"login\",\"data\":{\"access_token\":\"%@\"}}", APPDELEGATE.access_token);
    liveChatMode = 1;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    //self.title = @"Connection Failed! (see logs)";
    webSocketLive = nil;
    liveChatMode = 0;
    noConnectionView.hidden = NO;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)string
{
    NSLog(@"Received \"%@\"", string);
    NSDictionary *_responseObject = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    if ([_responseObject objectForKey:@"success"] && [[_responseObject objectForKey:@"success"] boolValue] == YES) {
        switch (liveChatMode) {
            case 1://loging
                if ([_responseObject objectForKey:@"success"]) {
                    liveChatMode = 2;
                }
                break;
            case 2://create
                if ([_responseObject objectForKey:@"success"]) {
                    NSBubbleData *sayBubble = [NSBubbleData dataWithText:txtMessage.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
                    sayBubble.avatar_url = [NSURL URLWithString:APPDELEGATE.profileUrl];
                    [bubbleData addObject:sayBubble];
                    [bubbleTableView reloadData];
                    [self scrollToBottom:YES];
                    txtMessage.text = @"";
                }
                break;
            case 3://update
                if ([_responseObject objectForKey:@"success"]) {
                    NSLog(@"Sent successful!");
                }
                break;
            case 4://delete
                if ([_responseObject objectForKey:@"success"]) {
                    NSLog(@"Sent successful!");
                }
                break;
            case 5://read
                if ([_responseObject objectForKey:@"success"]) {
                    NSLog(@"Sent successful!");
                }
                break;
            case 6://typing
                if ([_responseObject objectForKey:@"success"]) {
                    NSLog(@"Sent successful!");
                }
                break;
                
            default:
                break;
        }
        
    }else if ([_responseObject objectForKey:@"event"] && [[NSString stringWithFormat:@"%@", [_responseObject objectForKey:@"event"]] isEqualToString:@"create message"]) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        [formatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: 0]];
//        NSDate *utcdate = [formatter dateFromString:[NSString stringWithFormat:@"%@",[[[_responseObject objectForKey:@"data"] objectForKey:@"message"] objectForKey:@"updated_time"]]];
//        NSBubbleData *replyBubble = [NSBubbleData dataWithText:[NSString stringWithFormat:@"%@",[[[_responseObject objectForKey:@"data"] objectForKey:@"message"] objectForKey:@"message"]] date:utcdate type:BubbleTypeSomeoneElse];
//        replyBubble.avatar = nil;
//        [bubbleData addObject:replyBubble];
//        [bubbleTableView reloadData];
        NSBubbleData *receiveBubble = [NSBubbleData dataWithText:[NSString stringWithFormat:@"%@",[[[_responseObject objectForKey:@"data"] objectForKey:@"message"] objectForKey:@"message"]] date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
        receiveBubble.avatar_url = nil;
        [bubbleData addObject:receiveBubble];
        [bubbleTableView reloadData];
        [self scrollToBottom:YES];
    } else if ([_responseObject objectForKey:@"success"] && [[_responseObject objectForKey:@"success"] boolValue] == NO){
        [self showAlert:[_responseObject objectForKey:@"data"] :@"Error"];
        noConnectionView.hidden = NO;
        [self.view endEditing:YES];
    }
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    //self.title = @"Connection Closed! (see logs)";
    webSocketLive = nil;
    liveChatMode = 0;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"WebSocket received pong");
}

-(void)handleTap
{
    [self.view endEditing:YES];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* userInfo = [aNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if(!keyboardShown)
    {
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    }
    
    keyboardHegith.constant = kbSize.height;
    [self.view layoutIfNeeded];
    
    if(!keyboardShown)
        [UIView commitAnimations];
    
    keyboardShown = YES;
    [self scrollToBottom : FALSE];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    keyboardShown = NO;
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    keyboardHegith.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

-(void)scrollToBottom : (BOOL)_animated
{
    CGFloat yoffset = 0;
    if (bubbleTableView.contentSize.height > bubbleTableView.bounds.size.height) {
        yoffset = bubbleTableView.contentSize.height - bubbleTableView.bounds.size.height;
    }
    
    [bubbleTableView setContentOffset:CGPointMake(0, yoffset) animated:_animated];
}
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}
- (IBAction)onMessageSend:(id)sender {
    //bubbleTableView.typingBubble = NSBubbleTypingTypeNobody;
    [webSocketLive send:[NSString stringWithFormat:@"{\"event\":\"create message\",\"data\":{\"message\":\"%@\",\"to\":\"admin\"}}", txtMessage.text]];//testing
    
    //[webSocketLive send:@"{\"event\":\"create message\",\"data\":{\"message\":\"I am jella\",\"to\":\"user_281\"}}"];//testing
    
}

- (IBAction)onBackMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRetryConnect:(id)sender {
    [self reconnect:nil];
    noConnectionView.hidden = YES;
}
@end
