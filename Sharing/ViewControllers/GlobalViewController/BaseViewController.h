//
//  BaseViewController.h
//  hlwzp
//
//  Created by Ting on 15/3/6.
//  Copyright (c) 2015年 Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController


@property (nonatomic, strong) MBProgressHUD *HUD;


#pragma mark - 等待框相关

- (id)getHUD;
- (void)showHUDSimple;
- (void)showHUDWithLabel:(NSString *)tips ;
- (void)showHUDWithDetailsLabel:(NSString *)tips andDetail:(NSString *)detailTips;
- (void)showHUDWithLabelDeterminate:(NSString *)tips;
- (void)showHUDWithLabelAnnularDeterminate:(NSString *)tips;
- (void)showHUDWithLabelDeterminateHorizontalBar;
- (void)showHUDWithCustomView:(UIView *)view andTips:(NSString *)tips;
- (void)showHUDInView:(UIView *)view andTips:(NSString *)tips;
- (void)setHUDProgress:(float)progress;
- (void)hideHUD;

@end
