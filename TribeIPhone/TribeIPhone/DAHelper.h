//
//  DAMessageHelper.h
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/21.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TribeSDKHeader.h"
#import "CQMFloatingController.h"
#import "MBProgressHUD.h"

#define DAColor [UIColor colorWithRed:102.0f/255.0f green:0.0f/255.0f blue:204.0f/255.0f alpha:1.0f]

@interface DAHelper : NSObject

+ (NSString *) fileanExtension:(NSString *)type;
+ (BOOL) isNetworkReachable;
+ (CQMFloatingController *) showPopup:(UIViewController *)viewController;
+ (void) hidePopup;


+ (NSDate *) dateFromISODateString:(NSString *)isodate;
+ (NSString *) currentDateString;
+ (NSString *) stringFromISODate:(NSDate *)isodate;
+ (NSString *) stringFromISODateString:(NSString *)isodate;


+ (NSString *) documentPath:(NSString *)file;
+ (BOOL) isFileExist:(NSString *)fullPahtFile;
+ (uint64_t)totalSpace;
+ (int)fts:(NSString *)path;
+ (void)removeAllFile:(NSString *)directory;

+ (NSString *) localizedStringWithKey:(NSString *)key comment:(NSString *)comment;


+ (void)alert:(UIView *)view message:(NSString *)message detail:(NSString *)detail;
+ (void)alert:(UIView *)view message:(NSString *)message detail:(NSString *)detail delay:(NSTimeInterval)delay yOffset:(CGFloat)yOffset;


+ (void)setDefaultButtonStyle:(UIButton *)button name:(NSString *)name;

@end
