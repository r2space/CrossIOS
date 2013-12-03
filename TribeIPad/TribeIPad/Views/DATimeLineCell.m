//
//  DATimeLineCell.m
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/11.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DATimeLineCell.h"

@implementation DATimeLineCell

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

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect frame = self.txtMessage.frame;
    frame.size.height = self.txtMessage.contentSize.height;
    [self.txtMessage setFrame:frame];

}

- (NSInteger) cellHeight
{
    
    CGSize bounds = CGSizeMake(402, self.txtMessage.frame.size.height);
    CGSize size = [self.txtMessage.text sizeWithFont:self.txtMessage.font
                                constrainedToSize:bounds
                                    lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat h = size.height + 254-93;
//    if(c.imgAttach.hidden){
//        h-=66;
//    }
    
    return h;
    
//    return 158;
}

@end
