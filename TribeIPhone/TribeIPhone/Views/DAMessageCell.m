//
//  DAMessageCell.m
//  TribeIPhone
//
//  Created by kita on 13-4-15.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMessageCell.h"
#import <QuartzCore/QuartzCore.h>

#define CONTENT_LABEL_TO_TOP 37.0f
#define CONTENT_LABEL_TO_LEFT 70.0f
#define BUTTON_AREA_HEIGHT 35.0f

@interface DAMessageCell ()
{
    
}
@end

@implementation DAMessageCell


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

-(CGFloat) cellHeight
{
//    return self.frame.size.height;
    return self.lblMessage.frame.size.height + self.atArea.frame.size.height + CONTENT_LABEL_TO_TOP + BUTTON_AREA_HEIGHT;
}


+(DAMessageCell *)initWithMessage:(DAMessage *)message tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"DAImageMessageCell";
    
    DAMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell cellInitWithMessage:message];
    
    return cell;
}

+(float)cellHeightWithMessage:(DAMessage *)message
{
    float maxWidth = 233.0f;
    float height = 0;
    
    // top
    height += CONTENT_LABEL_TO_TOP;
    
    // content
    
    UIFont *font = [UIFont systemFontOfSize:12];
    float lblMaxHeight = font.lineHeight * 5; // show 5 lines
    DAMessageLabel *label = [[DAMessageLabel alloc] initWithContent:message.content font:font breakMode:NSLineBreakByTruncatingTail maxFrame:CGRectMake(CONTENT_LABEL_TO_LEFT,height,maxWidth,lblMaxHeight)];
    height += label.frame.size.height;
    
    DAMessageAtView *view = [[DAMessageAtView alloc] initWithMessage:message frame:CGRectMake(CONTENT_LABEL_TO_LEFT, height, maxWidth, 0) touchEnable:NO];
    height += view.frame.size.height;
    
    if ([message_contenttype_document isEqualToString:message.contentType] || [message_contenttype_file isEqualToString:message.contentType]) {
        height += 5;
        DAMessageFileView *fview = [[DAMessageFileView alloc] initWithMessage:message frame:CGRectMake(CONTENT_LABEL_TO_LEFT + 10, height, maxWidth - 20, 0) touchEnable:NO];
        height += fview.frame.size.height;
    }
    
    if ([message_contenttype_image isEqualToString:message.contentType]) {
        height += 5;
        if (message.thumb!=nil) {
            height +=160* [message.thumb.height floatValue]/500;
        }else{
            height += 120;
        }
        
    }
    
    // bottom
    height += BUTTON_AREA_HEIGHT;
    
    return height;
}

