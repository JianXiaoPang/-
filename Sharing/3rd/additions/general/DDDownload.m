//
//  DDDownload.m
//  dd
//
//  Created by darkdong on 12-11-19.
//  Copyright (c) 2012年 PaiXiu. All rights reserved.
//

#import "DDDownload.h"
#import "DDPreprocessMacro.h"
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"
#import "NSData+Additions.h"
#import "NSObject+Additions.h"

static NSString * const DDDownloadDefaultDirectoryName = @"DDDownload";

static NSString * const DDDownloadInfoKeyProgressBlock = @"DDDownloadInfoKeyProgressBlock";
static NSString * const DDDownloadInfoKeyProgressValue = @"DDDownloadInfoKeyProgressValue";
static NSString * const DDDownloadInfoKeyCompletionBlock = @"DDDownloadInfoKeyCompletionBlock";

static void AssociateOperationWithProgressAndCompletion(NSOperation *operation, DDBlockProgress progress, DDBlockObject completion)
{
    NSMutableDictionary *info = nil;
    if (operation.associatedObject) {
        info = [NSMutableDictionary dictionaryWithDictionary:operation.associatedObject];
    } else {
        info = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    
    if (progress) {
        [info setObject:progress forKey:DDDownloadInfoKeyProgressBlock];
    }
    if (completion) {
        [info setObject:completion forKey:DDDownloadInfoKeyCompletionBlock];
    }
    operation.associatedObject = info;
}

@implementation DDDownload

+ (DDDownload *)sharedDownload {
	static DDDownload *sharedDownload = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:DDDownloadDefaultDirectoryName];
        sharedDownload = [[DDDownload alloc] initWithDirectoryPath:dirPath];
    });
    return sharedDownload;
}

- (id)initWithDirectoryPath:(NSString *)dirPath {
    self = [super init];
    if (self) {
        self.directoryPath = [dirPath copy];
        self.operationQueue = [NSOperationQueue new];
        self.timeout = 300;
        self.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        self.storagePolicy = NSURLCacheStorageAllowedInMemoryOnly;
        self.shouldResume = YES;
        self.shouldExecuteAsBackgroundTask = YES;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
	return self;
}

- (id)init {
	return [self initWithDirectoryPath:nil];
}

#pragma mark - public

- (NSString *)cacheFilePathForURL:(NSURL *)url {
    NSString *urlString = url.absoluteString;
    NSString *extName = [urlString pathExtension];
    NSString *baseName = [[urlString dataUsingEncoding:NSUTF8StringEncoding] md5];
    NSString *fileName = [baseName stringByAppendingPathExtension:extName];
    return [self.directoryPath stringByAppendingPathComponent:fileName];
}

- (AFHTTPRequestOperation *)downloadWithURL:(NSURL *)url progress:(DDBlockProgress)progress completion:(DDBlockObject)completion {
    if (!url) {
        if (completion) {
            completion(nil);
        }
        return nil;
    }
    
    AFHTTPRequestOperation *operation = [self operationWithURL:url];
    if (operation) {
        //duplicated download
        AssociateOperationWithProgressAndCompletion(operation, progress, completion);
        return operation;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:self.cachePolicy timeoutInterval:self.timeout];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    if (self.shouldResume) {
        NSString *targetFilePath = [self cacheFilePathForURL:url];
        operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:targetFilePath shouldResume:YES];
    }else {
        operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    }
    
    AssociateOperationWithProgressAndCompletion(operation, progress, completion);
    NSDictionary *associatedInfo = operation.associatedObject;
    
    if (self.shouldResume) {
        [(AFDownloadRequestOperation *)operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
            float percent = (totalBytesExpectedToReadForFile > 0)? (float)totalBytesReadForFile / totalBytesExpectedToReadForFile: (float)totalBytesRead / totalBytesExpected;
            
            DDBlockProgress associatedProgress = associatedInfo[DDDownloadInfoKeyProgressBlock];
            if (associatedProgress) {
                associatedProgress(percent);
            }
        }];
    }else {
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float percent = (float)totalBytesRead / totalBytesExpectedToRead;
            DDBlockProgress associatedProgress = associatedInfo[DDDownloadInfoKeyProgressBlock];
            if (associatedProgress) {
                associatedProgress(percent);
            }
        }];
    }
    
    if (self.shouldExecuteAsBackgroundTask) {
        [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
            DDBlockObject associatedCompletion = associatedInfo[DDDownloadInfoKeyCompletionBlock];
            if (associatedCompletion) {
                associatedCompletion(nil);
            }
        }];
    }
    
    NSURLCacheStoragePolicy storagePolicy = self.storagePolicy;
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        DDLog(@"cachedResponse storagePolicy %lu", cachedResponse.storagePolicy);
        NSCachedURLResponse *response = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:storagePolicy];
        return response;
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DDLog(@"DDDownload ok %@", operation.request.URL);
        if ([responseObject isKindOfClass:[NSString class]]) {
            DDLog(@"responseObject is NSString %@", responseObject);
        }else if ([responseObject isKindOfClass:[NSData class]]) {
            DDLog(@"responseObject is NSData length %lu", (unsigned long)[responseObject length]);
        }
        DDBlockObject associatedCompletion = associatedInfo[DDDownloadInfoKeyCompletionBlock];
        if (associatedCompletion) {
            associatedCompletion(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLog(@"DDDownload failed %@ error %@", operation.request.URL, error);
        DDBlockObject associatedCompletion = associatedInfo[DDDownloadInfoKeyCompletionBlock];
        if (associatedCompletion) {
            associatedCompletion(nil);
        }
    }];
//    [operation setSuccessCallbackQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)downloadWithURL:(NSURL *)url completion:(DDBlockObject)completion {
    return [self downloadWithURL:url progress:NULL completion:completion];
}

- (AFHTTPRequestOperation *)operationWithURL:(NSURL *)url {
    for (AFHTTPRequestOperation *operation in [self.operationQueue operations]) {
        if ([operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            if ([url isEqual:operation.request.URL]) {
                return operation;
            }
        }
    }
    return nil;
}

- (void)cancelDownloadForURL:(NSURL *)url {
    NSOperation *operation = [self operationWithURL:url];
    [operation cancel];
}

- (void)cancelAllDownloads {
    for (AFHTTPRequestOperation *operation in [self.operationQueue operations]) {
        [operation cancel];
    }
}

//- (BOOL)isDownloadingURL:(NSURL *)url {
//    return !![self operationWithURL:url];
//}

@end
