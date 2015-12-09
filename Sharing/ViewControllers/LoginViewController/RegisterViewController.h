//
//  RegisterViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"
#import "WebViewController.h"
#import "WebViewController.h"
@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{

    UIScrollView* bottomScrollView;
    float naviConHeight;
    UITextField* phoneTextField;
    UITextField* passwordTextField;
    UITextField* VerCodeTextfield;
    UITextField* againPasswordTextField;
    UIButton* codeButton;
    int secondsCountDown;
    NSTimer  *countDownTimer;
}

@end
