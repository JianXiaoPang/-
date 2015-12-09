//
//  DDUpload.m
//  dd
//
//  Created by darkdong on 13-3-21.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import "DDUpload.h"
#import "DDPreprocessMacro.h"
#import "AFNetworking.h"
#import "DDUtility.h"

//notification name
NSString * const DDUploadNotificationNameUploadingProgress = @"DDUploadNotificationNameUploadingProgress";
NSString * const DDUploadNotificationNameFileDidUpload = @"DDUploadNotificationNameFileDidUpload";

//notification user info key
NSString * const DDUploadNotificationUserInfoKeyProgress = @"DDUploadNotificationUserInfoKeyProgress";
NSString * const DDUploadNotificationUserInfoKeyResult = @"DDUploadNotificationUserInfoKeyResult";
NSString * const DDUploadNotificationUserInfoKeyPlist = @"DDUploadNotificationUserInfoKeyPlist";
NSString * const DDUploadNotificationUserInfoKeyResultSuccess = @"DDUploadNotificationUserInfoKeyResultSuccess";

//plist key
NSString * const DDUploadFileKeyMethod = @"method";
NSString * const DDUploadFileKeyTimeout = @"timeout";
NSString * const DDUploadFileKeyBaseURL = @"baseURL";
NSString * const DDUploadFileKeyCommandPath = @"command";
NSString * const DDUploadFileKeyParameters = @"parameters";
NSString * const DDUploadFileKeyFormDataes = @"formDataes";
NSString * const DDUploadFileKeyFormDataName = @"formDataName";
NSString * const DDUploadFileKeyFormDataData = @"formDataData";

NSString * const DDUploadFileKeyShouldExecuteAsBackgroundTask = @"shouldExecuteAsBackgroundTask";
NSString * const DDUploadFileKeyShouldPostProgressNotification = @"shouldPostProgressNotification";

static NSOperation *sCurrentUploadingOperation = nil;

static NSArray * DDUploadGetOrderedFiles(NSString *dirPath, BOOL excludingHiddenFiles)
{
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&error];
    if (error) {
        return nil;
    }
    NSMutableArray *mfiles = [files mutableCopy];
    if (excludingHiddenFiles) {
        NSIndexSet *indexes = [mfiles indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [obj hasPrefix:@"."];
        }];
        [mfiles removeObjectsAtIndexes:indexes];
    }
    [mfiles sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return [mfiles copy];
}

static NSString * DDUploadGetNextFilePathInDirectory(NSString *directory)
{
    BOOL excludingHiddenFiles = YES;
    NSArray *files = DDUploadGetOrderedFiles(directory, excludingHiddenFiles);
    NSString *fileName = [files lastObject];
    NSUInteger fileOrder = [[[fileName lastPathComponent] stringByDeletingPathExtension] integerValue];
    if (fileOrder >= 99999) {
        fileOrder = 1;
    }else {
        fileOrder++;
    }
    //00001-99999
    NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%05u", fileOrder]];
    return [filePath stringByAppendingPathExtension:@"plist"];
}

static void DDUploadPostNotificationFileDidUpload(id result, NSDictionary *plist, BOOL uploadSuccess)
{
    NSDictionary *userInfo = @{DDUploadNotificationUserInfoKeyResult: result,
                               DDUploadNotificationUserInfoKeyPlist: plist,
                               DDUploadNotificationUserInfoKeyResultSuccess: @(uploadSuccess),
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:DDUploadNotificationNameFileDidUpload object:nil userInfo:userInfo];
}

@implementation DDUpload

+ (NSLock *)uploadDirLock {
    static NSLock *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[NSLock alloc] init];
    });
    return sharedObj;
}

+ (NSLock *)uploadFileLock {
    static NSLock *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[NSLock alloc] init];
    });
    return sharedObj;
}

