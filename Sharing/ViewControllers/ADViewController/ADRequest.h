//
//  PAD.h
//  AH2House
//
//  Created by Ting on 14-8-28.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface ADRequest : BaseRequest

-(void)getADPic;
#define URL_DEFAULT @"http://api.jlxmt.com/"

//发现
#define REQUEST_ADVEN_URL [NSString stringWithFormat:@"%@cgi-bin/img/get.html",URL_DEFAULT]

@property (nonatomic, copy) void (^finishedBlock)(BOOL isSucceed ,NSString *ident, NSString * desp);

@end