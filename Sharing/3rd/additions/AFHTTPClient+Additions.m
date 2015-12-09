//
//  AFHTTPClient+Additions.m
//  musiring
//
//  Created by darkdong on 14-1-3.
//  Copyright (c) 2014年 paixiu. All rights reserved.
//

#import "AFHTTPClient+Additions.h"

@implementation AFHTTPClient (Additions)

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionOnFresh:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionOnFresh {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionOnFresh) {
            completionOnFresh(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionOnFresh) {
            completionOnFresh(operation, nil);
        }
    }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionOnCache:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionOnCache completionOnFresh:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionOnFresh {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    request.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
    AFHTTPRequestOperation *operation1 = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionOnCache) {
            completionOnCache(operation, responseObject);
        }
        [self getPath:path parameters:parameters completionOnFresh:completionOnFresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionOnCache) {
            completionOnCache(operation, nil);
        }
        [self getPath:path parameters:parameters completionOnFresh:completionOnFresh];
    }];
    [self enqueueHTTPRequestOperation:operation1];
}

@end
