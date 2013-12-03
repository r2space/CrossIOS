//
//  DASettingViewController.m
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/12.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DAMoreViewController.h"

@interface DAMoreViewController ()

@end

@implementation DAMoreViewController

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


- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"First view return action invoked.");
}

@end
