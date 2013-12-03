//
//  DALoginViewController.m
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/12.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DALoginViewController.h"

@interface DALoginViewController ()

@end

@implementation DALoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFinishLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:self.txtUserID.text forKey:@"jp.co.dreamarts.smart.message.userid"];
    [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"jp.co.dreamarts.smart.message.password"];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) didFailLogin
{
    
}

- (IBAction)onLoginTouched:(id)sender {
//    [[DALoginModule alloc] login:self name:@"l_li@dreamarts.co.jp" password:@"l_li"];
}

- (IBAction)onLogoutTouched:(id)sender {
}

@end
