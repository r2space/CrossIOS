//
//  DACreateMessageViewController.m
//  tribe
//
//  Created by 李 林 on 2012/12/04.
//  Copyright (c) 2012年 dac. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DAContributeViewController.h"
#import "DAFileSelectViewController.h"
#import "WTStatusBar.h"
#import "DALoginProxy.h"

@interface DAContributeViewController ()
{
    CLLocationManager *_manager;
    CLGeocoder *_geocoder;
    NSMutableArray *_rangeGroup;
    NSMutableArray *_atGroups;
    NSMutableArray *_atUsers;
    NSMutableArray *_documents;
    BOOL _photoFromCamera;
    NSString *_actionType;
}

@end

@implementation DAContributeViewController
@synthesize message = _message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _message = [[DAMessage alloc] init];
        _isForward = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self.txtMessage becomeFirstResponder];
    _geocoder = [[CLGeocoder alloc] init];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    _message = [[DAMessage alloc] init];
    _message.contentType = message_contenttype_text;
    _rangeGroup = [[NSMutableArray alloc] init];
    _atGroups = [[NSMutableArray alloc] init];
    _atUsers = [[NSMutableArray alloc] init];
    if (_documents == nil) {
        _documents = [[NSMutableArray alloc] init];
    }
    
    if ([_message.type isEqualToNumber:[NSNumber numberWithInt:2]]) {
        [self.optionView setHidden:YES];
    }
    
    if (_isForward) {
        [self.btnLocation setHidden:YES];
        [self.btnCamera setHidden:YES];
        [self.imgAttach setHidden:YES];
        [self.btnDocument setHidden:YES];
        [self.btnPhoto setHidden:YES];
    }
    
    self.txtMessage.layer.borderWidth = 1.2;
    self.txtMessage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.txtMessage.layer.cornerRadius = 10;
    
    self.btnClearImg.hidden = YES;
    
    if ([@"shareDocument" isEqualToString:_actionType]) {
        _message.contentType = message_contenttype_document;
        [self.btnPhoto setHidden:YES];
        [self.btnCamera setHidden:YES];
    }
    
    [self setTitle];
    [self renderButtons];
    
    self.barBtnSend.enabled = NO;
    
    self.txtMessage.delegate = self;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
