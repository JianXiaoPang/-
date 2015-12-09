//
//  PicNewsModel.m
//  Sharing
//
//  Created by huangchengqi on 15/9/21.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "PicNewsModel.h"

@implementation PicNewsModel
+ (instancetype)PicNewsModelWithDic:(NSDictionary *)dict
{
    PicNewsModel *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;

}
@end
