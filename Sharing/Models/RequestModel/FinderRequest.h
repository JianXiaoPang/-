//
//  FinderRequest.h
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

//发现
#define REQUEST_FINDER_URL [NSString stringWithFormat:@"%@cgi-bin/dream/list.html",URL_DEFAULT]

@interface FinderRequest : NSObject

- (void)requestFinder:(NSString *)key meId:(NSString *)meId type:(NSString *)type limt:(NSString *)limt;


@property (nonatomic, copy) void (^finishedBlock)(BOOL isSucceed , NSString * desp);

@property (nonatomic, copy) void (^finishedLoginBlock)(BOOL isSucceed , FenXiangUserInfoModel *userModel , NSString * desp);

@property (nonatomic, copy) void (^otherBlock)(BOOL isSucceed ,NSString *ident, NSString * desp);
@end
