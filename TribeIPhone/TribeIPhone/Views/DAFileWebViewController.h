//
//  DAFileWebViewController.h
//  TribeIPhone
//
//  Created by mac on 13-5-7.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TribeSDK/DAFileModule.h>
#import <TribeSDK/DAFile.h>
#import <TribeSDK/DAFileList.h>
@interface DAFileWebViewController : UIViewController
{
}



@property (weak, nonatomic) IBOutlet UIWebView  *webView;
@property (retain, nonatomic) NSString *fileUrl;
@property (retain, nonatomic) NSString *fileName;
@property (retain, nonatomic) NSString *downloadId;
@property (retain, nonatomic) NSString *fileExt;
@property (retain, nonatomic) DAFile *fileDb;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barTitle;

- (IBAction)onCancelTouched:(id)sender;
- (IBAction)onFileDetailTouched:(id)sender;

@end
