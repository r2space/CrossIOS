//
//  DAFriendViewCell.m
//  tribe
//
//  Created by 李 林 on 2012/12/15.
//  Copyright (c) 2012年 dac. All rights reserved.
//

#import "DAMemberViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DAMemberViewCell

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


+ (DAMemberViewCell *)initWithMessage:(DAUser *)user tableView:(UITableView *)tableView
{
    NSString *identifier = @"DAMemberViewCell";
    
	DAMemberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.imgPortrait.layer.masksToBounds = YES;
    cell.imgPortrait.layer.cornerRadius = 5;

    
    if ([user isUserPhotoCatched] || [user getUserPhotoId] == nil) {
        cell.imgPortrait.image = [user getUserPhotoImage];
    } else {
        [[DAFileModule alloc] getPicture:[user getUserPhotoId] callback:^(NSError *err, NSString *pictureId){
            cell.imgPortrait.image = [DACommon getCatchedImage:pictureId];
        }];
    }
    
    return cell;
}

@end
