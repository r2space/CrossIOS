//
//  DALoginProxy.h
//  TribeIPhone
//
//  Created by Antony on 13-12-11.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DALoginViewController.h"

@interface DALoginProxy : NSObject
{
    UIViewController *curViewController;
    
}

+ (DALoginProxy *) sharedInstance;
- (void) setCurVC:(UIViewController *)vc;
- (UIViewController *) getCurVC;
- (DALoginViewController *) getLoginVC;
- (void) activeProxy;
@end
