//
//  DAFileViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/24.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAFileViewController.h"
#import "DAFileViewCell.h"
#import "DAHelper.h"
#import "DAFileDetailViewController.h"
#import "DAFileWebViewController.h"

#import "WTStatusBar.h"

@interface DAFileViewController ()
{
    MBProgressHUD *_hud;
    NSString *_type;
    NSDictionary *_typeValues;
}

@end

@implementation DAFileViewController

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
    _type = @"all";
    _typeValues = @{@"all":[DAHelper localizedStringWithKey:@"file.type.all" comment:@"全部"],@"image":[DAHelper localizedStringWithKey:@"file.type.image" comment:@"图片"],@"video":[DAHelper localizedStringWithKey:@"file.type.video" comment:@"视频"],@"audio":[DAHelper localizedStringWithKey:@"file.type.audio" comment:@"音频"],@"application":[DAHelper localizedStringWithKey:@"file.type.application" comment:@"其它"]};
    
    [self fetch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetch
{
    if ([self preFetch]) {
        return;
    }
    
    [[DAFileModule alloc] getFileList:start count:count type:_type callback:^(NSError *error, DAFileList *files){
        [self finishFetch:files.items error:error];
        [self displayFilter];
    }];
}

-(void)displayFilter
{
    if ([_type isEqualToString:@"all"]) {
//        [self.barFilterIco setImage:[UIImage imageNamed:@"gateway_binoculars.png"]];
    } else {
//        [self.barFilterIco setImage:[UIImage imageNamed:@"gateway_cross.png"]];
    }
    [self.barFilter setTitle:[_typeValues objectForKey:_type]];
}

- (IBAction)onCancelTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddTouched:(id)sender
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = NO;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *fromCamera = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *fileName = @"FromIPhoneCamera.jpg";
    NSString *mimeType = @"image/jpeg";
    NSData *uploadFile = UIImageJPEGRepresentation(fromCamera, 1);
    
    // 在状态栏显示进度
    [WTStatusBar setProgressBarColor:DAColor];
    [WTStatusBar setStatusText:@"uploading..." animated:YES];
    
    // HUD
    [_hud show:YES];

    [[DAFileModule alloc] uploadFile:uploadFile fileName:fileName mimeType:mimeType callback:^(NSError *error, DAFile *file){
        [WTStatusBar setStatusText:@"done!" timeout:0.5 animated:YES];
        [_hud hide:YES];
    } progress:^(CGFloat percent){
        [WTStatusBar setProgress:percent animated:YES];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DAFile *file = [list objectAtIndex:indexPath.row];
	DAFileViewCell *cell = [DAFileViewCell initWithMessage:file tableView:tableView];
    
    cell.lblFileName.text = file.filename;
    cell.lblAt.text = [DAHelper stringFromISODateString: file.uploadDate];
    cell.imgFileType.image = [UIImage imageNamed:[DAHelper fileanExtension:file.contentType]];
    if (([file.length intValue]/1024)> 1024) {
        cell.lblFileSize.text = [NSString stringWithFormat:@"%dMB",[file.length intValue]/1024/1024];
    }else{
        cell.lblFileSize.text = [NSString stringWithFormat:@"%dKB",[file.length intValue]/1024];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"FileDetailViewController");
//    DAFileDetailViewController *detailViewController = [[DAFileDetailViewController alloc] initWithNibName:@"DAFileDetailViewController" bundle:nil];
//    detailViewController.getfile = [list objectAtIndex:indexPath.row];
//    detailViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    NSLog(@"FileDetailViewController");
//    DAFileWebViewController *detailView = [[DAFileWebViewController alloc] initWithNibName:@"DAFileWebViewController" bundle:nil];
//    DAFile *file = [list objectAtIndex:indexPath.row];
//    //kRemote  是接口的网址
//    detailView.fileUrl = [NSString stringWithFormat:@"%@file/download.json?_id=%@", kRemote,file.downloadId];
//    
//    detailView.fileName = file.filename;
//    detailView.downloadId = file.downloadId;
//    detailView.fileExt = file.extension;
//    detailView.fileDb = file;
    DAFileWebViewController *detailView = [[DAFileWebViewController alloc] initWithNibName:@"DAFileWebViewController" bundle:nil];
    DAFile *file = [list objectAtIndex:indexPath.row];
    detailView.fileDb = file;
    detailView.downloadId = file.downloadId;
    detailView.fileExt = file.extension;
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
    
}
- (IBAction)barFilterOnClick:(id)sender {
    DAFileFilterViewController *filterCtrl = [[DAFileFilterViewController alloc] initWithNibName:@"DAFileFilterViewController" bundle:nil];
    filterCtrl.selectedBlocks = ^(NSString *filter){
        _type = filter;
        [self refresh];
        [DAHelper hidePopup];
    };
    [DAHelper showPopup:filterCtrl];
}

- (IBAction)barFilterIcoOnClick:(id)sender {
    if ([_type isEqualToString:@"all"]) {
        [self barFilterOnClick:nil];
    } else {
        _type = @"all";
        [self refresh];
    }
}
@end
