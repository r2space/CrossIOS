//
//  DAFirstViewController.m
//  tribe
//
//  Created by 李 林 on 2012/11/27.
//  Copyright (c) 2012年 dac. All rights reserved.
//

#import "DATimeLineViewController.h"
#import "DALeftSideViewController.h"
#import "DAHelper.h"

@interface DATimeLineViewController ()
{
    NSString *filterType;
    NSString *filterId;
}
@end

@implementation DATimeLineViewController
@synthesize titleFilter;
- (void)viewDidLoad
{
    [super viewDidLoad];
    titleFilter.title = 
    [DAHelper localizedStringWithKey:@"message.filter.allMessage" comment:@"全部消息"];
    filterType = @"all";
    [self fetch];
    
}

- (IBAction)onNotifiactionClicked:(id)sender
{
    
    DANotificationViewController *ctrl = [[DANotificationViewController alloc]initWithNibName:@"DANotificationViewController" bundle:nil];
    [self presentViewController:ctrl animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAMessage *message = [list objectAtIndex:indexPath.row];
	DAMessageCell *cell = [DAMessageCell initWithMessage:message tableView:tableView];
//    cell.parentController = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [DAMessageCell cellHeightWithMessage:[list objectAtIndex:indexPath.row]];
}

- (IBAction)onFilterClicked:(id)sender
{
    DALeftSideViewController *viewController = [[DALeftSideViewController alloc] initWithNibName:@"DALeftSideViewController" bundle:nil];
    [viewController setTitle:[DAHelper localizedStringWithKey:@"message.filter" comment:@"筛选"]];
    viewController.contentController = self;
    [DAHelper showPopup:viewController];
}

- (IBAction)onFilterIcoClicked:(id)sender
{
    if ([filterType isEqualToString:@"all"]) {
        [self onFilterClicked:nil];
    } else {
        filterType = @"all";
        titleFilter.title = [DAHelper localizedStringWithKey:@"message.filter.allMessage" comment:@"全部消息"];
        [self refresh];
    }
}


- (IBAction)onContributeClicked:(id)sender
{
    DAContributeViewController *ctrl = [[DAContributeViewController alloc] initWithNibName:@"DAContributeViewController" bundle:nil];
    [self presentViewController:ctrl animated:YES completion:nil];
}


-(void)filter:(NSString*)type filterid:(NSString *)filterid filtername:(NSString *)filtername
{
    titleFilter.title =[NSString stringWithFormat:@"%@ ",filtername];
    filterType = type;
    filterId = filterid;
    [self refresh];
    
}

-(void)displayFilter
{
    if ([filterType isEqualToString:@"all"]) {
        [self.barFilterIco setImage:[UIImage imageNamed:@"tool_down.png"]];
    } else {
        [self.barFilterIco setImage:[UIImage imageNamed:@"tool_multiply-symbol-mini.png"]];
    }
}

#pragma mark - overwrite DABaseViewController

- (void)fetch
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
    
    if ([filterType isEqualToString:@"user"]) {
        [[DAMessageModule alloc] getMessagesByUser:filterId start:start count:count before:before callback:^(NSError *error, DAMessageList *messageList){
            [self finishFetch:messageList.items error:error];
            
        }];
    }else if([filterType isEqualToString:@"group"] ){
        [[DAMessageModule alloc] getMessagesInGroup:filterId start:start count:count before:before callback:^(NSError *error, DAMessageList *messageList){
            [self finishFetch:messageList.items error:error];
        }];

    } else {
        [[DAMessageModule alloc] getMessagesInTimeLineStart:start count:count before:before callback:^(NSError *error, DAMessageList *messageList){
            [self finishFetch:messageList.items error:error];
        }];
    }
    
    [self displayFilter];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAMessageDetailViewController *detailViewController = [[DAMessageDetailViewController alloc] initWithNibName:@"DAMessageDetailViewController" bundle:nil];
    DAMessage *message = [list objectAtIndex:indexPath.row];
    detailViewController.messageId = message._id;
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
