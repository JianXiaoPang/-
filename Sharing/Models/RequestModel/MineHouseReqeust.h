//
//  MineHouseReqeust.h
//  fenxiang
//
//  Created by 磊 on 15/9/18.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "FenXiangUserInfoModel.h"
typedef void (^finishBlock)(id jsonObj,NSError *error);
#define URL_DEFAULT @"http://api.jlxmt.com/"

//我的窝
#define REQUEST_MINEHOUSE_URL [NSString stringWithFormat:@"%@cgi-bin/usercenter/index.html",URL_DEFAULT]
@interface MineHouseReqeust : NSObject

- (void)requestMineHouse:(NSString *)key;


@property (nonatomic, copy) void (^finishedBlock)(BOOL isSucceed , NSString * desp);

@property (nonatomic, copy) void (^finishedLoginBlock)(BOOL isSucceed , FenXiangUserInfoModel *userModel , NSString * desp);

@property (nonatomic, copy) void (^otherBlock)(BOOL isSucceed ,NSString *ident, NSString * desp);

@end
