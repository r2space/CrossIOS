//
//  DAMemberController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/19.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMemberController.h"

@interface DAMemberController ()
{
    NSArray *theMembers;
    NSString *loginuid ;
}

@end

@implementation DAMemberController

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
    loginuid = [DALoginModule getLoginUserId];
    if ([self preFetch]) {
        return;
    }
    if (self.kind == DAMemberListAll) {
        self.barTitle.title = [DAHelper localizedStringWithKey:@"user.title.select" comment:@"选择用户"];
        self.backBtn.image = [UIImage imageNamed:@"tool_multiply-symbol-mini.png"];
        [[DAUserModule alloc] getUserListStart:0 count:20 keywords:@"" callback:^(NSError *error, DAUserList *users){
            [progress hide:YES];
            if (error != nil) {
                [self showMessage:[DAHelper localizedStringWithKey:@"error.FetchError" comment:@"无法获取数据"] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                return ;
            }
            
            //临时对应不能选择自己
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (DAUser *user in users.items) {
                if (![[DALoginModule getLoginUserId] isEqualToString:user._id]) {
                    [array addObject:user];
                }
            }
            theMembers = array;
            [self.tblUsers reloadData];
        }];

    }
    if (self.kind == DAMemberListFollower) {
        self.barTitle.title = [DAHelper localizedStringWithKey:@"user.follower" comment:@"粉丝"];
        
        [[DAUserModule alloc] getUserFollowerListByUser:self.uid start:0 count:20 keywords:@"" callback:^(NSError *error, DAUserList *users){
            [progress hide:YES];
            if (error != nil) {
                [self showMessage:[DAHelper localizedStringWithKey:@"error.FetchError" comment:@"无法获取数据"] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                return ;
            }
            theMembers = users.items;
            [self.tblUsers reloadData];
        }];
    }
    if (self.kind == DAMemberListFollowing) {
        self.barTitle.title = [DAHelper localizedStringWithKey:@"user.folling" comment:@"关注的人"];

        [[DAUserModule alloc] getUserFollowingListByUser:self.uid start:0 count:20 keywords:@"" callback:^(NSError *error, DAUserList *users){
            [progress hide:YES];
            if (error != nil) {
                [self showMessage:[DAHelper localizedStringWithKey:@"error.FetchError" comment:@"无法获取数据"] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                return ;
            }
            theMembers = users.items;
            [self.tblUsers reloadData];
        }];
    }
    if (self.kind == DAMemberListGroupMember) {
        self.barTitle.title = [DAHelper localizedStringWithKey:@"user.title" comment:@"成员"];
        [[DAGroupModule alloc] getUserListInGroup:self.gid start:0 count:20 callback:^(NSError *error, DAUserList *users){
            [progress hide:YES];
            if (error != nil) {
                [self showMessage:[DAHelper localizedStringWithKey:@"error.FetchError" comment:@"无法获取数据"] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                return ;
            }
            theMembers = users.items;
            [self.tblUsers reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return theMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAUser *user = [theMembers objectAtIndex:indexPath.row];
	DAMemberCell *cell = [DAMemberCell initWithMessage:user tableView:tableView];
    
    [cell lblName].text = [user getUserName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        if (self.selectedBlocks != nil) {
            self.selectedBlocks([theMembers objectAtIndex:indexPath.row]);
        }
    }];
}


- (IBAction)onCancelTouched:(id)sender {
    
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectedBlocks != nil) {
        self.selectedBlocks(nil);
    }
    if (self.kind == DAMemberListAll) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
