//
//  DAMemberPasswordViewController.h
//  TribeIPhone
//
//  Created by 罗浩 on 13-12-24.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"
@interface DAMemberPasswordViewController : UIViewController<UITableViewDelegate,UITextFieldDelegate>
@property (retain, nonatomic) DAUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)OnCancelTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;
- (IBAction)OnSaveTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;

@end
