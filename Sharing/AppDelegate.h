//
//  AppDelegate.h
//  Sharing
//
//  Created by 黄承琪 on 15/9/3.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideViewController.h"
#import "LoginRegisterViewController.h"
#import "MineHouseViewController.h"
#import "FinderViewController.h"
#import "MicroMallViewController.h"
@class LoginRegisterViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) UINavigationController* viewController;
@property (nonatomic,copy) NSString* shareUrl;//分享地址
@property (nonatomic,copy) NSString* isLoadWebViewString;
@property (nonatomic) BOOL isFinderReBOOL;
@property (nonatomic) BOOL isMicroReBOOL;
@end

