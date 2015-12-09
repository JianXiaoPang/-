//
//  NewsModel.m
//  Sharing
//
//  Created by huangchengqi on 15/9/23.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
    NewsModel *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
