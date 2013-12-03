//
//  DAGroupMoreViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAGroupMoreViewController.h"
#import "DAHelper.h"

@interface DAGroupMoreViewController ()

@end

@implementation DAGroupMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.group != nil) {
        self.imgPortrait.image = [DACommon getCatchedImage: self.group.photo.small defaultImage:[UIImage imageNamed:@"people-group.png"]];
                                  
        self.txtName.text = self.group.name.name_zh;
        self.segSecurity.selectedSegmentIndex = [self.group.secure isEqualToString:GroupSecureTypePublic] ? 0 : 1;
        self.txtCategory.text = self.group.category;
        self.txtDescription.text = self.group.description;

        // 类型为组织时，名称不可变
        if ([self.group.type isEqualToString:GroupTypeOrganization]) {
            self.txtName.enabled = NO;
            self.segSecurity.enabled = NO;
        }
    }
}
- (IBAction)didSwitchON:(id)sender
{
//        UISwitch *safe = [(UISwitc
}
- (IBAction)didEndOnExit:(id)sender
{
    [((UITextField *)sender) resignFirstResponder];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 修改头像
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        // カメラが使用可能かどうか判定する
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
    
    self.imgPortrait.image = image;
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[DAHelper documentPath:@"upload.jpg"] atomically:YES];

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
