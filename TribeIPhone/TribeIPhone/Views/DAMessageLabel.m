//
//  DAMessageLabel.m
//  TribeIPhone
//
//  Created by kita on 13-4-22.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMessageLabel.h"

@implementation DAMessageLabel

-(DAMessageLabel *)initWithContent:(NSString *)content font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode maxFrame:(CGRect)maxFrame
{
    self = [super initWithFrame:maxFrame];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setNumberOfLines:0];
    [self setLineBreakMode:breakMode];
    [self setFont:font];
    
    CGSize expectedLabelSize = [content sizeWithFont:font constrainedToSize:maxFrame.size lineBreakMode:breakMode];
    
    CGRect newFrame = maxFrame;
    newFrame.size.height = expectedLabelSize.height;
    self.frame = newFrame;
    self.text = content;
    
    return self;
}

@end
