//
//  DAGroupCell.h
//  TribeIPhone
//
//  Created by kita on 13-4-24.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>

@interface DAGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *groupIcon;

+(DAGroupCell *)initWithGroup:(DAGroup *)group tableView:(UITableView *)tableView;

@end
