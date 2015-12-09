//
//  Sharequest.h
//  Sharing
//
//  Created by 磊 on 15/9/24.
//  Copyright © 2015年 简小胖 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "FenXiangUserInfoModel.h"
typedef void (^finishBlock)(id jsonObj,NSError *error);
#define URL_DEFAULTS @"http://api.ssql.com.cn/"

//发现
#define REQUEST_FINDER_URL [NSString stringWithFormat:@"%@cgi-bin/share/create.html",URL_DEFAULTS]
@interface Sharequest : NSObject
- (void)requestFinder:(NSString *)type;


@property (nonatomic, copy) void (^finishedBlock)(BOOL isSucceed , NSString * desp);

@property (nonatomic, copy) void (^finishedLoginBlock)(BOOL isSucceed , FenXiangUserInfoModel *userModel , NSString * desp);

@property (nonatomic, copy) void (^otherBlock)(BOOL isSucceed ,NSString *ident, NSString * desp);
@end
