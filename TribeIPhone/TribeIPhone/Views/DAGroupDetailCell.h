//
//  DAGroupDetailCell.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/17.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"

typedef void (^GroupClicked)(NSString *groupId);

@interface DAGroupDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgGroup;
@property (weak, nonatomic) IBOutlet UIImageView *imgLock;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberCount;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;

@property (retain, nonatomic) DAGroup *group;

@property (strong, nonatomic) GroupClicked nameClickedBlock;
@property (strong, nonatomic) GroupClicked joinClickedBlock;
@property (strong, nonatomic) GroupClicked inviteClickedBlock;
- (IBAction)onNameClicked:(id)sender;
- (IBAction)onInviteClicked:(id)sender;
- (IBAction)onJoinClicked:(id)sender;

+(DAGroupDetailCell *)initWithMessage:(DAGroup *)group tableView:(UITableView *)tableView;

- (void)setJoinAndInviteBtn:(BOOL)isMember owner:(BOOL)isOwner;
@end
