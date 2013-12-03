//
//  DAFileFilterViewController.h
//  TribeIPhone
//
//  Created by kita on 13-6-13.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FilterDidSelected)(NSString *);

@interface DAFileFilterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)FilterDidSelected selectedBlocks;
@end
