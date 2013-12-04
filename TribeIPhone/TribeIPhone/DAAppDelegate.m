//
//  DAAppDelegate.m
//  TribeIPhone
//
//  Created by kita on 13-4-15.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAAppDelegate.h"
#import "TribeSDKHeader.h"
#import "DAMainViewController.h"

#import "IIViewDeckController.h"
#import "DALeftSideViewController.h"

#define kInfoPlistKeyServerAddress  @"ServerAddress"
#define kInfoPlistKeyServerPort     @"ServerPort"

@implementation DAAppDelegate

// 起動プロセスがほとんど完了し、アプリの実行準備がほとんどできていることをデリゲートに通知します。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 设定缺省的服务器地址
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kServerAddress] == nil) {
        NSString *serverAddress = [[NSBundle mainBundle] objectForInfoDictionaryKey:kInfoPlistKeyServerAddress];
        NSNumber *serverPort = [[NSBundle mainBundle] objectForInfoDictionaryKey:kInfoPlistKeyServerPort];
        [[NSUserDefaults standardUserDefaults] setObject:serverAddress forKey:kServerAddress];
        [[NSUserDefaults standardUserDefaults] setInteger:serverPort.integerValue forKey:kServerPort];
    }
    
    // 初始化侧边栏（保留）
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    //DAMainViewController *mainController = (DAMainViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"DAMainViewController"];
    //DALeftSideViewController *leftController = [[DALeftSideViewController alloc] initWithNibName:@"DAMessageFilterViewController" bundle:nil];
    //IIViewDeckController *center = [[IIViewDeckController alloc] initWithCenterViewController:mainController leftViewController:leftController];
    //self.window.rootViewController = center;
    // 在viewcontroller里显示侧边栏的的例子
    //[(IIViewDeckController*)[UIApplication sharedApplication].keyWindow.rootViewController toggleLeftViewAnimated:YES];
    
    // 判断是否由远程消息通知触发应用程序启动
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {

        NSLog(@"0. Receive remote notification : %@", launchOptions);

        // 获取应用程序消息通知标记数（即小红圈中的数字）
        int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge > 0) {
            // 如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            
            badge = badge - 1;
            // 清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }
    
    // 消息推送注册
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];

    
    return YES;
}

// アプリケーションが非アクティブになることを、デリゲートに伝えます。
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// アプリケーションがバックグラウンドになっていることをデリゲートに伝えます。
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

// アプリケーションがフォアグラウンドに入ろうとしていることを、デリゲートに伝えます。
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSString *loginuid = [DALoginModule getLoginUserId];
    if (loginuid != nil) {

        // 从新打开设备时，获取当前登陆用户的最新信息，该信息保存在文件当中，当做全局变量使用
        // TODO:更新用户信息时，也需要更新该文件
        [[DAUserModule alloc] getUserById:loginuid callback:^(NSError *error, DAUser *user){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentDir = [paths objectAtIndex:0];
            
            NSData *userdata = [NSKeyedArchiver archivedDataWithRootObject:user];
            [userdata writeToFile:[NSString stringWithFormat:@"%@/%@", documentDir, user._id] atomically:YES];
            
            NSLog(@"save login user info ok!");
        }];
    }
}

// アプリケーションがアクティブになったことをデリゲートに伝えます。
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// アプリケーションが終了する時に、デリゲートに伝えます。
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"jp.co.dreamarts.smart.message.devicetoken"];
    NSLog(@"device token is:%@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

// 处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (UIApplicationStateInactive == application.applicationState) {

        // 由用户点击通知的消息，而启动时
        NSLog(@"2. Receive remote notification : %@", userInfo);
        return;
    }

    if (UIApplicationStateActive == application.applicationState) {
        
        // 应用程序正在运行时，接受消息
        NSLog(@"3. Receive remote notification : %@", userInfo);
        return;
    }
    
    NSLog(@"1. Receive remote notification : %@", userInfo);
}

// 支持从其他应用接受文件
- (BOOL)application:(UIApplication *)application openURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // TODO: 保存到本地，并可以发送消息
    NSLog(@"%@", url);
    return YES;
}

@end
