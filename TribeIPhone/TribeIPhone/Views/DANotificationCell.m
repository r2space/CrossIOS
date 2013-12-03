//
//  DANotificationCell.m
//  TribeIPhone
//
//  Created by kita on 13-5-3.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DANotificationCell.h"
#import "DAHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation DANotificationCell

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

+ (DANotificationCell *)initWithNotification:(DANotification *)notification tableView:(UITableView *)tableView
{
    NSString *identifier = @"DANotificationCell";
    DANotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.imgPortrait.layer.masksToBounds = YES;
    cell.imgPortrait.layer.cornerRadius = 5;
    
    DAUser *user = notification.user;
    if ([user getUserPhotoId] == nil) {
        cell.imgPortrait.image = [UIImage imageNamed:@"Default.png"];
    } else {
        if ([user isUserPhotoCatched]) {
            [[DAFileModule alloc] getPicture:[user getUserPhotoId] callback:^(NSError *err, NSString *pictureId){
                cell.imgPortrait.image = [DACommon getCatchedImage:pictureId];
            }];
        }
    }
    
    cell.lblName.text = [user getUserName];
    cell.lblContent.text = notification.content;
    cell.lblAt.text = [DAHelper stringFromISODateString:notification.createat];
    
    return cell;
}

@end
