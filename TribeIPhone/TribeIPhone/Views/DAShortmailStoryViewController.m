//
//  DAShortmailStoryViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/26.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAShortmailStoryViewController.h"
#import "DAMemberController.h"
#import "DAShortmailStoryController.h"

@interface DAShortmailStoryViewController ()
{
    NSMutableArray *theMails;
    SocketIO *socket;
    NSTimer *timer; // 涮新用计时器
    BOOL puaseTimer; //
}

@end

@implementation DAShortmailStoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 没有用户ID，即新建会话
    if (self.contact == nil) {
        
        // 显示用户选择画面
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.kind = DAMemberListAll;
        
        members.hidesBottomBarWhenPushed = YES;
        members.selectedBlocks = ^(DAUser *user){
            
            // 取消用户选择，则退回
            if (user == nil) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            self.uid = user._id;
            self.barUser.title = user.name.name_zh;
            [self appendJSViewController];
        };
        
        [self presentViewController:members animated:YES completion:nil];
        return;
    }
    
    self.barUser.title = self.name;
    [self appendJSViewController];
}

- (void)appendJSViewController
{
    DAShortmailStoryController *shortmailStory = [DAShortmailStoryController new];
    shortmailStory.contact = self.contact;
    shortmailStory.uid = self.uid;
    
    shortmailStory.view.frame = self.viewContainer.frame;
    [self addChildViewController:shortmailStory];
    [self.view addSubview:shortmailStory.view];
}

- (IBAction)onCancelTouched:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    
//    NSLog(@"DAShortmailStoryViewController viewDidAppear");
//    
//    // 连接WebSocket
//    if (socket || ![socket isConnected]) {
//        socket = [[SocketIO alloc] initWithDelegate:self];
//        [socket connectToHost:@"10.2.3.199" onPort:3001];
//        
//        // 发送用户ID
//        NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
//        [userinfo setObject:[DALoginModule getLoginUserId] forKey:@"id"];
//        [socket sendEvent:@"userid" withData:userinfo];
//    }
//    
//    [self scrollToBottom];
//    
//    timer = [NSTimer scheduledTimerWithTimeInterval:10.0
//                                             target:self
//                                           selector:@selector(timerEvent:)
//                                           userInfo:nil
//                                            repeats:YES];
//    
//    [timer fire];
//}
//
//- (void)timerEvent:(NSTimer *)timer
//{
//    if (puaseTimer) {
//        return;
//    }
//    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSLog(@"%@", [format stringFromDate:now]);
//
//    // 获取对话数据
//    [[DAShortmailModule alloc] getStoryByContact:self.contact
//                                            date:[format stringFromDate:now]
//                                           count:6
//                                        callback:^(NSError *error, DAShortmailList *shortmails){
//                                            
//                                            theMails = [NSMutableArray arrayWithArray:shortmails.items];
//                                            [self.tblStory reloadData];
//                                            [self scrollToBottom];
//                                        }];
//
//}
//
//- (void)scrollToBottom
//{
//    if (self.tblStory.contentSize.height > self.tblStory.frame.size.height)
//    {
//        CGPoint offset = CGPointMake(0, self.tblStory.contentSize.height - self.tblStory.frame.size.height);
//        [self.tblStory setContentOffset:offset animated:YES];
//    }
//}
//
//// 切断WebSocket连接
//- (void)viewWillDisappear:(BOOL)animated
//{
//    NSLog(@"DAShortmailStoryViewController viewWillDisappear");
//    [socket disconnect];
//    [timer invalidate];
//}
//
//// 显示键盘的时候，调整View的位置
//-(void)keyboardWillShow:(NSNotification*)note
//{
//    // get keyboard rect
//    CGRect keyboardRect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect bounds = [self.viewContainer bounds];
//    
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         self.viewContainer.frame = CGRectMake(0, - keyboardRect.size.height + 44, bounds.size.width, bounds.size.height);
//                     }];
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (IBAction)onCancelTouched:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (IBAction)onSendTouched:(id)sender
//{
//    DAShortmail *shortmail = [[DAShortmail alloc] init];
//    shortmail.message = self.txtContent.text;
//    shortmail._id = self.uid;
//
//    [[DAShortmailModule alloc] send:shortmail callback:^(NSError *error, DAShortmail *shortmail) {
//        
//        // 清除发送的文本框
//        self.txtContent.text = @"";
//        
//        // 重新加载数据
//        [theMails addObject:shortmail];
//        [self.tblStory reloadData];
//        [self scrollToBottom];
//    }];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return theMails.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DAShortmail *shortmail = [theMails objectAtIndex:indexPath.row];
//    
//    BOOL isSelf = [shortmail.createby isEqualToString:self.uid];
//    DAShortmailStoryViewCell *cell = [DAShortmailStoryViewCell initWithMessage:shortmail tableView:tableView isSelf:isSelf];
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    DAShortmail *shortmail = [theMails objectAtIndex:indexPath.row];
//
//    // 计算高度
//    CGSize expectedLabelSize = [shortmail.message sizeWithFont:[UIFont systemFontOfSize:16]
//                                             constrainedToSize:CGSizeMake(230.0f, 5000.0f)
//                                                 lineBreakMode:NSLineBreakByCharWrapping];
//    return expectedLabelSize.height < 44.0f ? 44.0f : (expectedLabelSize.height + 8.0f);
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//
//- (IBAction)onTextExit:(id)sender
//{
//    CGRect bounds = [self.viewContainer bounds];
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         self.viewContainer.frame = CGRectMake(0, 44, bounds.size.width, bounds.size.height);
//                     }];
//    
//    UITextField *textField = sender;
//    [textField resignFirstResponder];
//}
//
//// 接收到WebSocket数据时的处理
//- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
//{
//    NSDictionary *data = [packet dataAsJSON];
//    NSLog(@"didReceiveMessage() >>> data: %@", [data objectForKey:@"args"]);
//    
//    // TODO:添加到数据数组，涮新
//}
//
//- (void) socketIO:(SocketIO *)socket failedToConnectWithError:(NSError *)error
//{
//    NSLog(@"failedToConnectWithError() %@", error);
//}
//
//// 滚动到最下面，从启Timer
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.bounds;
//    CGSize size = scrollView.contentSize;
//    UIEdgeInsets inset = scrollView.contentInset;
//    
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    
//    if (y >= h) {
//        puaseTimer = NO;
//        NSLog(@"start timer");
//    }
//}
//
//// 滚动TableView，停止Timer
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    puaseTimer = YES;
//    NSLog(@"stop timer");
//}

@end
