//
//  DAGroupMoreContainerViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/23.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAGroupMoreContainerViewController.h"
#import "DAGroupMoreViewController.h"
#import "DAHelper.h"
#import "DAGroupMoreDetailCell.h"
#import "DAMemberController.h"

@interface DAGroupMoreContainerViewController ()
{
    
    BOOL ISNEW;
    BOOL isPhotoChanged;
    BOOL editEnable;
    BOOL isDepartment;
    UISwitch *switchView;
    UIImageView *photoView;
    float viewHeight;
}

@end

@implementation DAGroupMoreContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    photoView = [[UIImageView alloc] initWithFrame:CGRectMake(128.0f, 10.0f, 30.0f, 30.0f)];
    ISNEW = YES;
    editEnable = [self.group.member containsObject:[DALoginModule getLoginUserId]];
    
    if (self.group !=nil) {
        isDepartment = [@"2" isEqualToString:self.group.type];
        ISNEW = NO;
        self.saveBtn.enabled = NO;
        [self.saveBtn setImage:nil];
    }
    if (editEnable&&self.group.name.name_zh.length > 0) {
        self.saveBtn.enabled = YES;
        [self.saveBtn setImage:[UIImage imageNamed:@"tool_save-fix.png"]];
    }
    if (ISNEW) {
        self.saveBtn.enabled = NO;
        self.titleBtn.title = [DAHelper localizedStringWithKey:@"group.create" comment:@"新建组"];
    } else {
        self.titleBtn.title = [DAHelper localizedStringWithKey:@"group.detail.title" comment:@"组/部门详细"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    viewHeight = self.view.frame.size.height;
    isPhotoChanged = NO;
}

// 返回
- (IBAction)onCancelTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存
- (IBAction)onSaveTouched:(id)sender
{
    NSString *file = [DAHelper documentPath:@"upload.jpg"];
    
    // 更新
    if (!isPhotoChanged) {
        [self updateGroup: nil imageWidth:0];
    }else{
        if ([DAHelper isFileExist:file]) {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:file];
            [[DAUserModule alloc] uploadUserPhoto:UIImageJPEGRepresentation(image, 1.0) fileName:file width:image.size.width callback:^(NSError *error, NSDictionary *photos){
                if (error != nil) {
                    [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"error.updateError" comment:@"更新失败"] detail:[NSString stringWithFormat:@"error : %d", [error code]] delay:0.6 yOffset:0];
                    return ;
                }
                [self updateGroup: photos imageWidth:image.size.width];
                
            }];
            isPhotoChanged = NO;
        }
    }
}

