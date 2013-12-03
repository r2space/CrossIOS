//
//  DAMemberSelectViewController.h
//  TribeIPhone
//
//  Created by kita on 13-4-25.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>
#import "DAMemberCell.h"
#import "DABaseViewController.h"

typedef void (^UsersDidSelected)(NSArray *users);


@interface DAMemberSelectViewController : DABaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSMutableArray *selectedUsers;
@property (nonatomic) BOOL allowMultiSelect;
@property(strong, nonatomic) UsersDidSelected selectedBlocks;
@property(retain,nonatomic) DAGroup *inGroup;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;

- (IBAction)onCancelClicked:(id)sender;
- (IBAction)onSelectClicked:(id)sender;
@end
