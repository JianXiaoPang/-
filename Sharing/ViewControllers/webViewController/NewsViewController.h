//
//  NewsViewController.h
//  Sharing
//
//  Created by huangchengqi on 15/9/28.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTemplate.h"
#import "ShareModel.h"
#import "UIColor+Hex.h"
#import "WXApi.h"
#import "ShareTo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LoginRegisterViewController.h"

@interface NewsViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contview;

@property (strong, nonatomic)UIWebView *myWebView;
@property (nonatomic,copy) NSString *firestUrl;
/** isPush==YES push 否则 present */
@property (nonatomic,assign)BOOL isPush;
@property (nonatomic,copy)NSString* isMirco;
@end