-(void) viewDidAppear:(BOOL)animated
{
    DALoginProxy *loginProxy = [DALoginProxy sharedInstance];
    [loginProxy setCurVC:self];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDocuments:(NSArray *)documents
{
    _documents = [[NSMutableArray alloc] initWithArray:documents];
    _actionType = @"shareDocument";
}

-(void)renderButtons
{
    if ([self hasAt]) {
        [self.btnAt setImage:[UIImage imageNamed:@"people-communicate_blue.png"] forState:UIControlStateNormal];
    } else {
        [self.btnAt setImage:[UIImage imageNamed:@"people-communicate.png"] forState:UIControlStateNormal];
    }
    
    if ([self hasRange]) {
        [self.btnRange setImage:[UIImage imageNamed:@"business-team_blue.png"] forState:UIControlStateNormal];
    } else {
        [self.btnRange setImage:[UIImage imageNamed:@"business-team.png"] forState:UIControlStateNormal];
    }
    
    
    
    if ([message_contenttype_image isEqualToString:_message.contentType]) {
        if (_photoFromCamera) {
            [self.btnCamera setImage:[UIImage imageNamed:@"photography-camera_blue.png"] forState:UIControlStateNormal];
            [self.btnPhoto setImage:[UIImage imageNamed:@"image.png"] forState:UIControlStateNormal];
        } else {
            [self.btnCamera setImage:[UIImage imageNamed:@"photography-camera.png"] forState:UIControlStateNormal];
            [self.btnPhoto setImage:[UIImage imageNamed:@"image_blue.png"] forState:UIControlStateNormal];
        }
    } else {
        [self.btnCamera setImage:[UIImage imageNamed:@"photography-camera.png"] forState:UIControlStateNormal];
        [self.btnPhoto setImage:[UIImage imageNamed:@"image.png"] forState:UIControlStateNormal];
    }
    
    if ([message_contenttype_document isEqualToString:_message.contentType]) {
        [self.btnDocument setImage:[UIImage imageNamed:@"folder_blue.png"] forState:UIControlStateNormal];
    } else {
        [self.btnDocument setImage:[UIImage imageNamed:@"folder.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)onLocationClicked:(id)sender
{
    NSLog(@"onLocationClicked");
    
    // プロパティではなくクラスメソッドです
    if ([CLLocationManager locationServicesEnabled]) {
        // インスタンスを生成し、デリゲートの設定
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        
        // 取得精度
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 更新頻度（メートル）
        _manager.distanceFilter = kCLDistanceFilterNone;
        // サービスの開始
        [_manager startUpdatingLocation];
    }
    
}

// 標準位置情報サービス・大幅変更位置情報サービスの取得に成功した場合
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    CLLocationDegrees latitude = 37.33233141;
//    CLLocationDegrees longitude = -122.03121860;
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

    
    // 逆ジオコーディングの開始　住所名を取得
    [_geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
        } else {
            if (0 < [placemarks count]) {
                // ログ出力
                NSLog(@"%s", __PRETTY_FUNCTION__);
                CLPlacemark *placemark = [placemarks objectAtIndex:0];

                NSLog(@"addressDictionary: %@", placemark.addressDictionary);
                NSLog(@"administrativeArea: %@", placemark.administrativeArea);
                NSLog(@"areasOfInterest: %@", placemark.areasOfInterest);
                NSLog(@"country: %@", placemark.country);
                NSLog(@"inlandWater: %@", placemark.inlandWater);
                NSLog(@"locality: %@", placemark.locality);
                NSLog(@"name: %@", placemark.name);
                NSLog(@"ocean: %@", placemark.ocean);
                NSLog(@"postalCode: %@", placemark.postalCode);
                NSLog(@"region: %@", placemark.region);
                NSLog(@"subAdministrativeArea: %@", placemark.subAdministrativeArea);
                NSLog(@"subLocality: %@", placemark.subLocality);
                NSLog(@"subThoroughfare: %@", placemark.subThoroughfare);
                NSLog(@"thoroughfare: %@", placemark.thoroughfare);
                
                // 住所のテキストフィールドに反映
                NSString *formattedAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@" "];
                
                self.txtMessage.text = formattedAddress;
                
            }
        }
    }];

    
    // ここで任意の処理
    NSLog(@"%s | %@, %@", __PRETTY_FUNCTION__, newLocation, oldLocation);
}

// 標準位置情報サービス・大幅変更位置情報サービスの取得に失敗した場合
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // ここで任意の処理
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
    
    if ([error code] == kCLErrorDenied) {
        // 位置情報の利用が拒否されているので停止
        [manager startUpdatingLocation];
    }
}


- (IBAction)onCameraClicked:(id)sender
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.allowsEditing = NO;
    
    // モーダルビューとしてカメラ画面を呼び出す
    [self presentViewController:ipc animated:YES completion:nil];
}

- (IBAction)onPhotoLibraryClicked:(id)sender
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = NO;
    
    // モーダルビューとしてカメラ画面を呼び出す
    [self presentViewController:ipc animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imgAttach.image = image;
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[DAHelper documentPath:@"attach.jpg"] atomically:YES];
    _message.contentType = message_contenttype_image;
    self.btnClearImg.hidden = NO;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _photoFromCamera = YES;
    } else {
        _photoFromCamera = NO;
    }
    [self renderButtons];
}

