//
//  ShareTemplate.m
//  AH2House
//
//  Created by Ting on 14-8-13.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import "ShareTo.h"
#import "UMSocial.h"
#import "ShareModel.h"
#import "WebContentRequest.h"

@interface ShareTo ()<UMSocialUIDelegate>{
    
    ShareModel *shareReturn;
 
}
@end

@implementation ShareTo

-(void)actionShare:(UIViewController *)vc withSinaModel:(ShareModel*)shareMode andPlatformType:(PlatformType)platformType{
//     UMSocialUrlResource *imgResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareMode.sharePic];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareMode.sharePic]];
    UIImage *img = [UIImage imageWithData:data];
    if(platformType == ShareAppMessage){
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
        //分享
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareMode.shareContent image:img location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];

    }else if(platformType == ShareTimeline){
      
        //微信朋友圈额外配置
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
        //分享
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:img location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
               
            }
        }];
    }
}

@end
