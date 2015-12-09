//
//  DDDownload.h
//  dd
//
//  Created by darkdong on 12-11-19.
//  Copyright (c) 2012年 PaiXiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDType.h"

@class AFHTTPRequestOperation;

@interface DDDownload : NSObject

@property NSString *directoryPath;
@property NSOperationQueue *operationQueue;
@property NSTimeInterval timeout;
@property NSURLRequestCachePolicy cachePolicy;
@property NSURLCacheStoragePolicy storagePolicy;
@property BOOL shouldResume;
@property BOOL shouldExecuteAsBackgroundTask;

+ (DDDownload *)sharedDownload;
- (NSString *)cacheFilePathForURL:(NSURL *)url;
- (AFHTTPRequestOperation *)downloadWithURL:(NSURL *)url progress:(DDBlockProgress)progress completion:(DDBlockObject)completion;
- (AFHTTPRequestOperation *)downloadWithURL:(NSURL *)url completion:(DDBlockObject)completion;
- (AFHTTPRequestOperation *)operationWithURL:(NSURL *)url;
- (void)cancelDownloadForURL:(NSURL *)url;
- (void)cancelAllDownloads;
//- (BOOL)isDownloadingURL:(NSURL *)url;

@end
