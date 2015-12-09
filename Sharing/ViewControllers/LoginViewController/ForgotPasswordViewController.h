//
//  ForgotPasswordViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/15.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
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
