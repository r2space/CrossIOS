//
//  DAGroupController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/21.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>
#import "DABaseViewController.h"
#import "DAGroupCell.h"

@interface DAGroupController : DABaseViewController

@property (weak, nonatomic) NSString *uid;
- (IBAction)onCancelTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;

@end
