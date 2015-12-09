//
//  WebContentRequest.h
//  AH2House
//
//  Created by Ting on 14-8-28.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
@class ShareModel;


//1：微信好友 2：朋友圈 3：QQ 4：QQ空间 5：微博

typedef NS_ENUM(NSUInteger, SharePlatform) {
    Wechat                 = 1,
    WechatSession          = 2,
    QQ                     = 3,
    Qzone                  = 4,
    Webo                   = 5
};

@interface WebContentRequest : BaseRequest

-(void)returnShareWithShareModel:(ShareModel *)shareModel andSharePlatform:(SharePlatform )sharePlatform;

@property (nonatomic, copy) void (^finishedBlock)(BOOL isSucceed , NSString * desp);



@property (nonatomic, copy) void (^otherBlock)(BOOL isSucceed ,NSString *ident, NSString * desp);

@end