//
//  DAPictureScrollView.h
//  TribeIPhone
//
//  Created by Antony on 13-6-19.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeSDKHeader.h"

typedef void (^PageDidChanged)(int idx);
typedef void (^PictureDidTouched)(int idx);

@interface DAPictureScrollView : UIScrollView <UIScrollViewDelegate>
@property(strong, nonatomic) PageDidChanged pageChangedBlocks;
@property(strong, nonatomic) PictureDidTouched pictureTouchedBlocks;
-(void)renderWithPictureIds:(NSArray *)pictureIds;
-(void)scrollToIndex:(int)index;
@end
