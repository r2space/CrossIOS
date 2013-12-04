//
//  DAFileViewCell.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"

@interface DAFileViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgFileType;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;
@property (weak, nonatomic) IBOutlet UILabel *lblAt;
@property (weak, nonatomic) IBOutlet UILabel *lblFileSize;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTitle;

+ (DAFileViewCell *)initWithMessage:(DAFile *)file tableView:(UITableView *)tableView;

@end
