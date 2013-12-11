//
//  DAMemberDetailViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/17.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMemberDetailViewController.h"

@interface DAMemberDetailViewController ()
{
    DAUser *theUser;
    NSArray *theMessageList;
    int _messagesTotal;
    BOOL isFollowed;
    DAMemberDetailCell *userCell;
}

@end

@implementation DAMemberDetailViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.barTitle.title = [DAHelper localizedStringWithKey:@"user.homepage.title" comment:@"用户主页"];
    
    [self fetch];
    
    UINib *cellNib = [UINib nibWithNibName:@"DAMessageCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"DAMessageCell"];


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

    [[DAUserModule alloc] getUserById:self.uid callback:^(NSError *error, DAUser *user){
        if ([self finishFetchError:error]) {
            return ;
        }
        theUser = user;
        isFollowed = [user.follower containsObject:[DALoginModule getLoginUserId]];
        self.barFollow.title = isFollowed ? [DAHelper localizedStringWithKey:@"user.unfollow" comment:@"取消关注"] : [DAHelper localizedStringWithKey:@"user.follow" comment:@"关注"];
        [[DAMessageModule alloc] getMessagesByUser:theUser._id start:start count:count before:before callback:^(NSError *error, DAMessageList *messageList){
            
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
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        if (theUser == nil) {
            return 0;
        }
        return 1;
    }
    if(section == 1){
        return list.count;
    }
    return 0;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    }
//    return 50;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSLog(@"%d",section);
//    if (section == 1) {
//        UIView *containerView = [[UIView alloc] init];
//        [containerView setBackgroundColor:[UIColor whiteColor]];
//        
//        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectZero];
//        comment.backgroundColor = [UIColor clearColor];
//        comment.textColor = [UIColor blueColor];
//        comment.font = [UIFont systemFontOfSize:14];
//        comment.frame = CGRectMake(8, 15, 60, 20);
//        comment.text = @"消息";
//        
//        [containerView addSubview:comment];
//        return containerView;
//    }
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DAMemberDetailCell *cell = [DAMemberDetailCell initWithMessage:theUser tableView:tableView];
            
        cell.lblName.text = theUser.name.name_zh;
        cell.userClickedBlock = ^(NSString *userId){
            DAMemberMoreContainerViewController *moreViewController = [[DAMemberMoreContainerViewController alloc] initWithNibName:@"DAMemberMoreContainerViewController" bundle:nil];
            
            moreViewController.user = theUser;
            //TODO 对应用户详细BUG
            moreViewController.userid = theUser._id ;
            [self.navigationController pushViewController:moreViewController animated:YES];
        };
        [cell setFollow:isFollowed];
        cell.followClickedBlock = ^(NSString *userId){
            if ([self preUpdate]) {
                return;
            }
            if (isFollowed) {
                [[DAUserModule alloc] unfollow:theUser._id callback:^(NSError *error, NSString *uid){
//                    if ([self finishUpdateError:error]) {
//                        return ;
//                    }
                    if (error != nil) {
                        [self showMessage:[self errorMessage] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                        return ;
                    }
                    
                    isFollowed = !isFollowed;
                    [userCell setFollow:isFollowed];
                    // TODO 更新本地存储的user信息
                }];
            } else {
                [[DAUserModule alloc] follow:theUser._id callback:^(NSError *error, NSString *uid){
//                    if ([self finishUpdateError:error]) {
//                        return ;
//                    }
                    if (error != nil) {
                        [self showMessage:[self errorMessage] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
                        return ;
                    }
                    isFollowed = !isFollowed;
                    [userCell setFollow:isFollowed];
                    // TODO 更新本地存储的user信息
                }];
            }
        };
            //        NSLog(@"%@", theGroup.description);
            //        cell.lblName.text = theGroup.name.name_zh;
            //        cell.txtDescription.text = theGroup.description;
            //        cell.imgPortrait.image = [theGroup getGroupPhotoImage];
            //        cell.imgGroup.hidden = false;
        userCell = cell;
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
            return 120;
    }
    if (indexPath.section == 1) {
        return [DAMessageCell cellHeightWithMessage:[list objectAtIndex:indexPath.row ]];
    }
    return 0;
}

- (IBAction)onCancelTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHomeTouched:(id)sender {
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 0];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (1 == item.tag) {
        // 关注的人
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.uid = theUser._id;
        members.kind = DAMemberListFollowing;
        
        members.hidesBottomBarWhenPushed = YES;
        //[self.navigationController pushViewController:members animated:YES];
        [self presentViewController:members animated:YES completion:nil];
    }
    
    if (2 == item.tag) {
        // 粉丝
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.uid = theUser._id;
        members.kind = DAMemberListFollower;
        
        members.hidesBottomBarWhenPushed = YES;
        //[self.navigationController pushViewController:members animated:YES];
        [self presentViewController:members animated:YES completion:nil];
    }
    
    if (3 == item.tag) {
        // 关注/取消关注
        if ([self preUpdate]) {
            return;
        }
        if (isFollowed) {
            [[DAUserModule alloc] unfollow:theUser._id callback:^(NSError *error, NSString *uid){
                if ([self finishUpdateError:error]) {
                    return ;
                }
                isFollowed = !isFollowed;
                self.barFollow.title = isFollowed ? [DAHelper localizedStringWithKey:@"user.unfollow" comment:@"取消关注"] : [DAHelper localizedStringWithKey:@"user.follow" comment:@"关注"];
                // TODO 更新本地存储的user信息
            }];
        } else {
            [[DAUserModule alloc] follow:theUser._id callback:^(NSError *error, NSString *uid){
                if ([self finishUpdateError:error]) {
                    return ;
                }
                isFollowed = !isFollowed;
                self.barFollow.title = isFollowed ? [DAHelper localizedStringWithKey:@"user.unfollow" comment:@"取消关注"] : [DAHelper localizedStringWithKey:@"user.follow" comment:@"关注"];
                // TODO 更新本地存储的user信息
            }];
        }
    }
    
    if (4 == item.tag) {
        // 发私信
        
        
    }
    
    if (5 == item.tag) {
        // 更多
        DAMemberMoreContainerViewController *moreViewController = [[DAMemberMoreContainerViewController alloc] initWithNibName:@"DAMemberMoreContainerViewController" bundle:nil];
        
        moreViewController.user = theUser;
        [self.navigationController pushViewController:moreViewController animated:YES];
    }
}


@end
