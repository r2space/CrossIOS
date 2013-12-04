//
//  DAMemberMoreContainerViewController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/21.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"

@interface DAMemberMoreContainerViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITableViewDelegate>

- (IBAction)onCancelTouched:(id)sender;
- (IBAction)onSaveTouched:(id)sender;

@property (retain, nonatomic) DAUser *user;
@property (retain, nonatomic) NSString *userid;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (retain ,nonatomic) NSString *status;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;

- (void) textFieldDidChange:(UITextField *) TextField;
@end
