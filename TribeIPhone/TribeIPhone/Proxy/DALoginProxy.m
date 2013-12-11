//
//  DALoginProxy.m
//  TribeIPhone
//
//  Created by Antony on 13-12-11.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DALoginProxy.h"
#import "DAHelper.h"

static DALoginProxy *sharedObj = nil; //第一步：静态实例，并初始化。
static DALoginViewController *loginViewController = nil;
@implementation DALoginProxy

+ (DALoginProxy*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {

            sharedObj = [[self alloc]init];
            loginViewController = [[DALoginViewController alloc ]initWithNibName:@"DALoginViewController" bundle:nil];
        }
    }
    return sharedObj;
}

- (void) setCurVC:(UIViewController *)vc
{
    curViewController = vc;
}

- (UIViewController *) getCurVC
{
    return curViewController;
}

- (DALoginViewController *) getLoginVC
{
    return loginViewController;
}

- (void) activeProxy
{
    [DAHelper hidePopup];
    double lastExitTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"jp.co.dreamarts.smart.message.lastaccess"] doubleValue];
    double now = [[NSDate date] timeIntervalSince1970];
    
    
    if (now - lastExitTime < 3600) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"jp.co.dreamarts.smart.message.userid"];
        NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"jp.co.dreamarts.smart.message.password"];
        if (userId != nil && passWord != nil) {
            loginViewController.txtUserId.text = userId;
            loginViewController.txtPassword.text = passWord;
        }
        
    } else {
        loginViewController.txtUserId.text = @"";
        loginViewController.txtPassword.text = @"";
    }
    
}
@end
