//
//  PicNewsModel.h
//  Sharing
//
//  Created by huangchengqi on 15/9/21.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicNewsModel : NSObject


#pragma mark ***********************轮播图片*******************
@property (nonatomic,copy) NSString * pic;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * url;

+ (instancetype)PicNewsModelWithDic:(NSDictionary *)dict;
@end