- (void)updateGroup:(NSDictionary *)photos imageWidth:(float)imageWidth
{
    // 没有，则创建组
    //    self.group.secure = GroupSecureTypePublic;
    
    // 如果头像存在，指定新照片的切割范围
    if (photos) {
        GroupPhoto * photo = [[GroupPhoto alloc] init];
//        photo.fid = fileId;
//        photo.x = @"0";
//        photo.y = @"0";
//        photo.width = [NSString stringWithFormat:@"%d",(int)imageWidth];
        photo.big =[photos objectForKey:@"big"];
        photo.middle =[photos objectForKey:@"middle"];
        photo.small =[photos objectForKey:@"small"];
        
        self.group.photo = photo;
    }
    // 更新或新规
    
    if (self.group._id == nil) {
        [[DAGroupModule alloc] create:self.group callback:^(NSError *error, DAGroup *group){
            
            if (error != nil) {
                [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"error.updateError" comment:@"更新失败"] detail:[NSString stringWithFormat:@"error : %d", [error code]] delay:0.6 yOffset:0];
                return ;
            }
            [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"msg.updateSuccess" comment:@"更新成功"] detail:nil delay:0.6 yOffset:0];
             [self performSelector:@selector(back) withObject:self afterDelay:0.6];
            
        }];
    } else {
        [[DAGroupModule alloc] update:self.group callback:^(NSError *error, DAGroup *group){
            
            if (error != nil) {
                [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"error.updateError" comment:@"更新失败"] detail:[NSString stringWithFormat:@"error : %d", [error code]] delay:0.6 yOffset:0];
                return ;
            }
            [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"msg.updateSuccess" comment:@"更新成功"] detail:nil delay:0.6 yOffset:0];
            [self performSelector:@selector(back) withObject:self afterDelay:0.6];
            
            
        }];
    }
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (editEnable) {
        if (0==section) {
            return 1;
        }else{
            return 5;
        }
    }
    if (ISNEW) {
        if (0==section) {
            return 0;
        }else{
            return 5;
        }
    }else{
        if (0==section) {
            return 1;
        }else{
            return 4;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"DAGroupMoreDetailCell";
    
    DAGroupMoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    if (editEnable) {
        if (indexPath.section ==0 ) {
            if (!ISNEW) {
                switch (indexPath.row) {
                        
                    case 0:
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.members" comment:@"成员一览"] icon: @"table_business-team.png" value:@"0" tag:10 hasDetail:YES];
                        
                        break;
                    default:
                        break;
                }
            }
        }else{
            switch (indexPath.row) {
                case 0:
                    [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.name" comment:@"名称"] icon: @"price-tag.png" value:self.group.name.name_zh tag:1 hasDetail:NO];
                    break;
                case 1:
                    
                    [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.photo" comment:@"头像"] icon: @"table_photo.png" value:@"" tag:9 hasDetail:YES];
                    break;
                case 2:
                    
                    [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.secure" comment:@"公开"] icon: @"lock-open.png" value:self.group.secure tag:2 hasDetail:NO];
                    break;
                case 3:
                    
                    [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.tag" comment:@"标签"] icon: @"tab_email.png" value:self.group.category tag:3 hasDetail:NO];
                    
                    break;
                case 4:
                    
                    [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.description" comment:@"简介"] icon: @"table_rural-house.png" value:self.group.description!=nil?self.group.description:@"" tag:4 hasDetail:NO];
                    
                    
                    break;
                default:
                    break;
            }
            
        }
    }else{
        
        
        if (indexPath.section ==0 ) {
            if (!ISNEW) {
                switch (indexPath.row) {
                        
                    case 0:
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.members" comment:@"成员一览"] icon: @"table_business-team.png" value:@"0" tag:10 hasDetail:YES];
                        
                        break;
                    default:
                        break;
                }
            }
        }else{
            if (ISNEW) {
                switch (indexPath.row) {
                    case 0:
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.name" comment:@"名称"] icon: @"price-tag.png" value:self.group.name.name_zh tag:1 hasDetail:NO];
                        break;
                    case 1:
                        
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.photo" comment:@"头像"] icon: @"table_photo.png" value:@"" tag:9 hasDetail:YES];
                        break;
                    case 2:
                        
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.secure" comment:@"公开"] icon: @"lock-open.png" value:self.group.secure tag:2 hasDetail:NO];
                        break;
                    case 3:
                        
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.tag" comment:@"标签"] icon: @"tab_email.png" value:self.group.category tag:3 hasDetail:NO];
                        
                        break;
                    case 4:
                        
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.description" comment:@"简介"] icon: @"table_rural-house.png" value:self.group.description!=nil?self.group.description:@"" tag:4 hasDetail:NO];
                        
                        
                        break;
                    default:
                        break;
                }
            }else{
                switch (indexPath.row) {
                    case 0:
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.name" comment:@"名称"] icon: @"price-tag.png" value:self.group.name.name_zh tag:1 hasDetail:NO];
                        break;
                    case 1:
                        
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.secure" comment:@"公开"] icon: @"lock-open.png" value:self.group.secure tag:2 hasDetail:NO];
                        break;
                    case 2:
                        
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.tag" comment:@"标签"] icon: @"tab_email.png" value:self.group.category tag:3 hasDetail:NO];
                        
                        break;
                    case 3:
                        
                        [self rendCell:cell title:[DAHelper localizedStringWithKey:@"group.description" comment:@"简介"] icon: @"table_rural-house.png" value:self.group.description!=nil?self.group.description:@""  tag:4 hasDetail:NO];
                        
                        
                        break;
                    default:
                        break;
                }
            }
            
        }
    }
    return cell;
    
}
- (IBAction)didEndOnExit:(id)sender
{
    [((UITextField *)sender) resignFirstResponder];
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 44;
    }
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        if (indexPath.row == 0 ) {
            //组成员一览
            DAMemberController *members = [[DAMemberController alloc] initWithNibName:@"DAMemberController" bundle:nil];
            members.gid = self.group._id;
            members.kind = DAMemberListGroupMember;
            
            members.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:members animated:YES];
        }
    }else{
        if (indexPath.row == 0 ) {
            
        }else if((indexPath.row == 1&&ISNEW)||editEnable){
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
        }else if(indexPath.row == 2){
            
        }else if(indexPath.row == 3){
            
        }else if(indexPath.row == 4){
            
        }
    }
}
// 1:私密，2:公开
- (void) switchAction:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    if(control == switchView){
        BOOL on = control.on;
        if (on) {
            self.group.secure = GroupSecureTypePublic;
        }else{
            self.group.secure = GroupSecureTypePrivate;
        }
        
    }
}
-(DAGroupMoreDetailCell *)rendCell:(DAGroupMoreDetailCell *)cell title:(NSString *)title icon:(NSString *)icon value:(NSString *)value tag:(int )tag hasDetail:(BOOL)hasDetail
{
    cell.lblTitle.text = title;
    cell.txtValue.text = value;
    cell.txtValue.delegate = self;
    cell.txtValue.placeholder = title;
    //tag  9  设置头像
    if (tag == 9) {
        if (self.group.photo != nil && self.group.photo.big.length > 0) {
            [[DAFileModule alloc] getPicture:self.group.photo.big callback:^(NSError *err, NSString *pictureId){
                photoView.image = [DACommon getCatchedImage:pictureId];
            }];
        } else {
            photoView.image = [UIImage imageNamed:@"group_gray.png"];
        }
        
        [cell addSubview:photoView];
    }
    //tag ==2  设置公开
    if (tag == 2) {
        cell.txtValue.hidden = YES;
        switchView = [[UISwitch alloc] initWithFrame:CGRectMake(220.0f, 10.0f, 169.0f, 30.0f)];
        
        if (self.group!=nil) {
            if ([self.group.secure isEqualToString:GroupSecureTypePublic]) {
                switchView.on = YES;
            }else{
                switchView.on = NO;
            }
            
        }else{
            switchView.on = YES;
        }
        
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if (!editEnable) {
            switchView.enabled = NO;
        }
        if (isDepartment) {
            switchView.enabled = NO;
        }
        if (ISNEW) {
            switchView.enabled = YES;
        }
        
        [cell addSubview:switchView];
    }
    if (!ISNEW) {
        [cell.txtValue setEnabled:NO];
    }else{
        [cell.txtValue setEnabled:YES];
    }
    
    if (editEnable) {
        if (isDepartment&&tag == 2) {
            [cell.txtValue setEnabled:NO];
        }else{
            [cell.txtValue setEnabled:YES];
        }
    }
    cell.imgIcon.image = [UIImage imageNamed:icon];
    if (hasDetail) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.txtValue removeFromSuperview];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [cell.txtValue addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.txtValue setTag:tag];
    return cell;
}

// 收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void) textFieldDidChange:(UITextField *) TextField
{
    // 没有，则创建组
    if (self.group == nil) {
        self.group = [[DAGroup alloc] init];
        self.group.name = [[GroupName alloc] init];
    }
    if (TextField.tag == 1) {
        self.group.name.name_zh = TextField.text;
        if (TextField.text.length>0) {
            [self.saveBtn setEnabled:YES];
        }else{
            [self.saveBtn setEnabled:NO];
        }
    } else if(TextField.tag == 3){
        self.group.category = TextField.text;
    } else if(TextField.tag == 4){
        self.group.description = TextField.text;
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
// 画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[DAHelper documentPath:@"upload.jpg"] atomically:YES];
    isPhotoChanged = YES;
    photoView.image = image;
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

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGRect r = self.view.frame;
    r.size.height = viewHeight - height;
    
    // 上移View
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = r;
    }];
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect r = self.view.frame;
    r.size.height = viewHeight;

    // 下移View
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = r;
    }];
}


@end
