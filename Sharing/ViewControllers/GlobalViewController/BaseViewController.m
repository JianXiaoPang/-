//
//  BaseViewController.m
//  hlwzp
//
//  Created by Ting on 15/3/6.
//  Copyright (c) 2015年 Ting. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController (){

    
}

@property (nonatomic, assign) BOOL canResponseToUIScreenEdgePanGesture;

@end

@implementation BaseViewController


- (void)dealloc {
    ////CLog(@"dealloc %@", [self getCurrentName]);
    ////CLog(@"\n");
}

//获取当前类的类名
- (NSString *)getCurrentName {
    return [NSString stringWithFormat:@"%@", [self class]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //返回按钮
//    BackButton *btnBack=[[BackButton alloc] initBackButton];
//    btnBack.delegate = self;
//    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
//    [GlobalFunction addLeftBarButtonItem:self item:itemBack];
    
    //self.navigationItem.titleView = self.lblFortitle;
   //self.view.backgroundColor =[UIColor colorWithHex:0xf0eff5];
    
    // Do any additional setup after loading the view.
}

//-(UILabel *)lblFortitle{
//    if(!lblFortitle){
//        lblFortitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
//        lblFortitle.backgroundColor = [UIColor clearColor];
//        lblFortitle.textColor = [UIColor whiteColor];
//        lblFortitle.font = [UIFont fontWithName:@"HelveticaNeue-light" size:18.0];
//        lblFortitle.textAlignment = NSTextAlignmentCenter;
//
//    }
//    return lblFortitle;
//}

#pragma mark -
#pragma mark 等待框相关

-(id)getHUD{

    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    _HUD.removeFromSuperViewOnHide = YES;
    return _HUD;

}

- (void)showHUDSimple {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD show:YES];
}

- (void)showHUDWithLabel:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDWithDetailsLabel:(NSString *)tips andDetail:(NSString *)detailTips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [self.view  addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    _HUD.detailsLabelText = detailTips;
    _HUD.square = YES;
    [_HUD show:YES];
}

- (void)showHUDWithLabelDeterminate:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [self.view addSubview:_HUD];
    _HUD.mode = MBProgressHUDModeDeterminate;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDWithLabelAnnularDeterminate:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    _HUD.mode = MBProgressHUDModeAnnularDeterminate;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDWithLabelDeterminateHorizontalBar {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    _HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD show:YES];
}

- (void)showHUDWithCustomView:(UIView *)view andTips:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    _HUD.customView = view;
    //[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDInView:(UIView *)view andTips:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:view.window ? view.window : view];
    
    [view addSubview:_HUD];
    
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)setHUDProgress:(float)progress {
    if (_HUD) {
        _HUD.progress = progress;
    }
}

- (void)hideHUD {
    [_HUD hide:YES];
    _HUD = nil;
}

#pragma mark - BackButtonDelegate

- (void)actionWithBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
