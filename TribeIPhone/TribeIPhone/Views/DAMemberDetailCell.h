//
//  DAMemberDetailCell.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/18.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>

typedef void (^UserClicked)(NSString *userId);

@interface DAMemberDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowCount;

@property (retain, nonatomic) DAUser *user;
@property (strong, nonatomic) UserClicked userClickedBlock;
@property (strong, nonatomic) UserClicked followClickedBlock;

+(DAMemberDetailCell *)initWithMessage:(DAUser *)group tableView:(UITableView *)tableView;
- (IBAction)onNameClicked:(id)sender;
- (IBAction)onFollowClicked:(id)sender;

-(void)setFollow:(BOOL)isFollowed;
@end