- (IBAction)onAtClicked:(id)sender
{
    DAMemberSelectViewController *ctrl = [[DAMemberSelectViewController alloc]initWithNibName:@"DAMemberSelectViewController" bundle:nil];
    ctrl.allowMultiSelect = YES;
    ctrl.selectedBlocks = ^(NSArray *users){
        _atUsers = [NSMutableArray arrayWithArray:users];
        [self renderButtons];
    };
    ctrl.selectedUsers = _atUsers;
    if ([self hasRange]) {
        ctrl.inGroup = [_rangeGroup objectAtIndex:0];
    }
    [self presentViewController:ctrl animated:YES completion:nil];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
//    actionSheet.delegate = self;
//    
//    int cancelIdx = 1;
//    [actionSheet addButtonWithTitle:@"@users"];
//    if (![self hasRange]) {
//        [actionSheet addButtonWithTitle:@"@groups"];
//        cancelIdx = 2;
//    }
//    [actionSheet addButtonWithTitle:@"Cancel"];
//    [actionSheet setCancelButtonIndex:cancelIdx];
//    
//    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnString = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnString isEqualToString:@"@groups"]) {
        DAGroupSelectViewController *ctrl = [[DAGroupSelectViewController alloc]initWithNibName:@"DAGroupSelectViewController" bundle:nil];
        ctrl.allowMultiSelect = YES;
        ctrl.selectedBlocks = ^(NSArray *groups){
            _atGroups = [NSMutableArray arrayWithArray:groups];
            [self renderButtons];
        };
        ctrl.selectedGroups = _atGroups;
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    if ([btnString isEqualToString:@"@users"]) {
        DAMemberSelectViewController *ctrl = [[DAMemberSelectViewController alloc]initWithNibName:@"DAMemberSelectViewController" bundle:nil];
        ctrl.allowMultiSelect = YES;
        ctrl.selectedBlocks = ^(NSArray *users){
            _atUsers = [NSMutableArray arrayWithArray:users];
            [self renderButtons];
        };
        ctrl.selectedUsers = _atUsers;
        if ([self hasRange]) {
            ctrl.inGroup = [_rangeGroup objectAtIndex:0];
        }
        [self presentViewController:ctrl animated:YES completion:nil];
    }
}


- (IBAction)onMoticonClicked:(id)sender
{
}

- (IBAction)onClearImgClicked:(id)sender
{
    self.imgAttach.image = nil;
    self.btnClearImg.hidden = YES;
    _message.contentType = message_contenttype_text;
}

