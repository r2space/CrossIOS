//
//  DABaseViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/05/17.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DABaseViewController.h"

@interface DABaseViewController ()

@end

@implementation DABaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 缺省值
    start = 0;
    count = 20;
    hasMore = YES;

    if (self.tableView != nil) {
        
        if (!withoutRefresh) {
            // 添加PullToRefresh控件
            refresh = [[UIRefreshControl alloc] init];
            refresh.tintColor = DAColor;
            [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
            [self.tableView addSubview:refresh];
        }
        
        if (!withoutGetMore) {
            // 添加Bottom的indicator
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.frame = CGRectMake(0, 0, 320, 44);
            self.tableView.tableFooterView = spinner;
        }
    }
}

// 进行获取后台数据之前的处理
// 1. 检测网络
// 2. 显示获取中信息
- (BOOL)preFetch
{
    // 判断网络是否可达
    if ([DAHelper isNetworkReachable]) {

        // 网络可达，显示等待
        [self showIndicator:@"Loading..."];
        return NO;
    }
    
    // 显示无法连接网络
    [self showMessage:[DAHelper localizedStringWithKey:@"error.network.dosnotWork" comment:@"无法连接网络"] detail:nil];

    // 停止UIRefreshControl控件
    [refresh endRefreshing];
    
    return YES;
}

// 获取后台数据的代码，在这个方法里实装
- (void)fetch
{
    NSLog(@"the fetch not implemented");
}

- (void)refresh
{
    start = 0;
    [self fetch];
}

// 获取后台数据结束后调用
// 1. 停止动画
// 2. 判断是否发生异常
// 3. 保存数据，并刷新
- (BOOL)finishFetch:(NSArray *)result error:(NSError *)error
{
    [progress hide:YES];
    [refresh endRefreshing];
    [((UIActivityIndicatorView *)self.tableView.tableFooterView) stopAnimating];

    // 判断是否有错误
    if (error == nil) {
        
        // 如果获取的实际数小于，指定的数，则标记为没有更多数据
        if (result.count < count) {
            hasMore = NO;
        } else {
            hasMore = YES;
        }
        
        // 保存数据
        if (list == nil || start == 0) {
            list = result;
        } else {
            list = [list arrayByAddingObjectsFromArray:result];
        }
        
        // 刷新UITableView
        [self.tableView reloadData];
        return NO;
    }
    
    // 显示错误消息
    [self showMessage:[DAHelper localizedStringWithKey:@"error.FetchError" comment:@"无法获取数据"] detail:[NSString stringWithFormat:@"error : %d", [error code]]];

    NSLog(@"%@", error);
    return YES;
}


// UITableView滚动到最下面时，显示获取更多数据的indicator
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (withoutGetMore || !hasMore) {
        return;
    }
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= -40) {
        [((UIActivityIndicatorView *)self.tableView.tableFooterView) startAnimating];
        
        start += count;
        [self fetch];
    }
}

- (BOOL)preUpdate
{
    // 判断网络是否可达
    if ([DAHelper isNetworkReachable]) {
        
        // 网络可达，显示等待
        return NO;
    }
    
    // 显示无法连接网络
    [self showMessage:[DAHelper localizedStringWithKey:@"error.network.dosnotWork" comment:@"无法连接网络"] detail:nil];
    
    return YES;
}

- (BOOL)finishFetchError:(NSError *)error
{
    if (error == nil) {
        return NO;
    }
    
    [self showMessage:[DAHelper localizedStringWithKey:@"error.FetchError" comment:@"无法获取数据"] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
    return YES;
}

- (BOOL)finishUpdateError:(NSError *)error
{
    [progress hide:YES];
    if (error == nil) {
        [self showTipMessage:[self successMessage]];
        return NO;
    }
    
    [self showMessage:[self errorMessage] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
    return YES;
}

- (NSString *)errorMessage
{
    return [DAHelper localizedStringWithKey:@"error.updateError" comment:@"更新失败"];
}

- (NSString *)successMessage
{
    return [DAHelper localizedStringWithKey:@"msg.updateSuccess" comment:@"更新成功"];
}

-(void)showTipMessage:(NSString *)message
{
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeText;
//    progress.dimBackground = YES;
    progress.labelText = message;
//    progress.margin = 10.f;
//    progress.yOffset = 50.f;
    progress.removeFromSuperViewOnHide = YES;
    [progress hide:YES afterDelay:0.6];
}

- (void)showMessage:(NSString *)message detail:(NSString *)detail
{
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeText;
    progress.dimBackground = YES;
    progress.labelText = message;
	progress.detailsLabelText = detail;
    progress.margin = 10.f;
    progress.yOffset = 50.f;
    progress.removeFromSuperViewOnHide = YES;
    [progress hide:YES afterDelay:5];
}

- (void)showIndicator:(NSString *)message
{
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = message;
    progress.color = DAColor;
    [progress show:YES];
}

@end
