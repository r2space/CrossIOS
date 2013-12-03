//
//  DAMessageViewController.h
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/11.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAMessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UILabel *lblBy;

@end
