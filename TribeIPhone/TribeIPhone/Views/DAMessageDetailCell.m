//
//  DAMessageDetailCell.m
//  TribeIPhone
//
//  Created by kita on 13-4-16.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMessageDetailCell.h"
#import "DAPictureViewController.h"
#import "DAHelper.h"

@implementation DAMessageDetailCell

- (IBAction)onRangeClicked:(id)sender {
    if (self.rangeTouchedBlocked != nil) {
        self.rangeTouchedBlocked(self.message.range);
    }
}

+(DAMessageDetailCell *) initWithMessage:(DAMessage *)message tableView:(UITableView *)tableView
{
    NSString *identifier = @"DAMessageDetailCell";
    DAMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setMessage:message];
    float height = 5;
    float offset = 15;
    float maxWidth = 320 - offset*2;
    // content
    DAMessageLabel *label = [[DAMessageLabel alloc] initWithContent:message.content font:[UIFont systemFontOfSize:14] breakMode:NSLineBreakByCharWrapping maxFrame:CGRectMake(offset, height, maxWidth, 5000.0f)];
    [cell.lblMessage removeFromSuperview];
    cell.lblMessage = label;
    [cell addSubview:cell.lblMessage];
    height += label.frame.size.height;
    
    // at view
    DAMessageAtView *view = [[DAMessageAtView alloc] initWithMessage:message frame:CGRectMake(offset, height, maxWidth, 5000) touchEnable:YES];
    [cell.atArea removeFromSuperview];
    cell.atArea = view;
    [cell addSubview:view];
    height += view.frame.size.height;
    
    if ([message_contenttype_document isEqualToString:message.contentType] || [message_contenttype_file isEqualToString:message.contentType]) {
        BOOL touchEnable = [message_contenttype_document isEqualToString:message.contentType] ? YES : NO;
        DAMessageFileView *fview = [[DAMessageFileView alloc] initWithMessage:message frame:CGRectMake(20, height, maxWidth - 40, 0) touchEnable:touchEnable];
        [cell.fileArea removeFromSuperview];
        cell.fileArea = fview;
        [cell addSubview:fview];
        height += fview.frame.size.height;
    }
    if ([message_contenttype_image isEqualToString:message.contentType]) {
        if (message.attach.count > 0) {
            
            NSMutableArray *ids = [[NSMutableArray alloc] init];
            for (MessageAttach *file in message.attach) {
                [ids addObject:file.fileid];
            }
            [cell.scrollView renderWithPictureIds:ids];
            
            [cell.scrollView setHidden:NO];
        }
    } else {
        [cell.scrollView setHidden:YES];
    }
    
    cell.lblCreateAt.text = [DAHelper stringFromISODateString:message.createat];
    if(message.range != nil && [message getPublicRange] != nil){
        cell.rangeArea.hidden = NO;
        DAGroup *group = message.part.range;
        cell.lblRange.text = group.name.name_zh;
        if ([@"1" isEqualToString:group.type]) {
            if ([@"1" isEqualToString:group.secure]) {
                cell.rangIcon.image = [UIImage imageNamed:@"group_security.png"];
            } else {
                cell.rangIcon.image = [UIImage imageNamed:@"group.png"];
            }
        } else {
            cell.rangIcon.image = [UIImage imageNamed:@"department.png"];
        }
    } else {
        cell.rangeArea.hidden = YES;
    }
    return cell;
}

-(float)cellHeight
{
    return self.lblMessage.frame.size.height + self.atArea.frame.size.height + self.scrollView.frame.size.height + 40;
}

+(float)cellHeightWithMessage:(DAMessage *)message
{
    float height = 5;
    float offset = 15;
    float maxWidth = 320 - offset*2;
    
    DAMessageLabel *label = [[DAMessageLabel alloc] initWithContent:message.content font:[UIFont systemFontOfSize:14] breakMode:NSLineBreakByCharWrapping maxFrame:CGRectMake(offset, height, maxWidth, 5000.0f)];
    height += label.frame.size.height;
    
    DAMessageAtView *view = [[DAMessageAtView alloc] initWithMessage:message frame:CGRectMake(offset, height, maxWidth, 5000) touchEnable:NO];
    height += view.frame.size.height;
    
    if ([message_contenttype_document isEqualToString:message.contentType] || [message_contenttype_file isEqualToString:message.contentType]) {
        DAMessageFileView *fview = [[DAMessageFileView alloc] initWithMessage:message frame:CGRectMake(20, height, maxWidth - 40, 0) touchEnable:NO];
        height += fview.frame.size.height;
    }
    
    if ([message_contenttype_image isEqualToString:message.contentType]) {
        height += 158;
    }
    
    // bottom
    height += 30;
    
    return height;
}

-(void)setAtTouchedBlocks:(AtDidTouched)atTouchedBlocks
{
    self.atArea.didTouchedBlocks = atTouchedBlocks;
}

-(void)setFileTouchedBlocks:(FileDidTouched)fileTouchedBlocks
{
    self.fileArea.didTouchedBlocks = fileTouchedBlocks;
}
@end
