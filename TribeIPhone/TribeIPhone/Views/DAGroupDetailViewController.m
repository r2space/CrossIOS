//
//  DAGroupDetailViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/16.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAGroupDetailViewController.h"
#import "DAMemberController.h"
#import "DAGroupMoreContainerViewController.h"
#import "DALoginProxy.h"

@interface DAGroupDetailViewController ()
{
    DAGroup *theGroup;
    int _messagesTotal;
    BOOL isMember;
    DAGroupDetailCell *groupCell;
}

@end

@implementation DAGroupDetailViewController

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
    
    UINib *cellNib = [UINib nibWithNibName:@"DAMessageCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"DAImageMessageCell"];
    
    self.barTitle.title = [DAHelper localizedStringWithKey:@"group.homepage.title" comment:@"组/部门主页"];
    // Do any additional setup after loading the view from its nib.
    [self fetch];
}
- (void)viewDidAppear:(BOOL)animated
{
    DALoginProxy *loginProxy = [DALoginProxy sharedInstance];
    [loginProxy setCurVC:self];
    [super viewDidAppear:animated];
}

-(void)fetch
{
    if ([self preFetch]) {
        return;
    }
    // 获取最后一条数据的时间，作为获取更多数据时的标识
    NSString *before = @"";
    if (start > 0) {
        DAMessage *lastMsg = [list objectAtIndex:list.count - 1];
        before = lastMsg.createat;
    }
    [[DAGroupModule alloc] getGroup:self.gid callback:^(NSError *error, DAGroup *group){
        theGroup = group;
        
        // 判断当前用户是否是组的成员
        for (NSString *member in group.member) {
            if ([member isEqualToString:[DALoginModule getLoginUserId]]) {
                isMember = YES;
                break;
            }
        }
        
        self.barJoinOrLeave.title = isMember ? [DAHelper localizedStringWithKey:@"group.leave" comment:@"退出"] : [DAHelper localizedStringWithKey:@"group.join" comment:@"加入"];
        
        [[DAMessageModule alloc] getMessagesInGroup:group._id start:start count:count  before:before callback:^(NSError *error, DAMessageList *messageList){
            _messagesTotal = messageList.total.intValue;
            [self finishFetch:messageList.items error:error];
        }];
    }];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancelTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if(section == 1){
        return list.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        DAGroupDetailCell *cell = [DAGroupDetailCell initWithMessage:theGroup tableView:tableView];
        
        cell.lblName.text = theGroup.name.name_zh;
        cell.imgPortrait.image = [theGroup getGroupPhotoImage];
        
        if ([@"1" isEqualToString:theGroup.type]) {
            if ([@"1" isEqualToString:theGroup.secure]) {
                cell.imgGroup.image = [UIImage imageNamed:@"group_security.png"];
            } else {
                cell.imgGroup.image = [UIImage imageNamed:@"group.png"];
            }
        } else {
            cell.imgGroup.image = [UIImage imageNamed:@"department.png"];
        }
        [cell setJoinAndInviteBtn:isMember];
        
        cell.nameClickedBlock = ^(NSString *groupId){
            DAGroupMoreContainerViewController *moreViewController = [[DAGroupMoreContainerViewController alloc] initWithNibName:@"DAGroupMoreContainerViewController" bundle:nil];
            
            moreViewController.group = theGroup;
            [self.navigationController pushViewController:moreViewController animated:YES];
        };
        cell.inviteClickedBlock = ^(NSString *groupId){
            if ([self preUpdate]) {
                return;
            }
            DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
            members.kind = DAMemberListAll;
            members.hidesBottomBarWhenPushed = YES;
            members.selectedBlocks = ^(DAUser *user){
                if (user == nil) {
                    return ;
                }
                [[DAGroupModule alloc] joinGroup:theGroup._id uid:user._id callback:^(NSError *error, DAGroup *group) {
                    if ([self finishUpdateError:error]) {
                        return ;
                    }
//                    theGroup = group;
//                    [self.tableView reloadData];
                }];
            };
            //[self.navigationController pushViewController:members animated:YES];
            [self presentViewController:members animated:YES completion:nil];
        };
        cell.joinClickedBlock = ^(NSString *groupId){
            // 加入/退出
            if ([self preUpdate]) {
                return;
            }
            if (isMember) {
                [[DAGroupModule alloc] leaveGroup:theGroup._id uid:[DALoginModule getLoginUserId] callback:^(NSError *error, DAGroup *group) {
                    if (error != nil) {
                        [self showMessage:[self errorMessage] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                        return ;
                    }

                    [self didFinishJoin:group];
                }];
            } else {
                [[DAGroupModule alloc] joinGroup:theGroup._id uid:[DALoginModule getLoginUserId] callback:^(NSError *error, DAGroup *group) {
                    if (error != nil) {
                        [self showMessage:[self errorMessage] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                        return ;
                    }

                    [self didFinishJoin:group];
                }];
            }
        };
        groupCell = cell;
        return cell;
        
    } else {
        DAMessageCell *cell = [DAMessageCell initWithMessage:[list objectAtIndex:indexPath.row ] tableView:tableView indexPath:indexPath];
        //        cell.parentController = self;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        float lblHeight = 0;
        if (theGroup.description != nil && ![@"" isEqualToString:theGroup.description]) {
            CGSize expectedLabelSize = [theGroup.description sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 5000.0f) lineBreakMode:NSLineBreakByCharWrapping];
            lblHeight = expectedLabelSize.height + 10;
        }
        
        return 120 + lblHeight;
    }
    if (indexPath.section == 1) {
        return [DAMessageCell cellHeightWithMessage:[list objectAtIndex:indexPath.row ]];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (1 == item.tag) {
        // 成员
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.gid = theGroup._id;
        members.kind = DAMemberListGroupMember;
        
        members.hidesBottomBarWhenPushed = YES;
        //[self.navigationController pushViewController:members animated:YES];
        [self presentViewController:members animated:YES completion:nil];
    }

    if (2 == item.tag) {
        // 添加
        if ([self preUpdate]) {
            return;
        }
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.kind = DAMemberListAll;
        members.hidesBottomBarWhenPushed = YES;
        members.selectedBlocks = ^(DAUser *user){
            [[DAGroupModule alloc] joinGroup:theGroup._id uid:user._id callback:^(NSError *error, DAGroup *group) {
                if ([self finishUpdateError:error]) {
                    return ;
                }
            }];
        };
        //[self.navigationController pushViewController:members animated:YES];
        [self presentViewController:members animated:YES completion:nil];
    }

    if (3 == item.tag) {
        
        // 加入/退出
        if ([self preUpdate]) {
            return;
        }
        if (isMember) {
            [[DAGroupModule alloc] leaveGroup:theGroup._id uid:[DALoginModule getLoginUserId] callback:^(NSError *error, DAGroup *group) {
                if ([self finishUpdateError:error]) {
                    return ;
                }
                
                [self didFinishJoin:group];
            }];
        } else {
            [[DAGroupModule alloc] joinGroup:theGroup._id uid:[DALoginModule getLoginUserId] callback:^(NSError *error, DAGroup *group) {
                if ([self finishUpdateError:error]) {
                    return ;
                }
                
                [self didFinishJoin:group];
            }];
        }
    }

    if (4 == item.tag) {
        // 更多
        DAGroupMoreContainerViewController *moreViewController = [[DAGroupMoreContainerViewController alloc] initWithNibName:@"DAGroupMoreContainerViewController" bundle:nil];
        
        moreViewController.group = theGroup;
        [self.navigationController pushViewController:moreViewController animated:YES];
    }

}

- (void)didFinishJoin:(DAGroup *)group
{
    isMember = !isMember;
    [groupCell setJoinAndInviteBtn:isMember];
}

- (IBAction)btnHomeTouched:(id)sender {
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 0];
}
@end
