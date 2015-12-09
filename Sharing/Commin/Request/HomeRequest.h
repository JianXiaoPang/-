//
//  HomeRequest.h
//  Sharing
//
//  Created by huangchengqi on 15/9/21.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
typedef void (^finishBlock)(id jsonObj,NSError *error);
#define URL_DEFAULT @"http://api.jlxmt.com/"
@interface HomeRequest : NSObject


//首页分类
#define GET_NEWS_URL [NSString stringWithFormat:@"%@cgi-bin/menu/classify.html",URL_DEFAULT]

//新闻接口
#define GET_NEWSNums_URL [NSString stringWithFormat:@"%@cgi-bin/article/list.html",URL_DEFAULT]

//原创新闻  @"cgi-bin/original/list.html"
#define GET_OrginalNEWS_URL [NSString stringWithFormat:@"%@cgi-bin/original/list.html",URL_DEFAULT]

//原创分类
#define GET_OriginalNums_URL [NSString stringWithFormat:@"%@cgi-bin/original/classify.html",URL_DEFAULT]

#pragma mark - *********************************************普通新闻
/** 首页分类 */
-(void)getJsonForNewWithKey:(NSString *)KEY;

/** 没有数据获取新闻  */
-(void)getJsonForNEWS:(NSString *)KEY ClassID:(NSString *)Class RequestTapy:(NSString *)RequestTapy IsOriginal:(BOOL)isOriginal ArticleId:(NSString *)articleId;
/** 有数据后获取新闻 刷新新闻 */
-(void)UpJsonForNEWS:(NSString *)KEYs ClassID:(NSString *)Class RequestTapy:(NSString *)RequestTapy ArticleID:(NSString *)articleId;
#pragma mark - *********************************************原创新闻
/** 获取原创分类 */
-(void)getJsonForOriginalNews:(NSString *)IDKey;


@property (nonatomic, copy) void (^finishedBlock)(BOOL isSucceed , NSString * desp);

@end
