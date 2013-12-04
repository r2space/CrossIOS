//
//  DAFriendViewController.h
//  tribe
//
//  Created by 李 林 on 2012/11/27.
//  Copyright (c) 2012年 dac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"
#import "DABaseViewController.h"

@interface DAMemberViewController : DABaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
 
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barFilterIco;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barFilter;

- (IBAction)barFilterOnClick:(id)sender;
- (IBAction)barFilterIcoOnClick:(id)sender;
- (IBAction)onCancelTouched:(id)sender;


@end