-(void) cellInitWithMessage:(DAMessage *)message
{
    
    DAUser *user = message.part.createby;
    
    self.imgPortrait.layer.masksToBounds = YES;
    self.imgPortrait.layer.cornerRadius = 5;
    if ([user isUserPhotoCatched] || [user getUserPhotoId] == nil) {
        
//    if ([user getUserPhotoId] == nil) {
        self.imgPortrait.image = [user getUserPhotoImage];
    } else {
        [[DAFileModule alloc] getPicture:[user getUserPhotoId] callback:^(NSError *err, NSString *pictureId){
            self.imgPortrait.image = [DACommon getCatchedImage:pictureId];
        }];
    }

    
    if(message.range != nil && [message getPublicRange] != nil){
        [self.groupView setHidden:NO];
        DAGroup *group = [message getPublicRange];
        self.lblRange.text = group.name.name_zh;
        
        if ([@"1" isEqualToString:group.type]) {
            if ([@"1" isEqualToString:group.secure]) {
                self.rangIcon.image = [UIImage imageNamed:@"group_security.png"];
            } else {
                self.rangIcon.image = [UIImage imageNamed:@"group.png"];
            }
        } else {
            self.rangIcon.image = [UIImage imageNamed:@"department.png"];
        }
    } else {
        [self.groupView setHidden:YES];
    }
    
    self.lblBy.text = [user getUserName];
    
    self.lblCreateAt.text = [DAHelper stringFromISODateString:message.createat ];
    
    if([[message getReplyCount] intValue ]>99)
        self.lblCommentCount.text = @"99+";
    else
        self.lblCommentCount.text = [NSString stringWithFormat:@"%@",[message getReplyCount]];
    
    if([[message getForwardCount] intValue]>99)
        self.lblForwardCount.text = @"99+";
    else
        self.lblForwardCount.text = [NSString stringWithFormat:@"%@",[message getForwardCount]];
    
    if (message.likers.count > 99) {
        self.lblLikeCount.text = @"99+";
    } else {
        self.lblLikeCount.text = [NSString stringWithFormat:@"%d", message.likers.count];
    }
   
    
    
    float maxWidth = 233.0f;
    float height = 0;
    
    
    // content
    height += CONTENT_LABEL_TO_TOP;
    UIFont *font = [UIFont systemFontOfSize:12];
    float lblMaxHeight = font.lineHeight * 5; // show 5 lines
    DAMessageLabel *label = [[DAMessageLabel alloc] initWithContent:message.content font:font breakMode:NSLineBreakByTruncatingTail maxFrame:CGRectMake(CONTENT_LABEL_TO_LEFT,height,maxWidth,lblMaxHeight)];
    [self.lblMessage removeFromSuperview];
    self.lblMessage = label;
    [self addSubview:self.lblMessage];
    height += label.frame.size.height;
    
    
    // at view
    DAMessageAtView *view = [[DAMessageAtView alloc] initWithMessage:message frame:CGRectMake(CONTENT_LABEL_TO_LEFT, height, maxWidth, 0) touchEnable:NO];
    [self.atArea removeFromSuperview];
    self.atArea = view;
    [self addSubview:view];
    height += view.frame.size.height;
    
    if ([message_contenttype_document isEqualToString:message.contentType] || [message_contenttype_file isEqualToString:message.contentType]) {
        height += 5;
        DAMessageFileView *fview = [[DAMessageFileView alloc] initWithMessage:message frame:CGRectMake(CONTENT_LABEL_TO_LEFT + 10, height, maxWidth - 20, 0) touchEnable:NO];
        [self.fileArea removeFromSuperview];
        self.fileArea = fview;
        [self addSubview:fview];
        height += fview.frame.size.height;
    }
    
//    UIGraphicsBeginImageContext(CGSizeMake(200, 400));
//    [img drawInRect:CGRectMake(0, 0, 200, 400)];
//    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return reSizeImage;
    if ([message_contenttype_image isEqualToString:message.contentType]) {
        if (message.attach.count > 0) {
            height += 5;
            MessageAttach *file = [message.attach objectAtIndex:0];
            float imgHeight;
            NSString *fileid = @"";
            if (message.thumb!=nil) {
                imgHeight= 160.0f * [message.thumb.height floatValue]/500.0f;
                fileid  = message.thumb.fileid;
            }else{
                fileid  = file.fileid;
                imgHeight = 120;
            }
            [self.imgAttach removeFromSuperview];
            UIImageView *newThumb = [[UIImageView alloc]initWithFrame:CGRectMake(CONTENT_LABEL_TO_LEFT, height, 100, imgHeight)];
            self.imgAttach = newThumb;
            
            if ([DACommon isImageCatched:fileid]) {
                    self.imgAttach.image = [DACommon getCatchedImage:fileid];
                CGSize size = [self setPicture:fileid];
                [newThumb setFrame:CGRectMake(CONTENT_LABEL_TO_LEFT, height, size.width, size.height)];
            } else {
                [[DAFileModule alloc] getPicture:fileid callback:^(NSError *err, NSString *pictureId){
                    
                    self.imgAttach.image = [DACommon getCatchedImage:pictureId];
                    CGSize size = [self setPicture:pictureId];
                    [newThumb setFrame:CGRectMake(CONTENT_LABEL_TO_LEFT, height, size.width, size.height)];
                }];
            }

            [self addSubview:newThumb];
        }
    } else {
        [self.imgAttach setHidden:YES];
    }
}


-(CGSize )setPicture:(NSString *)pictureId
{
    UIImage *img = [DACommon getCatchedImage:pictureId];
    CGSize size = [self sizeFixToImageSize:img.size];
    return size;
}
-(CGSize)sizeFixToImageSize:(CGSize)imgSize
{
    float maxWidth = self.frame.size.width;
    float maxHeight = 120 ;
    if (imgSize.width <= maxWidth && imgSize.height <= maxHeight) {
        return CGSizeMake(imgSize.width, imgSize.height);
    }
    if (imgSize.width > maxWidth){
        float ratio = imgSize.height / imgSize.width;
        float h = maxWidth * ratio;
        CGSize size = CGSizeMake(maxWidth, h);
        if (h > maxHeight) {
            return [self sizeFixToImageSize:size];
        }
        return size;
    }
    if (imgSize.height > maxHeight) {
        float ratio = imgSize.width / imgSize.height;
        float w = maxHeight *ratio;
        CGSize size = CGSizeMake(w, maxHeight);
        if (w > maxWidth) {
            return [self sizeFixToImageSize:size];
        }
        return size;
    }
    return CGSizeMake(maxWidth/2, maxHeight/2);
}

@end
