//
//  DANotificationViewController.m
//  TribeIPhone
//
//  Created by Antony on 13-5-13.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DANotificationViewController.h"
#import "DAShortmailViewCell.h"
#import "DAShortmailStoryViewController.h"
#import "DAMessageDetailViewController.h"

@interface DANotificationViewController ()
{
    NotificationType _content;  // 通知的种类
    NSArray *_notifications;
}

@end

@implementation DANotificationViewController

// 返回按钮
- (IBAction)onCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.barTitle.title = [DAHelper localizedStringWithKey:@"notification.title" comment:@"通知"];
    UITabBarItem *item = (UITabBarItem*)[[self.tabBar items] objectAtIndex:0];
    item.title = [DAHelper localizedStringWithKey:@"notification.atMe" comment:@"提到我"];
    
    item = (UITabBarItem*)[[self.tabBar items] objectAtIndex:1];
    item.title = [DAHelper localizedStringWithKey:@"notification.comment" comment:@"评论"];

    item = (UITabBarItem*)[[self.tabBar items] objectAtIndex:2];
    item.title = [DAHelper localizedStringWithKey:@"notification.notify" comment:@"通知"];
    
    // 高亮显示第一个Tab
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];

    // 获取[提到我]
    _content = NotificationTypeAt;
    [[DANotificationModule alloc] getNotificationListByType:NotificationTypeStringAt
                                                      start:0 count:20
                                                   callback:^(NSError *error, DANotificationList *notificationList){
        _notifications = notificationList.items;
        [self.tableView reloadData];
    }];
    
    // 显示件数
    [[DANotificationModule alloc] getUnreadNotificationListByType:NotificationTypeStringAt
                                                            start:0 count:20
                                                         callback:^(NSError *error, DANotificationList *notificationList){
        
        UITabBarItem *itemAr = [self.tabBar.items objectAtIndex:0];
        if (notificationList.total.intValue > 0) {
            itemAr.badgeValue = [notificationList.total stringValue];
        } else {
            itemAr.badgeValue = nil;
        }
    }];

}

// TabBar选择事件
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    _content = item.tag;
    
    switch (_content) {
        case NotificationTypeAt:// 提到我
        {
            _content = NotificationTypeAt;
            [[DANotificationModule alloc] getNotificationListByType:NotificationTypeStringAt
                                                              start:0 count:20
                                                           callback:^(NSError *error, DANotificationList *notificationList){
                _notifications = notificationList.items;
                [self.tableView reloadData];
            }];
            break;
        }
        case NotificationTypeReply:// 评论
        {
            _content = NotificationTypeReply;
            [[DANotificationModule alloc] getNotificationListByType:NotificationTypeStringReply
                                                              start:0 count:20
                                                           callback:^(NSError *error, DANotificationList *notificationList){
                _notifications = notificationList.items;
                [self.tableView reloadData];
            }];
            break;
        }
        case NotificationTypePrivateMessage:// 私信
        {
            _content = NotificationTypePrivateMessage;
            [[DAShortmailModule alloc] getUsers:0 count:20 callback:^(NSError *error, DAContactList *contact){
                _notifications = contact.items;
                [self.tableView reloadData];
            }];
            break;
        }
        case NotificationTypeSystemAlert:// 通知
        {
            [[DANotificationModule alloc] getNotificationListByType:@"invite,remove,follow" start:0 count:20
                                                           callback:^(NSError *error, DANotificationList *notificationList){
                _notifications = notificationList.items;
                [self.tableView reloadData];
            }];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _notifications.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_content == NotificationTypePrivateMessage) {
        DAContact *contact = [_notifications objectAtIndex:indexPath.row];
        DAShortmailViewCell *cells = [DAShortmailViewCell initWithMessage:contact  tableView:tableView];
        cells.lblName.text = contact.user.name.name_zh;
        return cells;
    }
    
    DANotification *notification = [_notifications objectAtIndex:indexPath.row];
    DANotificationCell *cell = [DANotificationCell initWithNotification:notification tableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 显示私信对话画面
    if (_content == NotificationTypePrivateMessage) {
        DAShortmailStoryViewController *shortmail =[[DAShortmailStoryViewController alloc]initWithNibName:@"DAShortmailStoryViewController" bundle:nil];
        shortmail.hidesBottomBarWhenPushed = YES;
        
        DAContact *contact = ((DAContact *)[_notifications objectAtIndex:indexPath.row]);
        shortmail.contact = contact._id;
        shortmail.uid = contact.user._id;
        shortmail.name = contact.user.name.name_zh;
        
        [self presentViewController:shortmail animated:YES completion:nil];
        return;
    }
    
    // 到消息详细画面
    if (_content == NotificationTypeAt) {
        DAMessageDetailViewController *detailViewController = [[DAMessageDetailViewController alloc] initWithNibName:@"DAMessageDetailViewController" bundle:nil];
        
        DANotification *notification = [_notifications objectAtIndex:indexPath.row];
        detailViewController.messageId = notification.objectid;
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self presentViewController:detailViewController animated:YES completion:nil];
    }

    // 标记为已读
    DANotification *notification = [_notifications objectAtIndex:indexPath.row];
    [[DANotificationModule alloc] read:notification._id callback:^(NSError *error, NSString *nid) {
        UITabBarItem *itemAr = [self.tabBar.items objectAtIndex:0];
        
        if (itemAr.badgeValue != nil) {
            if ([itemAr.badgeValue intValue] > 1) {
                itemAr.badgeValue = [NSString stringWithFormat:@"%d", [itemAr.badgeValue intValue] - 1];
            } else {
                itemAr.badgeValue = nil;
            }
        }
    }];
}

@end
