//
//  DAUserModule.m
//  TribeSDK
//
//  Created by LI LIN on 2013/05/19.
//  Copyright (c) 2013年 LI LIN. All rights reserved.
//

#import "DAUserModule.h"

#define kURLGetUser                 @"/user/get.json?_id=%@"
#define kURLGetUserList             @"/user/list.json?start=%d&count=%d"
#define kURLGetUserFollowerList     @"/user/list.json?kind=follower&uid=%@&start=%d&count=%d&keywords=%@"
#define kURLGetUserFollowingList    @"/user/list.json?kind=following&uid=%@&start=%d&count=%d&keywords=%@"
#define kURLFollow                  @"/user/follow.json?_id=%@"
#define kURLUnfollow                @"/user/unfollow.json?_id=%@"
#define kURLUpdate                  @"/user/update.json?_id=%@"
#define kURLGetUserSearchListBykeywords             @"/user/list.json?start=%d&count=%d&kind=all&gid=%@&keywords=%@"
#define kURLGetUserInGroupListBykeywords             @"/user/list.json?start=%d&count=%d&uid=%@&kind=group&gid=%@&keywords=%@"
#define kURLUpdateUserPhoto         @"/image/cropAndThumb.json?width=%f&x=0&y=0"
@implementation DAUserModule

- (void) getUserListStart:(int)start count:(int)count keywords:(NSString *)keywords callback:(void (^)(NSError *error, DAUserList *users))callback;

{
    DAAFHttpClient *client = [DAAFHttpClient sharedClient];
    NSString *path = [NSString stringWithFormat:kURLGetUserSearchListBykeywords, start, count,@"",[client uriEncodeForString:keywords]];
    
    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, [[DAUserList alloc] initWithDictionary:[responseObject valueForKeyPath:@"data"]]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
        
    }];
}


- (void) getUserListInGroup:(NSString *)gid uid:(NSString *)uid start:(int)start count:(int)count keywords:(NSString *)keywords callback:(void (^)(NSError *error, DAUserList *users))callback
{
    DAAFHttpClient *client = [DAAFHttpClient sharedClient];
    NSString *path = [NSString stringWithFormat:kURLGetUserInGroupListBykeywords, start, count,uid,gid,[client uriEncodeForString:keywords]];
    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, [[DAUserList alloc] initWithDictionary:[responseObject valueForKeyPath:@"data"]]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
        
    }];
}


- (void)getUserFollowerListByUser:(NSString *)uid start:(int)start count:(int)count  keywords:(NSString *)keywords callback:(void (^)(NSError *error, DAUserList *users))callback
{
    DAAFHttpClient *client = [DAAFHttpClient sharedClient];
    NSString *path = [NSString stringWithFormat:kURLGetUserFollowerList, uid, start, count,[client uriEncodeForString:keywords]];
    
    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, [[DAUserList alloc] initWithDictionary:[responseObject valueForKeyPath:@"data"]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];
}

- (void)getUserFollowingListByUser:(NSString *)uid start:(int)start count:(int)count  keywords:(NSString *)keywords callback:(void (^)(NSError *error, DAUserList *users))callback
{
    DAAFHttpClient *client = [DAAFHttpClient sharedClient];
    NSString *path = [NSString stringWithFormat:kURLGetUserFollowingList, uid, start, count,[client uriEncodeForString:keywords]];
    
    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, [[DAUserList alloc] initWithDictionary:[responseObject valueForKeyPath:@"data"]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];
}


- (void)getUserById:(NSString *)uid callback:(void (^)(NSError *error, DAUser *user))callback
{
    NSString *path = [NSString stringWithFormat:kURLGetUser, uid];
    
    [[DAAFHttpClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, [[DAUser alloc] initWithDictionary:[responseObject valueForKeyPath:@"data"]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];
}


- (void)follow:(NSString *)uid callback:(void (^)(NSError *error, NSString *uid))callback
{
    NSString *path = [NSString stringWithFormat:kURLFollow, uid];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:uid, @"uid", nil];
    
    [[DAAFHttpClient sharedClient] putPath:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, uid);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];
}

- (void)unfollow:(NSString *)uid callback:(void (^)(NSError *error, NSString *uid))callback
{
    NSString *path = [NSString stringWithFormat:kURLUnfollow, uid];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:uid, @"uid", nil];
    
    [[DAAFHttpClient sharedClient] putPath:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, uid);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];
}

- (void)update:(DAUser *)user callback:(void (^)(NSError *error, DAUser *user))callback
{
    NSString *path = [NSString stringWithFormat:kURLUpdate, user._id];
    
    [[DAAFHttpClient sharedClient] putPath:path parameters:[user toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, [[DAUser alloc] initWithDictionary:[responseObject valueForKeyPath:@"data"]]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];
}

- (void)changePassword:(DAUser*)user oldPassword:(NSString*)password newPassword:(NSString*)newPassword callback:(void (^)(NSError *error, DAUser *users))callback
{

    NSString *path = [NSString stringWithFormat:kURLUpdate, user._id];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:password,@"pwd",newPassword,@"pwd1", nil];
    param = [NSMutableDictionary dictionaryWithObjectsAndKeys:param,@"password_new", nil];
    [param addEntriesFromDictionary:[user toDictionary]];
    [[DAAFHttpClient sharedClient] putPath:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (callback) {
            callback(nil, [[DAUser alloc] initWithDictionary:[responseObject valueForKeyPath:@"data"]]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];

}

- (void)uploadUserPhoto:(NSData *)data fileName:(NSString *)fileName width:(float)width callback:(void (^)(NSError *error, NSDictionary *photos))callback {
    
    NSString *mimeType = @"image/jpg";
    
    DAAFHttpClient *httpClient = [DAAFHttpClient sharedClient];
    NSString *path = [NSString stringWithFormat:kURLUpdateUserPhoto,width];
    // 添加formData到Request
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                         path:path
                                                                   parameters:nil
                                                    constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                        
                                                        [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:mimeType];
                                                    }];
    
    // 设定上传进度block
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        if (progress) {
//            progress((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
//        }
//    }];
    
    // 设定上传结束block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        if (callback) {
            NSError *jsonError = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonError];
//            DAFileList *files = [[DAFileList alloc] initWithDictionary:[result objectForKey:@"data"]];
//            NSString *big = [[[[result objectForKey:@"data"] objectForKey:@"big"] objectAtIndex:0] objectForKey:@"_id"];
//            NSString *middle = [[[[result objectForKey:@"data"] objectForKey:@"middle"] objectAtIndex:0] objectForKey:@"_id"];
//            NSString *small = [[[[result objectForKey:@"data"] objectForKey:@"small"] objectAtIndex:0] objectForKey:@"_id"];
            NSDictionary *photos = [NSDictionary  dictionaryWithObjectsAndKeys :
                                    [[[[result objectForKey:@"data"] objectForKey:@"big"] objectAtIndex:0] objectForKey:@"_id"],@"big",
                                    [[[[result objectForKey:@"data"] objectForKey:@"middle"] objectAtIndex:0] objectForKey:@"_id"],@"middle",
                                    [[[[result objectForKey:@"data"] objectForKey:@"small"] objectAtIndex:0] objectForKey:@"_id"],@"small",
                                    nil];
            callback(jsonError, photos);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (callback) {
            callback(error, nil);
        }
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
}


@end
