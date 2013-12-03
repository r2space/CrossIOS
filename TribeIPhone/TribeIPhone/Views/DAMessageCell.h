//
//  DAMessageCell.h
//  TribeIPhone
//
//  Created by kita on 13-4-15.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>
#import "DAHelper.h"
#import "DAMessageAtView.h"
#import "DAMessageLabel.h"
#import "DAMemberDetailViewController.h"
#import "DAGroupDetailViewController.h"
#import "DAMessageFileView.h"


@interface DAMessageCell : UITableViewCell
{

}
@property (weak, nonatomic) IBOutlet UILabel *lblCreateAt;
@property (weak, nonatomic) IBOutlet UILabel *lblBy;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentCount;
@property (weak, nonatomic) IBOutlet UILabel *lblForwardCount;
@property (weak, nonatomic) IBOutlet UILabel *lblLikeCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UILabel *lblRange;
@property (weak, nonatomic) IBOutlet UIImageView *imgAttach;
@property (weak, nonatomic) IBOutlet UIImageView *rangIcon;
@property (weak, nonatomic) DAMessageAtView *atArea;
@property (weak, nonatomic) DAMessageFileView *fileArea;
@property (weak, nonatomic) UILabel *lblMessage;
@property (weak, nonatomic) UIViewController *parentController;

+(DAMessageCell *) initWithMessage:(DAMessage *)message tableView:(UITableView *)tableView;
+(float)cellHeightWithMessage:(DAMessage *)message;
-(void) cellInitWithMessage:(DAMessage *)message;
@end
