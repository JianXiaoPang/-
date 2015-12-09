//
//  NewsModel.h
//  Sharing
//
//  Created by huangchengqi on 15/9/23.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject


#pragma mark ***********************新闻*******************
/** 参与数 */
@property (nonatomic,copy) NSString * hits;
/** 文章id */
@property (nonatomic,copy) NSString * id;
/** 文章简介 */
@property (nonatomic,copy) NSString * info;
/** 收藏数 */
@property (nonatomic,copy) NSString * love;
/** 文章标题 */
@property (nonatomic,copy) NSString * name;
/** 图片 */
@property (nonatomic,strong) NSArray * pics;
/** 显示类型
 0：左图右文
 1：三张图展示
 2：一张大图展示
 */
@property (nonatomic,assign) NSInteger  type;
/** 文章链接地址 */
@property (nonatomic,copy) NSString * url;


+ (instancetype)newsModelWithDict:(NSDictionary *)dict;


@end
