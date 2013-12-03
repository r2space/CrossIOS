//
//  DAShortmailViewController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/26.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>

#import "DABaseViewController.h"

@interface DAShortmailViewController : DABaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;

- (IBAction)onCancelTouched:(id)sender;
- (IBAction)onAddTouched:(id)sender;

@end
