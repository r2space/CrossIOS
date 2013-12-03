//
//  DALoginViewController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/16.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>

@interface DALoginViewController : UIViewController<UITextFieldDelegate>

- (IBAction)onLoginTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
