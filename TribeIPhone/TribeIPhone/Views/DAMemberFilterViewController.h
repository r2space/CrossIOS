//
//  DAMemberFilterViewController.h
//  TribeIPhone
//
//  Created by Antony on 13-6-14.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"
#import "DABaseViewController.h"
typedef void (^FilterDidSelected)(NSString *,NSString *,NSString *);


@interface DAMemberFilterViewController : DABaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)FilterDidSelected selectedBlocks;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segType;


-(IBAction)setSegment:(id)sender;
@end
