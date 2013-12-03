//
//  DATimeLineCell.h
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/11.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DATimeLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblAt;
@property (weak, nonatomic) IBOutlet UILabel *lblBy;
@property (weak, nonatomic) IBOutlet UILabel *lblForwardCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentCount;

- (NSInteger) cellHeight;

@end