+ (void)uploadFilesInDirectory:(NSString *)uploadDir
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    BOOL __block isUploadingFile = NO;
    
    while (1) {
        @autoreleasepool {
            //            DDLog(@"DDUploadFilesInDirectory: check if there is file to upload");
            [[self uploadFileLock] lock];
            if (isUploadingFile) {
                [[DDUpload uploadFileLock] unlock];
                //                DDLog(@"DDUploadFilesInDirectory: there is uploading file, sleep a while");
                [NSThread sleepForTimeInterval:1];
                continue;
            }
            [[self uploadFileLock] unlock];
            
            //获取待上传的文件列表
            [[self uploadDirLock] lock];
            NSArray *fileNames = DDUploadGetOrderedFiles(uploadDir, YES);
            [[self uploadDirLock] unlock];
            
            if (0 == fileNames.count) {
                //                DDLog(@"DDUploadFilesInDirectory: there is no file to upload, sleep a while");
                [NSThread sleepForTimeInterval:1];
                continue;
            }
            
            [[self uploadFileLock] lock];
            isUploadingFile = YES;
            [[self uploadFileLock] unlock];
            
            NSString *fileName = fileNames[0];//取第一个待上传文件
            NSString *filePath = [uploadDir stringByAppendingPathComponent:fileName];
            NSDictionary *plistRootDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
            NSMutableDictionary *plistWithoutForm = [NSMutableDictionary dictionaryWithDictionary:plistRootDic];
            [plistWithoutForm removeObjectForKey:DDUploadFileKeyFormDataes];
            
            DDLog(@"DDUploadFilesInDirectory: will upload file %@ plistWithoutForm %@", fileName, plistWithoutForm);
            
            NSString *baseURLString = plistRootDic[DDUploadFileKeyBaseURL];
            
            NSURL *baseURL = [NSURL URLWithString:baseURLString];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
            
            NSString *method = plistRootDic[DDUploadFileKeyMethod];
            NSString *command = plistRootDic[DDUploadFileKeyCommandPath];
            NSDictionary *parameters = plistRootDic[DDUploadFileKeyParameters];
            NSArray *formDataes = plistRootDic[DDUploadFileKeyFormDataes];
            NSTimeInterval timeout = [plistRootDic[DDUploadFileKeyTimeout] floatValue];
            
            BOOL shouldExecuteAsBackgroundTask = [plistRootDic[DDUploadFileKeyShouldExecuteAsBackgroundTask] boolValue];
            BOOL shouldPostProgressNotification = [plistRootDic[DDUploadFileKeyShouldPostProgressNotification] boolValue];
            
            NSMutableURLRequest *request = nil;
            if (formDataes) {
                request = [httpClient multipartFormRequestWithMethod:method
                                                                path:command
                                                          parameters:parameters
                                           constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                               for (NSDictionary *formDataDic in formDataes) {
                                                   NSString *name = formDataDic[DDUploadFileKeyFormDataName];
                                                   NSData *data = formDataDic[DDUploadFileKeyFormDataData];
                                                   [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"application/octet-stream"];
                                               }
                                           }];
            }else {
                request = [httpClient requestWithMethod:method path:command parameters:parameters];
            }
            request.timeoutInterval = timeout;
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            sCurrentUploadingOperation = operation;
            if (shouldExecuteAsBackgroundTask) {
                [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
                    
                    sCurrentUploadingOperation = nil;
                    
                    [[DDUpload uploadFileLock] lock];
                    isUploadingFile = NO;
                    [[DDUpload uploadFileLock] unlock];
                }];
            }
            if (shouldPostProgressNotification) {
                [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                    //                    DDLog(@"%@ Sent %lld of %lld bytes progress %f", fileName, totalBytesWritten, totalBytesExpectedToWrite, progress);
                    NSDictionary *userInfo = @{DDUploadNotificationUserInfoKeyPlist: plistWithoutForm,
                                               DDUploadNotificationUserInfoKeyProgress: @(progress),
                                               };
                    [[NSNotificationCenter defaultCenter] postNotificationName:DDUploadNotificationNameUploadingProgress object:nil userInfo:userInfo];
                }];
            }
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                id jsonObj = DUJSONObjectWithData(responseObject);

                DDLog(@"DDUploadFilesInDirectory: upload file ok %@ %@", fileName, jsonObj);
                BOOL uploadSuccess = NO;
                if ([self isResultSuccess:jsonObj]) {
                    DDLog(@"result is ok, remove plist file %@", fileName);
                    uploadSuccess = YES;
                    [defaultManager removeItemAtPath:filePath error:NULL];
                    [self handleSuccessResult:jsonObj withOriginalPlist:plistWithoutForm];
                }
                
                sCurrentUploadingOperation = nil;
                
                [[self uploadFileLock] lock];
                isUploadingFile = NO;
                [[self uploadFileLock] unlock];
                
                DDUploadPostNotificationFileDidUpload(jsonObj, plistWithoutForm, uploadSuccess);
                sCurrentUploadingOperation = nil;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DDLog(@"DDUploadFilesInDirectory: upload file failed %@ %@", fileName, error);
                
                sCurrentUploadingOperation = nil;
                
                [[self uploadFileLock] lock];
                isUploadingFile = NO;
                [[self uploadFileLock] unlock];
                
                DDUploadPostNotificationFileDidUpload(@{}, plistWithoutForm, NO);
                
            }];
            [httpClient enqueueHTTPRequestOperation:operation];
        }
    }
}

