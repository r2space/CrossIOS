//
//  DAGroupMoreViewController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>

@interface DAGroupMoreViewController : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) DAGroup *group;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSecurity;
@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UISwitch *safeSwitch;

- (IBAction)didEndOnExit:(id)sender;
- (IBAction)didSwitchON:(id)sender;

@end
