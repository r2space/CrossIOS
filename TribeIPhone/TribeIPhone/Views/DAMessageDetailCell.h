//
//  DAMessageDetailCell.h
//  TribeIPhone
//
//  Created by kita on 13-4-16.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"
#import "DAMessageLabel.h"
#import "DAMessageAtView.h"
#import "DAMessageFileView.h"
#import "DAPictureScrollView.h"

typedef void (^RangeDidTouched)(NSString *groupId);

@interface DAMessageDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCreateAt;
@property (retain, nonatomic) DAMessage *message;
@property (weak, nonatomic) DAMessageLabel *lblMessage;
@property (weak, nonatomic) DAMessageAtView *atArea;
@property (weak, nonatomic) DAMessageFileView *fileArea;
//@property (weak, nonatomic) IBOutlet UIImageView *imgAttach;
@property (weak, nonatomic) IBOutlet UILabel *lblRange;
@property (weak, nonatomic) IBOutlet UIImageView *rangIcon;
@property (weak, nonatomic) IBOutlet DAPictureScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *rangeArea;
@property (strong, nonatomic) RangeDidTouched rangeTouchedBlocked;
@property (strong, nonatomic) AtDidTouched atTouchedBlocks;
@property (strong, nonatomic) FileDidTouched fileTouchedBlocks;

- (IBAction)onRangeClicked:(id)sender;
+(DAMessageDetailCell *) initWithMessage:(DAMessage *)message tableView:(UITableView *)tableView;
+(float)cellHeightWithMessage:(DAMessage *)message;
-(float)cellHeight;
-(void)setAtTouchedBlocks:(AtDidTouched)atTouchedBlocks;
-(void)setFileTouchedBlocks:(FileDidTouched)fileTouchedBlocks;
@end
