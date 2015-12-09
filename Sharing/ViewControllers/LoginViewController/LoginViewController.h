//
//  LoginViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"
#import "ForgotPasswordViewController.h"
#import "MicroMallViewController.h"
#import "FinderViewController.h"
#import "MineHouseViewController.h"
@interface LoginViewController : UIViewController <UITextFieldDelegate>
{

    UIScrollView* bottomScrollView;
    float naviConHeight;
    UITextField* phoneTextField;
    UITextField* passwordTextField;
}
@end
