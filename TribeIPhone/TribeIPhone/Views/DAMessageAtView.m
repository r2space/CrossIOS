//
//  DAMessageAtView.m
//  TribeIPhone
//
//  Created by kita on 13-4-21.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMessageAtView.h"


@implementation DAMessageAtView
{
    DAMessage *_message;
}

-(UIView *)initWithMessage:(DAMessage *)message frame:(CGRect)frame touchEnable:(BOOL)touchEnable
{
    self = [super init];
    _message = message;
//    touchLocations = [[NSMutableArray alloc] init];
//    touchContents = [[NSMutableArray alloc] init];
    
    [self setBackgroundColor:[UIColor clearColor]];
    float maxWidth = frame.size.width;
    float height = 0.0;
    float lineWidth = 0.0;
    if ([message hasAt]) {
        int i = 0;
        for (DAUser *user in message.part.atusers) {
            UILabel * label = [self getlabelwithMaxFrame:CGRectMake(0, 0, frame.size.width, 20) content:[NSString stringWithFormat:@"@%@", [user getUserName]]];
            if (lineWidth + label.frame.size.width > maxWidth) {
                lineWidth = 0;
                height += label.frame.size.height;
            }
            CGRect newFrame = CGRectMake(lineWidth, height, label.frame.size.width, label.frame.size.height);
            label.frame = newFrame;
            
            
//            [touchContents addObject:user];
//            [touchLocations addObject:[NSValue valueWithCGRect:label.frame]];
            
            [self addSubview:label];
            
            if (touchEnable) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = newFrame;
                btn.tag = i;
                [btn addTarget:self action:@selector(userClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
            
            lineWidth += label.frame.size.width + 5;
            i++;
        }
        
        i = 0;
        for (DAGroup *group in message.part.atgroups) {
            UILabel * label = [self getlabelwithMaxFrame:CGRectMake(0, 0, frame.size.width, 20) content:[NSString stringWithFormat:@"@%@", group.name.name_zh]];
            if (lineWidth + label.frame.size.width > maxWidth) {
                lineWidth = 0;
                height += label.frame.size.height;
            }
            CGRect newFrame = CGRectMake(lineWidth, height, label.frame.size.width, label.frame.size.height);
            label.frame = newFrame;
            
//            [touchContents addObject:group];
//            [touchLocations addObject:[NSValue valueWithCGRect:label.frame]];
            
            [self addSubview:label];
            
            if (touchEnable) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = newFrame;
                btn.tag = i;
                [btn addTarget:self action:@selector(groupClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }

            lineWidth += label.frame.size.width + 5;
            i++;
        }
        
        CGRect viewFrame = frame;
        viewFrame.size.height = height + 20;
        self.frame = viewFrame;
    }
    
    return self;
}

-(UILabel *)getlabelwithMaxFrame:(CGRect)frame content:(NSString *)content
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    UIFont *font = [UIFont systemFontOfSize:13];
    NSLineBreakMode breakMode = NSLineBreakByTruncatingTail;
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:1];
    [label setLineBreakMode:breakMode];
    [label setFont:font];
    
    CGSize maxLabelSize = label.frame.size;
    CGSize expectedLabelSize = [content sizeWithFont:font constrainedToSize:maxLabelSize lineBreakMode:breakMode];
    
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    newFrame.size.width = expectedLabelSize.width;
    label.frame = newFrame;
    
    label.text = content;
    
    return label;
}
                             
-(void)userClicked:(id)sender
{
    if (self.didTouchedBlocks != nil) {
        UIButton *btn = (UIButton *)sender;
        DAUser *user = [_message.part.atusers objectAtIndex:btn.tag];
        self.didTouchedBlocks(1, user._id);
    }
}

-(void)groupClicked:(id)sender
{
    if (self.didTouchedBlocks != nil) {
        UIButton *btn = (UIButton *)sender;
        DAGroup *group = [_message.part.atgroups objectAtIndex:btn.tag];
        self.didTouchedBlocks(2, group._id);
    }
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = event.allTouches.anyObject;
//    CGPoint touchPoint = [touch locationInView:self];
//    
//    for (int i = 0; i < touchLocations.count; i++) {
//        id obj = [touchLocations objectAtIndex:i];
//        CGRect touchZone = [obj CGRectValue];
//        if (CGRectContainsPoint(touchZone, touchPoint)) {
//            id content = [touchContents objectAtIndex:i];
//            if ([content isKindOfClass:[DAUser class]]) {
//                DAUser *user = (DAUser *)content;
//                [self.delegate atUserClicked:user];
//                return;
//            }
//            if ([content isKindOfClass:[DAGroup class]]) {
//                DAGroup *group = (DAGroup *)content;
//                [self.delegate atGroupClicked:group];
//                return;
//            }
//        }
//    }
//    
//    [self.nextResponder touchesEnded:touches withEvent:event];
//    
//}

@end
