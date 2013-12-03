//
//  DAMessageHelper.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/21.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAHelper.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <fts.h>


@implementation DAHelper


+ (NSString *) fileanExtension:(NSString *)type
{
    NSMutableDictionary *mime = [[NSMutableDictionary alloc] init];
    [mime setObject:@"doc" forKey:@"application/msword"];
    [mime setObject:@"docx" forKey:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document"];
    [mime setObject:@"xls" forKey:@"application/vnd.ms-excel"];
    [mime setObject:@"xlsx" forKey:@"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"];
    [mime setObject:@"ppt" forKey:@"application/vnd.ms-powerpoint"];
    [mime setObject:@"pptx" forKey:@"application/vnd.openxmlformats-officedocument.presentationml.presentation"];
    [mime setObject:@"ppsx" forKey:@"application/vnd.openxmlformats-officedocument.presentationml.slideshow"];
    [mime setObject:@"pdf" forKey:@"application/pdf"];
    [mime setObject:@"rtf" forKey:@"application/rtf"];
    [mime setObject:@"zip" forKey:@"application/zip"];
    [mime setObject:@"bmp" forKey:@"image/bmp"];
    [mime setObject:@"gif" forKey:@"image/gif"];
    [mime setObject:@"jpeg" forKey:@"image/jpeg"];
    [mime setObject:@"png" forKey:@"image/png"];
    [mime setObject:@"tiff" forKey:@"image/tiff"];
    [mime setObject:@"txt" forKey:@"text/plain"];
    [mime setObject:@"avi" forKey:@"video/msvideo"];
    [mime setObject:@"mov" forKey:@"video/quicktime"];
    
    NSString *result = [mime objectForKey:type];
    if (result == nil) {
        result = @"file";
    }
    
    return [NSString stringWithFormat:@"%@.png", result];
}

+ (BOOL) isNetworkReachable
{
    return [[DAAFHttpClient sharedClient] isReachable];
}



+ (CQMFloatingController *) showPopup:(UIViewController *)viewController
{
    // Get shared floating controller, and customize if needed
    CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    [floatingController setFrameColor:[UIColor colorWithRed:0.30f green:0.17f blue:0.4f alpha:1.0f]];
    
    // Show floating controller with content
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = [window.rootViewController view];
    
    
    [floatingController showInView:rootView
         withContentViewController:viewController
                          animated:YES];

    return floatingController;
}

+ (void) hidePopup
{
    // Get shared floating controller, and customize if needed
    CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    
    [floatingController dismissAnimated:YES];
}


// ---- 日期相关 ----
+ (NSDate *) dateFromISODateString:(NSString *)isodate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    return [dateFormatter dateFromString:isodate];
}

+ (NSString *) stringFromISODate:(NSDate *)isodate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd HH:mm"];
    return [format stringFromDate:isodate];
}

+ (NSString *) stringFromISODateString:(NSString *)isodate
{
    NSDate *date = [DAHelper dateFromISODateString:isodate];
    return [DAHelper stringFromISODate:date];
}

+ (NSString *) currentDateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format stringFromDate:[NSDate date]];
}

// ---- 文件，目录相关 ----
+ (NSString *) documentPath:(NSString *)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], file];
}


+ (BOOL) isFileExist:(NSString *)fullPahtFile
{
    BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = ([fileManager fileExistsAtPath:fullPahtFile isDirectory:&isDir] && !isDir);
    return fileExists;
}

// 获取整个硬盘容量(KB)
+ (uint64_t)totalSpace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu GB with %llu GB Free memory available.", ((totalSpace/1024ll)/1024ll/1024ll), ((totalFreeSpace/1024ll)/1024ll/1024ll));
    }
    else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    
    return totalSpace/1024ll;
}

// 获取指定目录下，文件的大小（KB）。高速版
// http://cocoadays.blogspot.jp/2011/03/ios-bsdfts.html
+ (int)fts:(NSString *)path
{
    int size = 0;
    FTS* fts;
    FTSENT *entry;
    char* paths[] = { (char *)[path UTF8String], nil };
    fts = fts_open(paths, 0, nil);
    while ((entry = fts_read(fts))) {
        if (entry->fts_info & FTS_DP || entry->fts_level == 0) {
            // ignore post-order
            continue;
        }
        if (entry->fts_info & FTS_F) {
            size += entry->fts_statp->st_size;
        }
    }
    fts_close(fts);
    
    return size / 1024;
}

+ (void)removeAllFile:(NSString *)directory
{
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", directory, file] error:&error];
        if (!success || error) {
            // 删除文件出错
            NSLog(@"Error Obtaining Remove.");
        }
    }
}

+ (NSString *) localizedStringWithKey:(NSString *)key comment:(NSString *)comment
{
    return NSLocalizedString(key, comment);
}

+ (void)alert:(UIView *)view message:(NSString *)message detail:(NSString *)detail
{
    [self alert:view message:message detail:detail delay:5 yOffset:50.f];
}

+ (void)alert:(UIView *)view message:(NSString *)message detail:(NSString *)detail delay:(NSTimeInterval)delay yOffset:(CGFloat)yOffset
{
    MBProgressHUD *progress;
    progress = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    progress.mode = MBProgressHUDModeText;
    progress.dimBackground = YES;
    progress.labelText = message;
    progress.detailsLabelText = detail;
    progress.margin = 10.f;
    progress.yOffset = yOffset;
    progress.removeFromSuperViewOnHide = YES;
    [progress hide:YES afterDelay:delay];
}

// 设定按钮风格
+ (void)setDefaultButtonStyle:(UIButton *)button name:(NSString *)name
{
    button.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [[UIImage imageNamed:@"normal-button"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [[UIImage imageNamed:@"normal-button-highlighted"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:sendBack forState:UIControlStateNormal];
    [button setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [button setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = NSLocalizedString(name, nil);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    UIColor *titleShadow = DAColor;
    [button setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [button setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    button.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
}

@end
