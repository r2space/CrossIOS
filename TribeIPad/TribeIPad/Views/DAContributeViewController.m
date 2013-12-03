//
//  DAContributeViewController.m
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/14.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DAContributeViewController.h"

@interface DAContributeViewController ()

@end

@implementation DAContributeViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.superview.bounds = CGRectMake(0, 0, 540, 390);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
