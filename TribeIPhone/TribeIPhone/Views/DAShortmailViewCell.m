//
//  DAShortmailViewCell.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/26.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAShortmailViewCell.h"
#import "DAHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation DAShortmailViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(DAShortmailViewCell *)initWithMessage:(DAContact *)contact tableView:(UITableView *)tableView
{
    NSString *identifier = @"DAShortmailViewCell";
    DAUser *user = contact.user;
    
	DAShortmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.imgPortrait.layer.masksToBounds = YES;
    cell.imgPortrait.layer.cornerRadius = 5;
    cell.lblName.text = contact.user.name.name_zh;
    cell.lblContent.text = contact.lastMessage;
    cell.lblAt.text = [DAHelper stringFromISODateString:contact.editat];

    // 照片
    if (user.photo.small != nil) {
        [[DAFileModule alloc] getPicture:user.photo.small callback:^(NSError *err, NSString *pictureId){
            cell.imgPortrait.image = [DACommon getCatchedImage:pictureId];
        }];
    } else {
        cell.imgPortrait.image = [UIImage imageNamed:@"user_thumb.png"];
    }
    return cell;

}

@end
