//
//  DAPictureScrollView.m
//  TribeIPhone
//
//  Created by Antony on 13-6-19.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAPictureScrollView.h"
#import "DAMessageDetailCell.h"
#define prictureSpace 0


@implementation DAPictureScrollView
{
    NSArray *_pictureIds;
    NSTimeInterval _touchTimer;
    int _currIndex;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)renderWithPictureIds:(NSArray *)pictureIds
{
    self.pagingEnabled = YES;
//    self.showsHorizontalScrollIndicator = NO;
//    self.showsVerticalScrollIndicator = NO;
    _pictureIds = pictureIds;
    if (_pictureIds.count > 0) {
        CGSize contentSize = self.frame.size;
        contentSize.width = contentSize.width * _pictureIds.count + prictureSpace *(_pictureIds.count-1);
        self.contentSize = contentSize;
        for (int i = 0; i < _pictureIds.count; i++) {
            [self loadPicture:[_pictureIds objectAtIndex:i] index:i];
        }
    }
    _currIndex = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    self.delegate = self;
}
-(void)loadPicture:(NSString *)pictureId index:(int)idx
{
    if ([DACommon isImageCatched:pictureId]) {
        [self setPicture:pictureId index:idx];
    } else {
        [[DAFileModule alloc] getPicture:pictureId callback:^(NSError *error, NSString *pid) {
            [self setPicture:pictureId index:idx];
        }];
    }
}

-(void)setPicture:(NSString *)pictureId index:(int)idx
{
    UIImage *img = [DACommon getCatchedImage:pictureId];
    CGSize size = [self sizeFixToImageSize:img.size];
    float x = (self.frame.size.width + prictureSpace) *idx + (self.frame.size.width - size.width)/2;
    float y = (self.frame.size.height - size.height) / 2;
    CGRect viewFrame = CGRectMake(x, y, size.width, size.height);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:viewFrame];
    imgView.image = img;
    [self addSubview:imgView];
}
-(CGSize)sizeFixToImageSize:(CGSize)imgSize
{
    float maxWidth = self.frame.size.width;
    float maxHeight = self.frame.size.height;
    if (imgSize.width <= maxWidth && imgSize.height <= maxHeight) {
        return CGSizeMake(imgSize.width, imgSize.height);
    }
    if (imgSize.width > maxWidth){
        float ratio = imgSize.height / imgSize.width;
        float h = maxWidth * ratio;
        CGSize size = CGSizeMake(maxWidth, h);
        if (h > maxHeight) {
            return [self sizeFixToImageSize:size];
        }
        return size;
    }
    if (imgSize.height > maxHeight) {
        float ratio = imgSize.width / imgSize.height;
        float w = maxHeight *ratio;
        CGSize size = CGSizeMake(w, maxHeight);
        if (w > maxWidth) {
            return [self sizeFixToImageSize:size];
        }
        return size;
    }
    return CGSizeMake(maxWidth, maxHeight);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int idx = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (_currIndex!=idx) {
        _currIndex = idx;
        if (self.pageChangedBlocks != nil) {
            self.pageChangedBlocks(_currIndex);
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchTimer = [touch timestamp];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchTimer = [touch timestamp] - _touchTimer;
    
    NSUInteger tapCount = [touch tapCount];
    if (tapCount == 1 && _touchTimer <= 3){
        if (self.pictureTouchedBlocks ) {
            self.pictureTouchedBlocks(_currIndex);
        }
    }
    
}

-(void)scrollToIndex:(int)index
{
    [self setContentOffset:CGPointMake((self.frame.size.width + prictureSpace) *index, 0) animated:NO];
}

@end
