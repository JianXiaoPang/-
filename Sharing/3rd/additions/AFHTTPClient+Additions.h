//
//  AFHTTPClient+Additions.h
//  musiring
//
//  Created by darkdong on 14-1-3.
//  Copyright (c) 2014年 paixiu. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AFHTTPClient (Additions)

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionOnFresh:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionOnFresh;
- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionOnCache:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionOnCache completionOnFresh:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionOnFresh;

@end
