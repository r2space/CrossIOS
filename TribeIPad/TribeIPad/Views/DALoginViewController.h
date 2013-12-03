//
//  DALoginViewController.h
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/12.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>

@interface DALoginViewController : UIViewController
- (IBAction)onLoginTouched:(id)sender;
- (IBAction)onLogoutTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