- (IBAction)onRangeClicked:(id)sender
{
    DAGroupSelectViewController *ctrl = [[DAGroupSelectViewController alloc]initWithNibName:@"DAGroupSelectViewController" bundle:nil];
    ctrl.selectedGroups = _rangeGroup;
    ctrl.allowMultiSelect = NO;
    ctrl.selectedBlocks = ^(NSArray *groups){
        _rangeGroup = [NSMutableArray arrayWithArray:groups];
        if ([self hasRange]) {
            [_atGroups removeAllObjects];
            [_atUsers removeAllObjects];
        }
        [self setTitle];
        [self renderButtons];
    };
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (IBAction)onDocumetnClicked:(id)sender {
    DAFileSelectViewController *ctrl = [[DAFileSelectViewController alloc] initWithNibName:@"DAFileSelectViewController" bundle:nil];
    ctrl.selectedFiles = _documents;
    ctrl.allowMultiSelect = NO;
    ctrl.selectedBlocks = ^(NSArray *files){
        _documents = [NSMutableArray arrayWithArray:files];
        if (_documents.count > 0) {
            _message.contentType = message_contenttype_document;
        }
        [self renderButtons];
    };
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (IBAction)onCancelClicked:(id)sender
{
    [WTStatusBar clearStatusAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSendClicked:(id)sender
{
    
    [self showIndicator:@"updating..."];
    
    // 开启异步线程，否则阻塞在同一个UI线程中，上面的showIndicator不能立即显示
    const char *sendQueueName = [@"sendQueue" UTF8String];
    dispatch_queue_t sendQueue = dispatch_queue_create(sendQueueName, NULL);
    dispatch_async(sendQueue, ^(void) {
        [self startSend];
    });
}

// 开时发送
-(void)startSend
{
    _message.content = self.txtMessage.text;
    if (_rangeGroup.count > 0) {
        _message.range = ((DAGroup *)[_rangeGroup objectAtIndex:0])._id;
    } else {
        _message.range = @"1";
    }
    _message.at = [[MessageAt alloc] init];
    if (_atUsers.count > 0) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        for (DAUser *user in _atUsers) {
            [users addObject:user._id];
        }
        _message.at.users = users;
    }
    if (_atGroups.count > 0) {
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        for (DAGroup *group in _atGroups) {
            [groups addObject:group._id];
        }
        _message.at.groups = groups;
    }
    
    if ([message_contenttype_document isEqualToString:_message.contentType]) {
        NSMutableArray *files = [[NSMutableArray alloc] init];
        for (DAFile *file in _documents) {
            MessageAttach *attach = [[MessageAttach alloc] init];
            attach.fileid = file._id;
            attach.filename = file.filename;
            [files addObject:attach];
        }
        _message.attach = files;
    }
    
    
    if ([message_contenttype_image isEqualToString:_message.contentType]) {
        NSString *file = [DAHelper documentPath:@"attach.jpg"];
        if ([DAHelper isFileExist:file]) {
            if ([self preUpdate]) {
                return;
            }

            // 在状态栏显示进度， UI的更新需在主线程中进行
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [WTStatusBar setProgressBarColor:DAColor];
                [WTStatusBar setStatusText:@"uploading..." animated:YES];
            });
            // 优化Image数据
            NSData *jpegData = [self optimizeImage:file];
            // 开始上传图片
            [[DAFileModule alloc] uploadPicture:jpegData fileName:file mimeType:@"image/jpg" callback:^(NSError *error, DAFile *file){
                [WTStatusBar setStatusText:@"done!" timeout:0.5 animated:YES];
                if ([self finishUpdateError:error]) {
                    return ;
                }
                
                MessageAttach *attach = [[MessageAttach alloc] init];
                attach.fileid = file._id;
                attach.filename = file.filename;
                _message.attach = [NSArray arrayWithObjects:attach, nil];
                
                [self sendMessage:_message];
                
            } progress:^(CGFloat percent){
                [WTStatusBar setProgress:percent animated:YES];
            }];
        } else {
            // TODO error
        }
    } else {
        if (_isForward) {
            [self forwardMessage:_message];
        } else {
            [self sendMessage:_message];
        }
    }
}

// 优化图片数据的大小
-(NSData *)optimizeImage:(NSString *)file
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:file];
    CGFloat compressionQuality = 1;
    NSData *jpegData = [[NSData alloc] initWithData: UIImageJPEGRepresentation( image, compressionQuality )];
    NSLog(@"Image width: %f, height: %f, scale:%f", image.size.height, image.size.width,image.scale);
    
    // 这个块里的代码留着以后参照
    {
        //NSError *attributesError = nil;
        //NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&attributesError];
        //int fileSize = [fileAttributes fileSize];
        
        ////NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        ////long long fileSize2 = [fileSizeNumber longLongValue];
        
        //CGFloat oldCompression = 1;
        //if(jpegData.length > 0)
        //    oldCompression = fileSize / jpegData.length;
    }
    
    NSUInteger limitLength = 300 * 1024;    // 限定图片尺寸300K
    NSUInteger minChangeLength = 10 * 1024; // 最小减少的尺寸10K
    
    // 压缩图片
    NSUInteger lastLength;
    while (jpegData.length > limitLength) {
        if (jpegData.length > limitLength * 3)     // 大于限定大小3倍时
            compressionQuality *= 0.5f; // 50%
        else if(jpegData.length > limitLength * 2) // 大于限定大小2倍时
            compressionQuality *= 0.6f; // 60%
        else
            compressionQuality *= 0.8f; // 80%
        
        lastLength = jpegData.length;
        jpegData = [[NSData alloc] initWithData: UIImageJPEGRepresentation( image, compressionQuality )];
        NSLog(@"compressionQuality=%f; jpegData.length=%d" ,compressionQuality, jpegData.length);
        
        // 压缩后减少的尺寸太少时，不用再压缩
        if((lastLength - jpegData.length) < minChangeLength)
            break;
    }
    
    // 尺寸还大时，进行缩放，这里的算法以后在可优化
    if (jpegData.length > limitLength + minChangeLength) {
        UIImage *newImage = image;
        NSArray *scaleArray = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.85]//
                               ,[NSNumber numberWithFloat:0.5]//
                               ,[NSNumber numberWithFloat:0.25]//
                               ,[NSNumber numberWithFloat:0.20]//
                               ,[NSNumber numberWithFloat:0.15]//
                               ,[NSNumber numberWithFloat:0.10]//
                               ,[NSNumber numberWithFloat:0.05]//
                               ,nil];
        
        CGSize newSize = CGSizeMake(newImage.size.width, newImage.size.height);
        for (NSNumber *scale in scaleArray) {
            // 缩放图片
            newSize = CGSizeMake(newSize.width * scale.floatValue, newSize.height * scale.floatValue);
            UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSLog(@"After scale, image size: %fx%f" ,newImage.size.width, newImage.size.height);
            
            // 按最后一次的压缩率重新生成缩放后的图片数据
            jpegData = [[NSData alloc] initWithData: UIImageJPEGRepresentation( newImage, compressionQuality )];
            NSLog(@"After scale, image data length: %d" ,jpegData.length);
            
            // 缩放后减少的尺寸太少时，不用再缩放
            if(jpegData.length <= limitLength + minChangeLength)
                break;
        }
    }
    
    return jpegData;
}

