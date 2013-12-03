//
//  DASettingViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DASettingViewController.h"
#import "DAHelper.h"

#define kInfoPlistKeyServerAddress  @"ServerAddress"
#define kInfoPlistKeyServerPort     @"ServerPort"

@interface DASettingViewController ()

@end

@implementation DASettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *serverAddress = [[NSBundle mainBundle] objectForInfoDictionaryKey:kInfoPlistKeyServerAddress];
    NSNumber *serverPort = [[NSBundle mainBundle] objectForInfoDictionaryKey:kInfoPlistKeyServerPort];
    
    self.txtServerAddress.text = serverAddress;
    self.txtServerPort.text = [serverPort stringValue];
    self.lblVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self showFreeSpace];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 离开页面时，设定服务器地址
    [[NSUserDefaults standardUserDefaults] setObject:self.txtServerAddress.text forKey:kServerAddress];
    [[NSUserDefaults standardUserDefaults] setInteger:self.txtServerPort.text.intValue forKey:kServerPort];
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *lbl = (UILabel *)[cell viewWithTag:11];
    lbl.text = [DAHelper localizedStringWithKey:@"setting.ipAddress" comment:@"地址"];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    lbl = (UILabel *)[cell viewWithTag:12];
    lbl.text = [DAHelper localizedStringWithKey:@"setting.port" comment:@"端口"];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    lbl = (UILabel *)[cell viewWithTag:21];
    lbl.text = [DAHelper localizedStringWithKey:@"setting.cacheSize" comment:@"缓存容量"];
    
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    lbl = (UILabel *)[cell viewWithTag:22];
    lbl.text = [DAHelper localizedStringWithKey:@"setting.clearCache" comment:@"清除缓存数据"];
    
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    lbl = (UILabel *)[cell viewWithTag:31];
    lbl.text = [DAHelper localizedStringWithKey:@"setting.logout" comment:@"注销"];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    lbl = (UILabel *)[cell viewWithTag:41];
    lbl.text = [DAHelper localizedStringWithKey:@"setting.version" comment:@"版本信息"];
}

// 收键盘
- (IBAction)didEndOnExit:(id)sender
{
    [((UITextField *)sender) resignFirstResponder];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
            UIActionSheet *as = [[UIActionSheet alloc] init];
            as.delegate = self;
            as.title = [DAHelper localizedStringWithKey:@"setting.confirmClearCache" comment:@"确定删除吗？"];
            [as addButtonWithTitle:[DAHelper localizedStringWithKey:@"btn.ok" comment:@"确定"]];
            [as addButtonWithTitle:[DAHelper localizedStringWithKey:@"btn.cancel" comment:@"取消"]];
            as.cancelButtonIndex = 1;
            as.destructiveButtonIndex = 1;
            [as showInView:self.view];
            
            // 并清除数据
            [DAHelper removeAllFile:@"/"];
        }
    }

    // 注销
    if (indexPath.section == 2) {
        [[DALoginModule alloc] logout:^(NSError *error){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jp.co.dreamarts.smart.message.userid"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jp.co.dreamarts.smart.message.password"];
            
            // 显示登陆画面
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NeedsLogin" object:nil]];
        }];
    }

}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [DAHelper removeAllFile:[DAHelper documentPath:@"/"]];
            [self showFreeSpace];
            break;
        case 1:
            break;
    }
    
}

- (void)showFreeSpace
{
    // 获取document目录的大小，计算占整体百分比
    uint64_t total = [DAHelper totalSpace];
    int cache = [DAHelper fts:[DAHelper documentPath:@"/"]];
    self.prvSpace.progress = cache / total;
}

@end
