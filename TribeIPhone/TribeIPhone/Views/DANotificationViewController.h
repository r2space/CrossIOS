//
//  DANotificationViewController.h
//  TribeIPhone
//
//  Created by Antony on 13-5-16.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"
#import "DANotificationCell.h"
#import "DAMessageCell.h"


typedef enum {
    NotificationTypeAt = 0,             // 提到我
    NotificationTypeReply = 1,          // 评论
    NotificationTypePrivateMessage = 2, // 私信
    NotificationTypeSystemAlert = 3     // 通知
} NotificationType;

#define NotificationTypeStringAt @"at"
#define NotificationTypeStringReply @"reply"

@interface DANotificationViewController : UIViewController

- (IBAction)onCancelClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;

@end
