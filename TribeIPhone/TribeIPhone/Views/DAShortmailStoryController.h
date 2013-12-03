//
//  DAShortmailStoryController.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/06/14.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"

@interface DAShortmailStoryController : JSMessagesViewController<JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSString *uid;

@end
