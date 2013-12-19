//
//  DAMessageFilterViewController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/06/07.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"
#import "DABaseViewController.h"


@interface DALeftSideViewController : DABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) UIViewController *contentController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)setSegment:(id)sender;

@end
