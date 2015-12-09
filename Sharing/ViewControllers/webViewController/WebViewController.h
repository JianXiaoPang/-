//
//  WebViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/19.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareTemplate.h"
#import "ShareModel.h"
#import "UIColor+Hex.h"
#import "WXApi.h"
#import "ShareTo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LoginRegisterViewController.h"
@interface WebViewController : UIViewController<UIWebViewDelegate>
{
    float naviConHeight;
    UIWebView* myWebView;
    NSString *firestUrl;
    NSTimer * timeAD;
}
-(id)initWithURLStr:(NSString *)urlStr;
@end
