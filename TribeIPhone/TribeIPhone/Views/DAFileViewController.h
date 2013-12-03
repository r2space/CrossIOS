//
//  DAFileViewController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/24.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>
#import "DAFileDetailViewController.h"
#import "DABaseViewController.h"
#import "DAFileFilterViewController.h"

@interface DAFileViewController : DABaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)onCancelTouched:(id)sender;
- (IBAction)onAddTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barFilterIco;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barFilter;
- (IBAction)barFilterOnClick:(id)sender;
- (IBAction)barFilterIcoOnClick:(id)sender;


@end
