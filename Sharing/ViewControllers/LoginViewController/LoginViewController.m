//
//  LoginViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated {
}
- (void)topTitle {
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    bgView.backgroundColor=[UIColor colorWithRed:248/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:bgView];
    
    //设置
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80,20,(self.view.width-80*2), 44)];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text = @"登录";
    titleLabel.textColor=[UIColor colorWithRed:(96 / 255.0) green:(96 / 255.0) blue:(96 / 255.0) alpha:1];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"all_lefe"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63, viewWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:(212 / 255.0) green:(212 / 255.0) blue:(212 / 255.0) alpha:1];
    [bgView addSubview:lineView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
//     Do any additional setup after loading the view.
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,viewWidth , viewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [self topTitle];
    naviConHeight=self.navigationController.navigationBar.frame.size.height;
    self.navigationController.navigationBar.hidden = YES;
    //背景滑动ScrollView
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+44, viewWidth, viewHeight-statusBarHeight-44)];
    bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight-naviConHeight);
    bottomScrollView.backgroundColor = [UIColor whiteColor];
    bottomScrollView.userInteractionEnabled = YES;
    [self.view addSubview:bottomScrollView];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setFrame:CGRectMake(0, 0, bottomScrollView.frame.size.width, bottomScrollView.contentSize.height)];
    [button addTarget:self action:@selector(pressHiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:button];
    //本地注册登录
    [self LocalLoginRegister];
}
- (void)pressHiddenKeyboard {
    [phoneTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self viewEndEdting];
}
- (void)doBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)LocalLoginRegister {
    //Logo
    UIImageView* logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_logginicon.png"]];
    logoImageView.frame = CGRectMake((viewWidth-logoImageView.image.size.width*scaleWidth)/2, 90*scaleHeight, logoImageView.image.size.width*scaleWidth, logoImageView.image.size.height*scaleHeight);
    [bottomScrollView addSubview:logoImageView];
    
    //手机号
    UIImageView* phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_phone.png"]];
    phoneImageView.frame = CGRectMake(50*scaleWidth, logoImageView.bottom+35*scaleHeight, phoneImageView.image.size.width, phoneImageView.image.size.height);
    [bottomScrollView addSubview:phoneImageView];
    
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(60*scaleWidth+phoneImageView.frame.size.width, logoImageView.bottom+35*scaleHeight, viewWidth-110*scaleWidth-phoneImageView.image.size.width, phoneImageView.frame.size.height)];
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    phoneTextField.placeholder = @"请输入手机号码";
    phoneTextField.textColor = [UIColor blackColor];
    phoneTextField.delegate = self;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bottomScrollView addSubview:phoneTextField];
    
    UIView* phoneView = [[UIView alloc]initWithFrame:CGRectMake(50*scaleWidth, phoneTextField.bottom+2*scaleHeight, viewWidth-100*scaleWidth, 1)];
    phoneView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:phoneView];
    
    //密码
    UIImageView* passwordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_lock.png"]];
    passwordImageView.frame = CGRectMake(50*scaleWidth, phoneView.bottom+24*scaleHeight, passwordImageView.image.size.width, passwordImageView.image.size.height);
    [bottomScrollView addSubview:passwordImageView];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(60*scaleWidth+passwordImageView.frame.size.width, phoneView.bottom+24*scaleHeight, viewWidth-110*scaleWidth-passwordImageView.image.size.width, passwordImageView.frame.size.height)];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    [bottomScrollView addSubview:passwordTextField];
    
    UIView* passwordView = [[UIView alloc]initWithFrame:CGRectMake(50*scaleWidth, passwordTextField.bottom+2*scaleHeight, viewWidth-100*scaleWidth, 1)];
    passwordView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:passwordView];
    
    //忘记密码
    UIButton* forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPasswordButton setBackgroundColor:[UIColor clearColor]];
    [forgotPasswordButton setFrame:CGRectMake(viewWidth-100*scaleWidth, passwordView.bottom+9*scaleHeight, 60, 15)];
    [forgotPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1] forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(pressForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    forgotPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomScrollView addSubview:forgotPasswordButton];
    
    //登录
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(50*scaleWidth, passwordView.bottom+54*scaleHeight, (viewWidth-100*scaleWidth), 43)];
    [loginButton setBackgroundColor:[UIColor colorWithRed:251/255.0 green:162/255.0 blue:0/255.0 alpha:1]];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginButton addTarget:self action:@selector(pressLoginEnterTheIndex) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:loginButton];
    
    CALayer *laygender = loginButton.layer;
    [laygender setMasksToBounds:YES];
    [laygender setCornerRadius:3];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:bottomScrollView];
    CGPoint offset = bottomScrollView.contentOffset;
    offset.y = (point.y-50);
    [bottomScrollView setContentOffset:offset animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self viewEndEdting];
    return YES;
}
-(void)viewEndEdting{
    [bottomScrollView setContentOffset:CGPointZero animated:YES];
    [self.view endEditing:YES];
}
#pragma mark -- 忘记密码
- (void)pressForgotPassword {
    ForgotPasswordViewController* fpVC = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:fpVC animated:YES];
}

#pragma mark -- 进入首页
- (void)pressLoginEnterTheIndex {
    if(!phoneTextField.text.length>0){
        [GlobalFunction makeToast:@"请输入手机号" duration:1.0 HeightScale:0.5];
        return;
    }else if(phoneTextField.text.length<11){
        [GlobalFunction makeToast:@"请输入正确的手机号" duration:1.0 HeightScale:0.5];
        return;
    }else if (!passwordTextField.text.length>0){
        [GlobalFunction makeToast:@"请输入密码" duration:1.0 HeightScale:0.5];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        
    }
    userModel.userPhoneNumber = phoneTextField.text;
    userModel.userPassword = passwordTextField.text;
    userModel.userIsmd5 = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
    [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginRequest *request = [LoginRequest new];
    [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
        [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
        if(isSucceed){
#pragma mark -- 进入主页面
            [[NSUserDefaults standardUserDefaults] setObject:@"YES"forKey:@"IsLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LoginViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            [self.navigationController pushViewController:vc1 animated:YES];
            
        }else{
            [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
        }
    }];
    [request loginWithUser:userModel];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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
