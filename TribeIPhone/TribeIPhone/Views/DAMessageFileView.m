//
//  DAMessageFileView.m
//  TribeIPhone
//
//  Created by kita on 13-4-23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMessageFileView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DAMessageFileView
{
    DAMessage *_message;
}

-(UIView *)initWithMessage:(DAMessage *)message frame:(CGRect)frame touchEnable:(BOOL)touchEnable
{
    self = [super init];
    self.layer.cornerRadius = 5;
    _message = message;
    
    [self setBackgroundColor:[UIColor colorWithRed:212.2/255 green:212.0/255 blue:212.0/255 alpha:1.0]];
    if (message.attach.count > 0) {
        float fileX = 10;
        float fileY = 0;
        float fileWidth = frame.size.width - fileX *2;
        float fileHeight = 20;
        int i = 0;
        for (MessageAttach *file in message.attach) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(fileX, fileY, fileWidth, fileHeight)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setNumberOfLines:1];
            [label setLineBreakMode:NSLineBreakByTruncatingMiddle];
            [label setFont:[UIFont systemFontOfSize:12]];
//            label.text = file.filename;

            label.attributedText = [[NSAttributedString alloc] initWithString:file.filename attributes:@{NSUnderlineStyleAttributeName: @1}];
            
            fileY += fileHeight;
            
            [self addSubview:label];
            if (touchEnable) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = label.frame;
                btn.tag = i;
                [btn addTarget:self action:@selector(fileClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
            i++;
        }
        CGRect viewFrame = frame;
        viewFrame.size.height = fileHeight * message.attach.count;
        self.frame = viewFrame;
    }
    return self;
}

-(void)fileClicked:(id)sender
{
    if (self.didTouchedBlocks != nil) {
        UIButton *btn = (UIButton *)sender;
        MessageAttach *file = [_message.attach objectAtIndex:btn.tag];
        self.didTouchedBlocks(1, file.fileid);
    }
}
@end
