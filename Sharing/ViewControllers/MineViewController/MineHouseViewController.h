//
//  MineHouseViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/13.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineHouseReqeust.h"
#import "WebViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "EGORefreshTableHeaderView.h"
#import "AppDelegate.h"
#import "ShareTemplate.h"
#import "PhotoReviewViewController.h"
@interface MineHouseViewController : UIViewController<UMSocialDataDelegate,UMSocialUIDelegate,EGORefreshTableDelegate>
{
    UIScrollView* bottomScrollView;
    //背景view
    UIView* bgView1;
    
    UIView* bgView2;
    UIView* bgTitleView;
    NSDictionary* shareDict;
    //余额
    UILabel* balanceLabel;
    UILabel* couponsLabel;
    UILabel* earningsLabel;
    
    UIView* bgView3;
    UIView* bgView4;
    
    //头像
    UIImageView* headImageView;
    //绑定手机号
    UILabel* phoneLabel;
    FenXiangUserInfoModel* userModel;
    NSDictionary* subDict;
    
    UILabel* yueeLabel;
    UILabel* yhqLael;
    UILabel* ljsyLabel;
}
@end
