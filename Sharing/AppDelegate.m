//
//  AppDelegate.m
//  Sharing
//
//  Created by 黄承琪 on 15/9/3.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "UMSocial.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MobClick.h"
#import "GuideViewController.h"
#import "ADViewController.h"
@interface AppDelegate ()<GuideViewDelegate,WXApiDelegate,ADViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    LoginRegisterViewController * mainView = [[LoginRegisterViewController alloc]init];
    
    self.viewController = [[UINavigationController alloc]initWithRootViewController:mainView];
    [self.viewController setNavigationBarHidden:YES animated:NO];
    self.isLoadWebViewString = @"N";
    self.isFinderReBOOL = YES;
    self.isMicroReBOOL = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }
    if (![userModel.showGuideVersion isEqualToString:version]) {
        userModel.showGuideVersion = [NSString stringWithFormat:@"%@",version];
        [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
        [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        GuideViewController* root = [[GuideViewController alloc] init];
        root.delegate=self;
        [self.viewController pushViewController:root animated:NO];
    }else{
        ADViewController* root = [[ADViewController alloc] init];
        root.delegate=self;
        [self.viewController pushViewController:root animated:NO];
    }
    self.window.rootViewController = self.viewController;
    
//    self.window.rootViewController = self.viewController;
    [self UMQuicklyLogin];
    if(iPhone4) {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"640X960"]];
    }else if(iPhone5) {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"640X1136"]];
    }else if(iPhone6) {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"750X1334"]];
    }else {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1242X2208"]];
    }
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    return YES;
}
- (void)guideViewShowComplete:(GuideViewController *)guideViewController{
    [self.viewController popToRootViewControllerAnimated:NO];
}

- (void)ADViewShowComplete{
    [self.viewController popToRootViewControllerAnimated:NO];
}
- (void)UMQuicklyLogin {
    //友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick startWithAppkey:@"5560a67567e58e487700292b" reportPolicy:BATCH channelId:nil];
    [MobClick setAppVersion:version];
    //友盟
    [UMSocialData setAppKey:@"5560a67567e58e487700292b"];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx39eb2bdd87f53411"
                            appSecret:@"8ffacc8cdb46d8be0c3462f136af00f2"
                                  url:[NSString stringWithFormat:@"%@",self.shareUrl]];
    // Sina
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"1104756145" appKey:@"aM19rzcuATRmYkUd" url:[NSString stringWithFormat:@"%@",self.shareUrl]];
    
// z   [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
}
#pragma mark - Alipay

- (BOOL)alipayQuickPayment:(NSURL *)url {
    
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
        // NSString *result = nil;
        if (9000 == resultCode) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(0)];
            // result = @"支付成功";
        } else if (8000 == resultCode) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(0)];
            // result = @"正在处理中";
        } else if (4000 == resultCode) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(1)];
            // result = @"订单支付失败";
        } else if (6001 == resultCode) {
            [GlobalFunction makeToast:@"您已取消支付" duration:1.0 HeightScale:0.5];
            
        } else if (6002 == resultCode) {
            [GlobalFunction makeToast:@"网络连接出错" duration:1.0 HeightScale:0.5];
        }
    }];
    return YES;
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        //        NSString *result = nil;
        switch (resp.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(0)];
                break;
            case WXErrCodeUserCancel:
                [GlobalFunction makeToast:@"您已取消支付" duration:1.0 HeightScale:0.5];
                break;
            case WXErrCodeSentFail:
                [GlobalFunction makeToast:@"发送失败" duration:1.0 HeightScale:0.5];
                break;
            default:
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(1)];
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation{
    if ([url.host isEqualToString:@"safepay"]) {
        return [self alipayQuickPayment:url];
    }
    //微信支付
    if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return [UMSocialSnsService handleOpenURL:url];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
