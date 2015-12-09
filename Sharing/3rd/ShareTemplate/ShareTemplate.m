//
//  ShareTemplate.m
//  AH2House
//
//  Created by Ting on 14-8-13.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import "ShareTemplate.h"
#import "UMSocial.h"
#import "ShareModel.h"
#import "WebContentRequest.h"

@interface ShareTemplate ()<UMSocialUIDelegate>{
    
    ShareModel *shareReturn;
}
@end

@implementation ShareTemplate

-(void)actionWithShare:(UIViewController *)vc WithSinaModel:(ShareModel*)shareMode{
    
    shareReturn = shareMode;
    
    UMSocialUrlResource *imgResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareMode.sharePic];

    showVc=vc;
    if (!self.activityView) {
        
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:vc.view];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 3;
        //新浪微博
        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"share_weibo_normal"] handler:^(ButtonView *buttonView){
            [self.activityView hide];
            [UMSocialData defaultData].extConfig.sinaData.snsName = @"分饷";
            [UMSocialData defaultData].extConfig.sinaData.urlResource = imgResource;
            
            NSString *content = [NSString stringWithFormat:@"%@:%@",shareMode.shareContent,shareMode.shareUrl];
            
            //设置分享内容和回调对象
            [[UMSocialControllerService defaultControllerService] setShareText:content
                                                                    shareImage:nil
                                                              socialUIDelegate:self];
            
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(vc, [UMSocialControllerService defaultControllerService], YES);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabbar" object:nil];
        }];
        [self.activityView addButtonView:bv];
        
        //微信好友
        bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"share_weixin_normal"] handler:^(ButtonView *buttonView){
            //微信好友额外配置
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareMode.shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareMode.shareUrl;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabbar" object:nil];
            [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeNone;
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareMode.shareContent image:nil location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self returnShareDataWithSharePlatform:Wechat];
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        //
        //微信朋友圈
        bv = [[ButtonView alloc]initWithText:@"朋友圈" image:[UIImage imageNamed:@"share_friends_normal"] handler:^(ButtonView *buttonView){
            
            //微信朋友圈额外配置
            [UMSocialData defaultData].extConfig.wechatTimelineData.title=shareMode.shareTitle;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareMode.shareUrl;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabbar" object:nil];
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareMode.shareContent image:nil location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self returnShareDataWithSharePlatform:WechatSession];
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        //
        //QQ空间
        bv = [[ButtonView alloc]initWithText:@"QQ空间" image:[UIImage imageNamed:@"share_zone_normal"] handler:^(ButtonView *buttonView){
            //QQ空间额外配置
            [UMSocialData defaultData].extConfig.qzoneData.title=shareMode.shareTitle;
            [UMSocialData defaultData].extConfig.qzoneData.url= shareMode.shareUrl;
            [[UMSocialData defaultData].extConfig.qzoneData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabbar" object:nil];
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareMode.shareContent image:nil location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self returnShareDataWithSharePlatform:Qzone];
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
        //QQ空间
        bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"share_qq_normal"] handler:^(ButtonView *buttonView){
            //QQ空间额外配置
            [UMSocialData defaultData].extConfig.qqData.title=shareMode.shareTitle;
            [UMSocialData defaultData].extConfig.qqData.url= shareMode.shareUrl;
            [[UMSocialData defaultData].extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabbar" object:nil];
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareMode.shareContent image:nil location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self returnShareDataWithSharePlatform:QQ];
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
    }
    [self.activityView show];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [self returnShareDataWithSharePlatform:Webo];
    }
}

-(void)returnShareDataWithSharePlatform:(SharePlatform )sharePlatform{
    NSString* string = [NSString stringWithFormat:@"%@",[shareReturn.returnDic objectForKey:@"IsTrue"]];
    if([string intValue] == 1){
        WebContentRequest *request = [WebContentRequest new];
        [request returnShareWithShareModel:shareReturn andSharePlatform:sharePlatform];
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
            if(!isSucceed){
                ////CLog(@"分享回调失败 ---%@",tips);
            }
        }];
    }
}


@end
