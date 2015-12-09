//
//  ShareTemplate.h
//  AH2House
//
//  Created by Ting on 14-8-13.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, PlatformType) {
    ShareAppMessage     = 0,        //微信好友
    ShareTimeline       = 1         //朋友圈

};

@class ShareModel;
@interface ShareTo : NSObject{

}

-(void)actionShare:(UIViewController *)vc withSinaModel:(ShareModel*)shareMode andPlatformType:(PlatformType)platformType;


@end
