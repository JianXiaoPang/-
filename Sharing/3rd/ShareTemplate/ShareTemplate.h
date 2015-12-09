//
//  ShareTemplate.h
//  AH2House
//
//  Created by Ting on 14-8-13.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYActivityView.h"
@class ShareModel;
@interface ShareTemplate : NSObject{

    UIViewController *showVc;
    
}

-(void)actionWithShare:(UIViewController *)vc WithSinaModel:(ShareModel*)shareMode;

@property (nonatomic, retain) HYActivityView *activityView;
@end
