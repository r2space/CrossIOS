//
//  DAViewController.h
//  TribeIPad
//
//  Created by LI LIN on 2013/04/15.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DATimeLineViewController.h"
#import "DAMemberViewController.h"
#import "DAInBoxViewController.h"
#import "DALoginViewController.h"

@interface DAMainViewController : UIViewController
- (IBAction)onTimeLineTouched:(id)sender;
- (IBAction)onInBoxTouched:(id)sender;
- (IBAction)onGroupTouched:(id)sender;
- (IBAction)onMemberTouched:(id)sender;
- (IBAction)onSearchTouched:(id)sender;
@end
