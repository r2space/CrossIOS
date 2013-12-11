//
//  DAViewController.m
//  TribeIPad
//
//  Created by LI LIN on 2013/04/15.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DAMainViewController.h"
#import "DALoginProxy.h"

@interface DAMainViewController ()
{
    DAMemberViewController *memberViewController;
    DATimeLineViewController *timeLineViewController;
    DAInBoxViewController *inBoxViewController;
}

- (void)hiddenViews;

@end

@implementation DAMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background1.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    
    [self onTimeLineTouched:nil];
    
    
    // 注册没有登陆是调用的函数
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(notificationCallbackShowLogin) name:@"NeedsLogin" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    // 如果没登陆，则显示登陆画面
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"jp.co.dreamarts.smart.message.userid"];
    if (userid == nil) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"NeedsLogin" object:nil]];
    }

    DALoginProxy *loginProxy = [DALoginProxy sharedInstance];
    [loginProxy setCurVC:self];
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"First view return action invoked.");
}

- (IBAction)onTimeLineTouched:(id)sender
{
    [self hiddenViews];
    if (timeLineViewController == nil) {
        timeLineViewController = [[DATimeLineViewController alloc]initWithNibName:@"DATimeLineViewController" bundle:nil];
        [self addChildViewController:timeLineViewController];
        
        [timeLineViewController.view setCenter:CGPointMake(330, 374)];
        [self.view addSubview:timeLineViewController.view];
    }
    
    timeLineViewController.view.hidden = false;
}

- (IBAction)onInBoxTouched:(id)sender
{    
    [self hiddenViews];
    if (inBoxViewController == nil) {
        inBoxViewController = [[DAInBoxViewController alloc]initWithNibName:@"DAInBoxViewController" bundle:nil];
        [self addChildViewController:inBoxViewController];
        
        [inBoxViewController.view setCenter:CGPointMake(330, 374)];
        [self.view addSubview:inBoxViewController.view];
    }
    
    inBoxViewController.view.hidden = false;
}

- (IBAction)onGroupTouched:(id)sender
{
    // 如果没登陆，则显示登陆画面
    DALoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DALoginViewController"];
    loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController: loginViewController animated: YES completion: nil];
    
}

- (IBAction)onMemberTouched:(id)sender
{
    [self hiddenViews];
    if (memberViewController == nil) {
        memberViewController = [[DAMemberViewController alloc]initWithNibName:@"DAMemberViewController" bundle:nil];
        [self addChildViewController:memberViewController];
        
        [memberViewController.view setCenter:CGPointMake(330, 374)];
        [self.view addSubview:memberViewController.view];
    }
    
    memberViewController.view.hidden = false;
}

- (void)hiddenViews {
    for (UIViewController *ctrl in [self childViewControllers]) {
        ctrl.view.hidden = true;
    }
}



- (IBAction)onSearchTouched:(id)sender {
}

// 接受通知
- (void)notificationCallbackShowLogin
{
    NSLog(@"lalalaa");
    DALoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DALoginViewController"];
    loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController: loginViewController animated: YES completion: nil];
}

@end
