//
//  LoginRequest.h
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

//获取手机验证码
#define GET_PHONENUBVERIFYCODE_URL [NSString stringWithFormat:@"%@cgi-bin/asmx/smsservice.html",URL_DEFAULT]
//手机登录
#define REQUEST_PHONELOGIN_URL [NSString stringWithFormat:@"%@cgi-bin/login/sign.html",URL_DEFAULT]
//手机注册
#define REQUEST_PHONEREGISTER_URL [NSString stringWithFormat:@"%@cgi-bin/register/create.html",URL_DEFAULT]
//找回密码
#define REQUEST_FINDERMYPASSWORD_URL [NSString stringWithFormat:@"%@cgi-bin/recovery/create.html",URL_DEFAULT]
//第三方快速登录
#define REQUEST_THIRDPARTLOGIN_URL [NSString stringWithFormat:@"%@cgi-bin/loginindex/sign.html",URL_DEFAULT]
//第三方登录短信验证码接口
#define REQUEST_THIRDMESSAGEVERCODE_URL [NSString stringWithFormat:@"%@cgi-bin/loginindex/smsservice.html",URL_DEFAULT]

//绑定手机号
#define REQUEST_THIRDTHEBINDINGPHONENUMBER_URL [NSString stringWithFormat:@"%@cgi-bin/loginindex/register.html",URL_DEFAULT]

@interface LoginRequest : NSObject

-(void)getVerifyCodeWithPhoneNub:(NSString *)phoneNub;

-(void)registerWithUser:(FenXiangUserInfoModel *)userModel andVerifyCode:(NSString *)verifyCode;

-(void)loginWithUser:(FenXiangUserInfoModel *)userModel;

-(void)findMyPwd:(FenXiangUserInfoModel *)userModel andVerifyCode:(NSString *)verifyCode;

-(void)thirdPartLogin:(FenXiangUserInfoModel *)userModel thirdKey:(NSString *)thirdKey type:(NSString *)type;

-(void)thirdPartMessageVerCode:(NSString *)verifyCode;

-(void)thirdPartUserInfo:(FenXiangUserInfoModel *)userModel andVerifyCode:(NSString *)verifyCode signid:(NSString *)signid nickname:(NSString *)nickname sex:(NSString *)sex province:(NSString *)province city:(NSString *)city headimgurl:(NSString *)headimgurl;


@property (nonatomic, copy) void (^finishedBlock)(BOOL isSucceed , NSString * desp);

@property (nonatomic, copy) void (^finishedLoginBlock)(BOOL isSucceed , FenXiangUserInfoModel *userModel , NSString * desp);

@property (nonatomic, copy) void (^otherBlock)(BOOL isSucceed ,NSString *ident, NSString * desp);
@end
