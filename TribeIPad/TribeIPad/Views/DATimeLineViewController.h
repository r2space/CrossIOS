//
//  DATimeLineViewController.h
//  tribe-ipad
//
//  Created by LI LIN on 2013/04/11.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>
#import "DATimeLineCell.h"
#import "DAMessageViewController.h"

@interface DATimeLineViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblMessageList;

@end
