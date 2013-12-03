//
//  DASettingContainerViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DASettingContainerViewController.h"
#import "DASettingViewController.h"
#import "DAHelper.h"

@interface DASettingContainerViewController ()
{
    DASettingViewController *settingViewController;
}

@end

@implementation DASettingContainerViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.barTitle.title = [DAHelper localizedStringWithKey:@"setting.title" comment:@"设定"];

    UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"DASettingViewController" bundle:nil];
    settingViewController = [stryBoard instantiateInitialViewController];
    
    settingViewController.view.frame = CGRectMake(0, 44, 320, 548);
    [self addChildViewController:settingViewController];
    [self.view addSubview:settingViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancelTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
