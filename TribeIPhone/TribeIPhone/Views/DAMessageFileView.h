//
//  DAMessageFileView.h
//  TribeIPhone
//
//  Created by kita on 13-4-23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"

typedef void (^FileDidTouched)(int type, NSString *fileId);

@interface DAMessageFileView : UIView
-(UIView *)initWithMessage:(DAMessage *)message frame:(CGRect)frame touchEnable:(BOOL)touchEnable;
@property (strong, nonatomic) FileDidTouched didTouchedBlocks;

@end
