//
//  DAPictureViewController.h
//  TribeIPhone
//
//  Created by kita on 13-5-20.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/TribeSDKHeader.h>
#import "DAPictureScrollView.h"
//#import "UIScrollView+TouchEvent.h"

@interface DAPictureViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet DAPictureScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;
- (IBAction)onCloseClicked:(id)sender;
- (IBAction)onSaveImgClicked:(id)sender;
@property(retain,nonatomic) NSArray *PictureIds;
@property(nonatomic) int currIndex;
@end
