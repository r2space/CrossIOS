//
//  DAMemberCell.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/19.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMemberCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DAMemberCell

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

+ (DAMemberCell *)initWithMessage:(DAUser *)user tableView:(UITableView *)tableView
{
    NSString *identifier = @"DAMemberCell";
    
	DAMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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
    cell.lblGroup.text = user.department.name.name_zh;
    return cell;
}

@end
