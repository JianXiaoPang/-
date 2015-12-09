//
//  FenXiangUserInfoModel.h
//  fenxiang
//
//  Created by 磊 on 15/9/18.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import "FenXiangBaseModel.h"

@interface FenXiangUserInfoModel : FenXiangBaseModel<NSCoding>

@property (nonatomic,copy) NSString* userKey;//用户的唯一识别信息
@property (nonatomic,copy) NSString* userPhoneNumber;
@property (nonatomic,copy) NSString* userPassword;
@property (nonatomic,copy) NSString* userIsmd5;
@property (nonatomic,copy) NSString* userMark;
@property (nonatomic,copy) NSString* userIsThirdPartType;//第三方登录
@property (nonatomic,copy) NSString* showGuideVersion;
@end