#pragma mark - override

+ (NSString *)dirPathForUploading
{
    //////CLog(@"DDUpload dirPathForUploading");
    
    NSString *appDocumentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [appDocumentDir stringByAppendingPathComponent:@"upload"];
}

+ (BOOL)isResultSuccess:(id)obj
{
    //////CLog(@"DDUpload isResultSuccess");
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSNumber *resultObj = [obj objectForKey:@"result"];
//        NSInteger result = [resultObj integerValue];
//        return resultObj && (0 == result || 2 == result);
        return !!resultObj;
    }else {
        return NO;
    }
}

+ (void)handleSuccessResult:(id)result withOriginalPlist:(NSDictionary *)plistRootDic
{
   // ////CLog(@"DDUpload handleSuccessResult");
}

#pragma mark - public

+ (void)startUploadService {
    NSString *uploadDir = [self dirPathForUploading];
    
    //创建上传子目录
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    BOOL createDir = YES;
    BOOL isDir;
    BOOL fileExist = [defaultManager fileExistsAtPath:uploadDir isDirectory:&isDir];
    if (fileExist && isDir) {
        if (isDir) {
            ////CLog(@"uploadDir already exists %@", uploadDir);
            createDir = NO;
        }else {
            ////CLog(@"uploadDir is file, delete it then create dir %@", uploadDir);
            [defaultManager removeItemAtPath:uploadDir error:NULL];
        }
    }
    if (createDir) {
        ////CLog(@"create uploadDir %@", uploadDir);
        [defaultManager createDirectoryAtPath:uploadDir withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    static NSOperationQueue *uploadQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadQueue = [[NSOperationQueue alloc] init];
        uploadQueue.maxConcurrentOperationCount = 1;
        [uploadQueue addOperationWithBlock:^{
            [self uploadFilesInDirectory:uploadDir];
        }];
    });
}

+ (NSString *)uploadWithInfo:(NSDictionary *)info {
    ////CLog(@"DDUpload uploadWithInfo");
    
    [[self uploadDirLock] lock];
    
    NSString *dir = [self dirPathForUploading];
    NSString *plistFilePath = DDUploadGetNextFilePathInDirectory(dir);
    [info writeToFile:plistFilePath atomically:YES];
    
    [[self uploadDirLock] unlock];
    
    return plistFilePath;
}

+ (void)cancelUploading {
    [sCurrentUploadingOperation cancel];
}

+ (BOOL)removeUploadInfoFile:(NSString *)plistFilePath {
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    [[self uploadDirLock] lock];
    
    BOOL result = [defaultManager removeItemAtPath:plistFilePath error:NULL];
    
    [[self uploadDirLock] unlock];
    
    return result;
}

@end

