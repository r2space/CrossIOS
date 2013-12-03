//
//  DABaseViewController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/05/17.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "DAHelper.h"

@interface DABaseViewController : UIViewController <UIScrollViewDelegate>
{
    UIRefreshControl    *refresh;   // 下拉Table时显示的控件
    MBProgressHUD       *progress;  // 消息框
    
    int                 start;      // 获取数据的起始位置
    int                 count;      // 一次获取的数据个数
    BOOL                hasMore;    // 是否可以从后台获取更多的数据
    BOOL                withoutRefresh;
    BOOL                withoutGetMore;
    NSArray             *list;      // 数据
}

@property (weak, nonatomic) UITableView *tableView;

// tableView用
- (BOOL)preFetch;
- (void)fetch;
- (BOOL)finishFetch:(NSArray *)result error:(NSError *)error;
- (void)refresh;

//
- (BOOL)finishFetchError:(NSError *)error;

// update用
- (BOOL)preUpdate;
- (BOOL)finishUpdateError:(NSError *)error;


- (void)showMessage:(NSString *)message detail:(NSString *)detail;
- (void)showIndicator:(NSString *)message;

- (NSString *)errorMessage;
- (NSString *)successMessage;
@end
