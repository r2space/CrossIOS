//
//  DATimeLineViewController.m
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/11.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DATimeLineViewController.h"

@interface DATimeLineViewController () {
    DAMessageViewController *messageViewController;
    BOOL   added;
    
    NSArray *messages;
}

@end

@implementation DATimeLineViewController

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
    
//    [self.tblMessageList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [DAMessageListFetcher getMessagesInTimeLineWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didFinishFetchingMessageList:(DAMessageList *) messageList
{
    messages = messageList.items;
    [[self tblMessageList] reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DATimeLineCell *cell = (DATimeLineCell *)[tableView dequeueReusableCellWithIdentifier:@"DATimeLineCell"];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"DATimeLineCell" bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    
    
    DAMessage *message = [messages objectAtIndex:indexPath.row];
    
    cell.txtMessage.text = message.content;
    cell.lblAt.text = message.createat;
    cell.lblBy.text = message.createby;
    cell.lblCommentCount.text = [message.part.replyNums stringValue];
    cell.lblForwardCount.text = [message.part.forwardNums stringValue];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DATimeLineCell *cell = (DATimeLineCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"adfadfa %d, %d", cell.cellHeight, indexPath.row);
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *parentCtrl = [self parentViewController];

    if (messageViewController == NULL) {
        messageViewController =[[DAMessageViewController alloc]initWithNibName:@"DAMessageViewController" bundle:nil];
        [parentCtrl addChildViewController:messageViewController];
        [parentCtrl.view addSubview:messageViewController.view];
    }

    [messageViewController.view setCenter:CGPointMake(1200, 374)];
    [UIView transitionWithView:messageViewController.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone //any animation
                    animations:^ {
                        [messageViewController.view setCenter:CGPointMake(800, 374)];
                    }
                    completion:nil];

    
    
}

@end
