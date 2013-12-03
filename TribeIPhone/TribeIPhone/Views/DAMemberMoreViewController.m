//
//  DAMemberMoreViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/21.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMemberMoreViewController.h"
#import "DAGroupController.h"
#import "DAHelper.h"

@interface DAMemberMoreViewController ()

@end

@implementation DAMemberMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 显示用户基本信息
    [self setDetailInfo];
    
    // 非本人，禁止更新
    if (![self.user._id isEqualToString:[DALoginModule getLoginUserId]]) {
        self.tvcPhoto.accessoryType = UITableViewCellAccessoryNone;
        self.lblPhoto.text = [DAHelper localizedStringWithKey:@"group.photo" comment:@"头像"];
    }
}

- (void)setDetailInfo
{
    // 名称
    self.txtName.text = self.user.name.name_zh;
    
    // 手机
    if (self.user.tel != nil) {
        self.txtMobile.text = self.user.tel.mobile;
    }
    
    // 邮件
    self.txtEmail.text = self.user.uid;
    
    // 简介
    if (self.user.custom != nil) {
        self.txtDescription.text = self.user.custom.memo;
    }

    // 语言
    if ([self.user.lang isEqualToString:UserLanguageZH]) {
        self.segLang.selectedSegmentIndex = 0;
    }
    if ([self.user.lang isEqualToString:UserLanguageJP]) {
        self.segLang.selectedSegmentIndex = 1;
    }
    if ([self.user.lang isEqualToString:UserLanguageEN]) {
        self.segLang.selectedSegmentIndex = 2;
    }
    
    // 地址
    if (self.user.address != nil) {
        self.txtAddress.text = self.user.address.city;
    }
}

- (IBAction)didEndOnExit:(id)sender
{
    [((UITextField *)sender) resignFirstResponder];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 参加的组一览
    if (indexPath.section == 0 && indexPath.row == 0) {
        DAGroupController *groupController = [[DAGroupController alloc] initWithNibName:@"DAGroupController" bundle:nil];
        
        groupController.uid = self.user._id;
        [self.navigationController pushViewController:groupController animated:YES];
    }
    // 关注的人一览
    if (indexPath.section == 0 && indexPath.row == 1) {
        // 关注的人
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.uid = self.user._id;
        members.kind = DAMemberListFollower;
        
        members.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:members animated:YES];
//        [self presentViewController:members animated:YES completion:nil];
    }
    // 粉丝一览
    if (indexPath.section == 0 && indexPath.row == 2) {
        // 粉丝
        DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
        members.uid = self.user._id;
        members.kind = DAMemberListFollowing;
        
        members.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:members animated:YES];
//        [self presentViewController:members animated:YES completion:nil];
    }

    // 修改头像
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        // 判断相机是否可用（模拟器）
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        
        // UIImagePickerControllerのインスタンスを生成
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        // デリゲートを設定
        imagePickerController.delegate = self;
        
        // 画像の取得先をカメラに設定
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 画像取得後に編集するかどうか（デフォルトはNO）
        imagePickerController.allowsEditing = YES;
        
        // 撮影画面をモーダルビューとして表示する
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }

}

// 画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[DAHelper documentPath:@"upload.jpg"] atomically:YES];

    
    // 渡されてきた画像をフォトアルバムに保存
    // UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:), NULL);
}

// 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // キャンセルされたときの処理を記述・・・
}

// 画像の保存完了時に呼ばれるメソッド
- (void)targetImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)context
{
    if (error) {
        // 保存失敗時の処理
    } else {
        // 保存成功時の処理
    }
}

@end
