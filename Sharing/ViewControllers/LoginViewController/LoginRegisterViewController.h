//
//  LoginRegisterViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "VerifyPhoneViewController.h"
#import "Toast+UIView.h"
#import "UMSocialSnsService.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocial.h"
#import "WXApi.h"
#import "VerifyPhoneViewController.h"
@interface LoginRegisterViewController : UIViewController <UMSocialUIDelegate>
{

    UIScrollView* bottomScrollView;
}
@end
