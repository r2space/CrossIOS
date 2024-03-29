//
//  DAUserModule.h
//  TribeSDK
//
//  Created by LI LIN on 2013/05/19.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DAAFHttpClient.h"
#import "DAUser.h"
#import "DAUserList.h"

@interface DAUserModule : NSObject


- (void) getUserListStart:(int)start count:(int)count keywords:(NSString *)keywords callback:(void (^)(NSError *error, DAUserList *users))callback;

- (void) getUserListInGroup:(NSString *)gid uid:(NSString *)uid start:(int)start count:(int)count keywords:(NSString *)keywords callback:(void (^)(NSError *error, DAUserList *users))callback;


- (void)getUserFollowerListByUser:(NSString *)uid
                            start:(int)start
                            count:(int)count
                         keywords:(NSString *)keywords
                         callback:(void (^)(NSError *error, DAUserList *users))callback;

- (void)getUserFollowingListByUser:(NSString *)uid
                             start:(int)start
                             count:(int)count
                          keywords:(NSString *)keywords
                          callback:(void (^)(NSError *error, DAUserList *users))callback;

- (void)getUserById:(NSString *)uid callback:(void (^)(NSError *error, DAUser *user))callback;
- (void)follow:(NSString *)uid callback:(void (^)(NSError *error, NSString *uid))callback;
- (void)unfollow:(NSString *)uid callback:(void (^)(NSError *error, NSString *uid))callback;
- (void)update:(DAUser *)user callback:(void (^)(NSError *error, DAUser *user))callback;
- (void)changePassword:(DAUser*)user
           oldPassword:(NSString*)password
           newPassword:(NSString*)newPassword
            callback:(void (^)(NSError *error, DAUser *users))callback;
- (void)uploadUserPhoto:(NSData *)data fileName:(NSString *)fileName width:(float)width callback:(void (^)(NSError *error, NSDictionary *photos)) callback;

@end
