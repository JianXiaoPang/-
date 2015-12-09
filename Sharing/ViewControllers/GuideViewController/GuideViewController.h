//
//  ViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/8.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRegisterViewController.h"
@class GuideViewController;

@protocol GuideViewDelegate <NSObject>

- (void)guideViewShowComplete:(GuideViewController *)guideViewController;

@end

@interface GuideViewController : UIViewController

@property (nonatomic , weak) id<GuideViewDelegate> delegate;

@end
