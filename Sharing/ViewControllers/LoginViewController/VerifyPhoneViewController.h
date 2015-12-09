//
//  VerifyPhoneViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"
#import "FDAlertView.h"
#import "LoginViewController.h"
@interface VerifyPhoneViewController : UIViewController
<UITextFieldDelegate,FDAlertViewDelegate>
{

    UIScrollView* bottomScrollView;
    float naviConHeight;
    UITextField* phoneTextField;
    UITextField* passwordTextField;
    UITextField* VerCodeTextfield;
    UIButton* codeButton;
    int secondsCountDown;
    NSTimer  *countDownTimer;
    UIButton* shareBGButton;
}
@property (nonatomic,copy) NSDictionary* dataDict;
@end
