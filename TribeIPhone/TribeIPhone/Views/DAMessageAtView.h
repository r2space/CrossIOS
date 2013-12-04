//
//  DAMessageAtView.h
//  TribeIPhone
//
//  Created by kita on 13-4-21.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"

typedef void (^AtDidTouched)(int type, NSString *objectId);

//@protocol DAMessageAtViewDelegate
//-(void)atUserClicked:(DAUser *)user;
//-(void)atGroupClicked:(DAGroup *)group;
//@end

@interface DAMessageAtView : UIView
{
//    NSMutableArray *touchLocations;
//    NSMutableArray *touchContents;
}
//@property (nonatomic, strong) id<DAMessageAtViewDelegate> delegate;
@property (strong, nonatomic) AtDidTouched didTouchedBlocks;
-(UIView *)initWithMessage:(DAMessage *)message frame:(CGRect)frame touchEnable:(BOOL)touchEnable;
@end
