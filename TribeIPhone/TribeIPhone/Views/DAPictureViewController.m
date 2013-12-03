//
//  DAPictureViewController.m
//  TribeIPhone
//
//  Created by kita on 13-5-20.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAPictureViewController.h"
#import "MBProgressHUD.h"
#import "DAHelper.h"

#define prictureSpace 0

@interface DAPictureViewController ()

@end

@implementation DAPictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.pageChangedBlocks = ^(int idx){
        _currIndex = idx;
        [self setTitle];
    };
    self.scrollView.pictureTouchedBlocks = ^(int idx){
        [self setBarHidden:!_toolBar.hidden];
    };
    [self setBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.scrollView renderWithPictureIds:self.PictureIds];
    [self.scrollView scrollToIndex:_currIndex];
    [self setTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitle
{
    _barTitle.title = [NSString stringWithFormat:@"%d / %d", _currIndex + 1, _PictureIds.count];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setBarHidden:YES];
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int idx = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (_currIndex!=idx) {
        _currIndex = idx;
        [self setTitle];
    }

}

-(void)setBarHidden:(BOOL)hidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
    _toolBar.hidden = hidden;
}


- (IBAction)onCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSaveImgClicked:(id)sender {
    NSString *pid = [_PictureIds objectAtIndex:_currIndex];
    if ([DACommon isImageCatched:pid]) {
        UIImageWriteToSavedPhotosAlbum([DACommon getCatchedImage:pid], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }

}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progress.mode = MBProgressHUDModeText;
        progress.dimBackground = YES;
        progress.labelText = @"";
        progress.detailsLabelText = [DAHelper localizedStringWithKey:@"msg.saveSuccess" comment:@"已保存"];
        progress.margin = 10.f;
        progress.yOffset = 50.f;
        progress.removeFromSuperViewOnHide = YES;
        [progress hide:YES afterDelay:2];
}
@end
