//
//  DAShortmailStoryController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/06/14.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAShortmailStoryController.h"
#import "DAMemberController.h"
#import "DAHelper.h"

@interface DAShortmailStoryController ()
{
    NSMutableArray  *mails;         // 信息数据
    NSDate          *timestamps;    // 时间间隔
    NSTimer         *timer;         // 涮新用计时器
    BOOL            puaseTimer;     // 暂停获取新信息
}

@end

@implementation DAShortmailStoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;

    // 没有用户ID，即新建会话，并显示用户选择画面
    if (self.contact == nil) {
        
        // 显示用户选择画面
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.kind = DAMemberListAll;
        members.hidesBottomBarWhenPushed = YES;
        members.selectedBlocks = ^(DAUser *user){
            
            // 取消用户选择，则退回
            if (user == nil) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            self.uid = user._id;
        };
        
        [self presentViewController:members animated:YES completion:nil];
    }

    // 设定背景颜色
    [self setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:221.0f/255.0f blue:243.0f/255.0f alpha:1]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 创建定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                             target:self
                                           selector:@selector(timerEvent:)
                                           userInfo:nil
                                            repeats:YES];
    
    // 启动定时器
    [timer fire];
}

// 停止定时器
- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

// 定时获取消息。发生滚动时，停止定时器
- (void)timerEvent:(NSTimer *)timer
{
    if (puaseTimer) {
        return;
    }
    
    // 获取对话信息
    [[DAShortmailModule alloc] getStoryByContact:self.contact
                                            date:[DAHelper currentDateString]
                                           count:6
                                        callback:^(NSError *error, DAShortmailList *shortmails){
                                            
                                            // 设定显示数据
                                            mails = [NSMutableArray arrayWithArray:shortmails.items];
                                            
                                            if (mails.count > 0) {
                                                // 设定初始时间
                                                DAShortmail *first = [mails objectAtIndex:0];
                                                timestamps = [DAHelper dateFromISODateString: first.createat];
                                                
                                                [self.tableView reloadData];
                                                [self scrollToBottomAnimated:YES];
                                            }
                                        }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mails.count;
}

#pragma mark - Messages view controller

// 设定消息的风格
- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAShortmail *shortmail = [mails objectAtIndex:indexPath.row];
    BOOL isSelf = [shortmail.createby isEqualToString:self.uid];
    
    return isSelf ? JSBubbleMessageStyleIncomingDefault : JSBubbleMessageStyleOutgoingDefault;
}

// 设定消息内容
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAShortmail *shortmail = [mails objectAtIndex:indexPath.row];
    return shortmail.message;
}

// 处理发送按钮按下的事件
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    // 生成待发送的信息数据
    DAShortmail *shortmail = [[DAShortmail alloc] init];
    shortmail.message = text;
    shortmail._id = self.uid;
    
    [[DAShortmailModule alloc] send:shortmail callback:^(NSError *error, DAShortmail *shortmail) {
        
        // 重新加载数据，播放发送声音
        [mails addObject:shortmail];
        [JSMessageSoundEffect playMessageSentSound];

        [self finishSend];
    }];
}

//- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DAShortmail *shortmail = [mails objectAtIndex:indexPath.row];
//    NSDate *current = [DAHelper dateWithISODateString:shortmail.createat];
//    
//    // 每隔60秒，显示时间
//    if ([current timeIntervalSinceDate:timestamps] >= 60) {
//        timestamps = current;
//        return YES;
//    }
//    return NO;
//}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAShortmail *shortmail = [mails objectAtIndex:indexPath.row];
    return [DAHelper dateFromISODateString:shortmail.createat];
}

// 每隔5个消息，显示一个时间
- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
    return JSMessagesViewTimestampPolicyEveryFive;
}


// 不起作用？
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self shouldHaveTimestampForRowAtIndexPath:indexPath];
}

// 滚动到最下面，从启Timer
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if (y >= h) {
        puaseTimer = NO;
        NSLog(@"start timer");
    }
}

// 滚动TableView，停止Timer
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    puaseTimer = YES;
    NSLog(@"stop timer");
}

@end
