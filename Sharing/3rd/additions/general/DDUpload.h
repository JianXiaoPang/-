//
//  DDUpload.h
//  dd
//
//  Created by darkdong on 13-3-21.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <Foundation/Foundation.h>
//notification name
extern NSString * const DDUploadNotificationNameUploadingProgress;
extern NSString * const DDUploadNotificationNameFileDidUpload;

//notification user info key
extern NSString * const DDUploadNotificationUserInfoKeyProgress;
extern NSString * const DDUploadNotificationUserInfoKeyResult;
extern NSString * const DDUploadNotificationUserInfoKeyPlist;
extern NSString * const DDUploadNotificationUserInfoKeyResultSuccess;

//plist key
extern NSString * const DDUploadFileKeyMethod;
extern NSString * const DDUploadFileKeyTimeout;
extern NSString * const DDUploadFileKeyBaseURL;
extern NSString * const DDUploadFileKeyCommandPath;
extern NSString * const DDUploadFileKeyParameters;
extern NSString * const DDUploadFileKeyFormDataes;
extern NSString * const DDUploadFileKeyFormDataName;
extern NSString * const DDUploadFileKeyFormDataData;

extern NSString * const DDUploadFileKeyShouldExecuteAsBackgroundTask;
extern NSString * const DDUploadFileKeyShouldPostProgressNotification;

@interface DDUpload : NSObject

//+ (NSString *)dirPathForUploading;
+ (void)startUploadService;
+ (NSString *)uploadWithInfo:(NSDictionary *)info;
+ (void)cancelUploading;
+ (BOOL)removeUploadInfoFile:(NSString *)plistFilePath;

@end
