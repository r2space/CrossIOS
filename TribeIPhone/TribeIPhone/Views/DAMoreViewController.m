//
//  DASettingViewController.m
//  tribe
//
//  Created by 李 林 on 2012/12/05.
//  Copyright (c) 2012年 dac. All rights reserved.
//

#import "DAMoreViewController.h"
#import "DAFileViewController.h"
#import "DAMemberMoreContainerViewController.h"
#import "DASettingContainerViewController.h"
#import "DAShortmailViewController.h"
#import "DAMemberViewController.h"
#import "DAGroupViewController.h"
#import "TribeSDKHeader.h"

@interface DAMoreViewController ()

@end

@implementation DAMoreViewController

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
	// Do any additional setup after loading the view.
    
    self.barTitle.title = [DAHelper localizedStringWithKey:@"home.more" comment:@"更多"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; // セクションは2個とします
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DAMoreViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:9];
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            lbl.text  = [DAHelper localizedStringWithKey:@"user.title" comment:@"成员"];
            img.image  = [UIImage imageNamed:@"people-communicate.png"];
        }
        if (1 == indexPath.row) {
            lbl.text  = [DAHelper localizedStringWithKey:@"group.title" comment:@"组/部门"];
            img.image = [UIImage imageNamed:@"table_business-team.png"];
        }
        if (2 == indexPath.row) {
            lbl.text  = [DAHelper localizedStringWithKey:@"account.title" comment:@"账户"];
            img.image = [UIImage imageNamed:@"people-single.png"];
        }
        if (3 == indexPath.row) {
            lbl.text  = [DAHelper localizedStringWithKey:@"shortmail.title" comment:@"私信"];
            img.image = [UIImage imageNamed:@"table_business-team.png"];
        }
        
    }
    
    if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            lbl.text  = [DAHelper localizedStringWithKey:@"setting.title" comment:@"设定"];
            img.image = [UIImage imageNamed:@"table_gear.png"];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        
        if (3 == indexPath.row) {
            DAShortmailViewController *shortmailViewController = [[DAShortmailViewController alloc]initWithNibName:@"DAShortmailViewController" bundle:nil];
            shortmailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shortmailViewController animated:YES];
        }
        
        // 成员
        if (0 == indexPath.row) {
            DAMemberViewController *memberViewController = [[DAMemberViewController alloc]initWithNibName:@"DAMemberViewController" bundle:nil];
            memberViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:memberViewController animated:YES];
        }
        
        // 组
        if (1 == indexPath.row) {
            DAGroupViewController *groupViewController = [[DAGroupViewController alloc]initWithNibName:@"DAGroupViewController" bundle:nil];
            groupViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupViewController animated:YES];
        }
        
        // 账户
        if (2 == indexPath.row) {
            DAMemberMoreContainerViewController *memberDetailViewController =[[DAMemberMoreContainerViewController alloc]initWithNibName:@"DAMemberMoreContainerViewController" bundle:nil];
            memberDetailViewController.hidesBottomBarWhenPushed = YES;
            memberDetailViewController.userid = [DALoginModule getLoginUserId];
            [self.navigationController pushViewController:memberDetailViewController animated:YES];
            
            
        }
    }
    
    if (1 == indexPath.section) {
        // 设定
        if (0 == indexPath.row) {
            DASettingContainerViewController *settingContainerViewController = [[DASettingContainerViewController alloc]initWithNibName:@"DASettingContainerViewController" bundle:nil];
            settingContainerViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingContainerViewController animated:YES];
        }
    }
}

@end
