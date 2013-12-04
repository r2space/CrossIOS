//
//  DAMessageDetailViewController.h
//  TribeIPhone
//
//  Created by kita on 13-4-16.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"
#import "DAMemberCell.h"
#import "DAMessageDetailCell.h"
#import "DACommentCell.h"
#import "DAContributeViewController.h"
#import "DABaseViewController.h"

@interface DAMessageDetailViewController : DABaseViewController<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSString* messageId;
@property (weak, nonatomic) IBOutlet UITabBarItem *barLike;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;
- (IBAction)onCancelTouched:(id)sender;
- (IBAction)btnHomeTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end
