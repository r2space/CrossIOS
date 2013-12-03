//
//  DAShortmailViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/26.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAShortmailViewController.h"
#import "DAShortmailViewCell.h"
#import "DAShortmailStoryViewController.h"
#import "DAHelper.h"

@interface DAShortmailViewController ()
@end

@implementation DAShortmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.barTitle.title = [DAHelper localizedStringWithKey:@"shortmail.title" comment:@"私信"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetch];
}

- (IBAction)onCancelTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAContact *contact = [list objectAtIndex:indexPath.row];
	DAShortmailViewCell *cell = [DAShortmailViewCell initWithMessage:contact tableView:tableView];
        
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAShortmailStoryViewController *shortmailStoryViewController =[[DAShortmailStoryViewController alloc]initWithNibName:@"DAShortmailStoryViewController" bundle:nil];
    shortmailStoryViewController.hidesBottomBarWhenPushed = YES;
    
    DAContact *contact = ((DAContact *)[list objectAtIndex:indexPath.row]);
    shortmailStoryViewController.contact = contact._id;
    shortmailStoryViewController.uid = contact.user._id;
    shortmailStoryViewController.name = contact.user.name.name_zh;
    
    [self.navigationController pushViewController:shortmailStoryViewController animated:YES];
    
}

- (IBAction)onAddTouched:(id)sender {
    DAShortmailStoryViewController *shortmailStoryViewController =[[DAShortmailStoryViewController alloc]initWithNibName:@"DAShortmailStoryViewController" bundle:nil];
    shortmailStoryViewController.hidesBottomBarWhenPushed = YES;
    
//    [self presentViewController:shortmailStoryViewController animated:YES completion:nil];
    [self.navigationController pushViewController:shortmailStoryViewController animated:YES];
}

#pragma mark - overwrite DABaseViewController

- (void)fetch
{
    if ([self preFetch]) {
        return;
    }
    
    [[DAShortmailModule alloc] getUsers:0 count:20 callback:^(NSError *error, DAContactList *contact){
        [self finishFetch:contact.items error:error];
    }];
}
@end
