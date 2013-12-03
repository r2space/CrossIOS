//
//  DAFileViewCell.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAFileViewCell.h"
#import "DAHelper.h"

@implementation DAFileViewCell

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

+ (DAFileViewCell *)initWithMessage:(DAFile *)file tableView:(UITableView *)tableView
{
    NSString *identifier = @"DAFileViewCell";
    
	DAFileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.lblDateTitle.text = [DAHelper localizedStringWithKey:@"file.date" comment:@"更新时间："];
    return cell;
}


@end