-(void)sendMessage:(DAMessage *)message
{
    if ([self preUpdate]) {
        return;
    }
    [self showIndicator:@"updating..."];
    [[DAMessageModule alloc] send:message callback:^(NSError *error, DAMessage *message){
        if ([self finishUpdateError:error]) {
            return ;
        }
        
        if (self.onComplet) {
            self.onComplet();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)forwardMessage:(DAMessage *)message
{
    if ([self preUpdate]) {
        return;
    }
    [[DAMessageModule alloc] forward:message callback:^(NSError *error, DAMessage *message){
        if ([self finishUpdateError:error]) {
            return ;
        }
        
        if (self.onComplet) {
            self.onComplet();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(BOOL)hasRange
{
    return _rangeGroup.count > 0;
}

-(BOOL)hasAt
{
//    return _atUsers.count > 0 || _atGroups.count >0;
    return _atUsers.count > 0;
}

-(void)setTitle
{
    if ([_message.type isEqualToNumber:[NSNumber numberWithInt:2]]) {
        self.barTitle.title = [DAHelper localizedStringWithKey:@"message.comment" comment:@"评论"];
    } else if (_isForward){
        if ([self hasRange]) {
            self.barTitle.title = self.barTitle.title = ((DAGroup *)[_rangeGroup objectAtIndex:0]).name.name_zh;
        } else {
            self.barTitle.title = [DAHelper localizedStringWithKey:@"message.forward" comment:@"转发"];
;
        }
    } else {
        if ([self hasRange]) {
            self.barTitle.title = self.barTitle.title = ((DAGroup *)[_rangeGroup objectAtIndex:0]).name.name_zh;
        } else {
            self.barTitle.title = [DAHelper localizedStringWithKey:@"message.contribute" comment:@"写消息"];
        }
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if ([_message.type isEqualToNumber:[NSNumber numberWithInt:2]]) {
        height -= 30;
    } else {
        height += 8;
    }
    [self.lytToBottom setConstant:height];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    
    [self.barBtnSend setEnabled:newLength > 0];
    return YES;
}

@end
