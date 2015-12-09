//
//  RegisterViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "RegisterViewController.h"
#define encolor 0xfdce72
#define uencolor 0xcdcdcd
@interface RegisterViewController ()

@end

@implementation RegisterViewController
- (void)topTitle {
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    bgView.backgroundColor=[UIColor colorWithRed:248/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:bgView];
    
    //设置
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80,20,(self.view.width-80*2), 44)];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text = @"注册";
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
    // Do any additional setup after loading the view.
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,viewWidth , viewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    naviConHeight=self.navigationController.navigationBar.frame.size.height;
    self.navigationController.navigationBar.hidden = YES;
    [self topTitle];
//    naviConHeight=self.navigationController.navigationBar.frame.size.height;
    //背景滑动ScrollView
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+44, viewWidth, viewHeight-statusBarHeight-44)];
    if(iPhone4) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, 647*scaleHeight);
    }else if(iPhone5) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, 647*scaleHeight);
    }else if(iPhone6) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight);
    }else if(iPhone6P) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight);
    }else {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight);
    }
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
    [VerCodeTextfield resignFirstResponder];
    [againPasswordTextField resignFirstResponder];
    [self viewEndEdting];
}
- (void)doBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)LocalLoginRegister {
    //Logo
    UIImageView* logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_logginicon.png"]];
    logoImageView.frame = CGRectMake((viewWidth-logoImageView.image.size.width*scaleWidth)/2, 70*scaleHeight, logoImageView.image.size.width*scaleWidth,logoImageView.image.size.height*scaleHeight);
    [bottomScrollView addSubview:logoImageView];
    
    //手机号
    UIImageView* phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_phone.png"]];
    phoneImageView.frame = CGRectMake(50*scaleWidth, logoImageView.bottom+30*scaleHeight, phoneImageView.image.size.width, phoneImageView.image.size.height);
    [bottomScrollView addSubview:phoneImageView];
    
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(60*scaleWidth+phoneImageView.frame.size.width, logoImageView.bottom+30*scaleHeight, viewWidth-110*scaleWidth-phoneImageView.image.size.width, phoneImageView.frame.size.height)];
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    phoneTextField.placeholder = @"请输入手机号码";
    phoneTextField.textColor = [UIColor blackColor];
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.delegate = self;
    [bottomScrollView addSubview:phoneTextField];
    
    UIView* phoneView = [[UIView alloc]initWithFrame:CGRectMake(50*scaleWidth, phoneImageView.bottom+5*scaleHeight, viewWidth-100*scaleWidth, 1)];
    phoneView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:phoneView];
    
    //验证码
    UIImageView* codeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_toke.png"]];
    codeImageView.frame = CGRectMake(50*scaleWidth, phoneView.bottom+24*scaleHeight, codeImageView.image.size.width, codeImageView.image.size.height);
    [bottomScrollView addSubview:codeImageView];
    
    
    
    codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setFrame:CGRectMake(viewWidth-130*scaleWidth, phoneView.bottom+22*scaleHeight, 80, 25)];
    [codeButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:206/255.0 blue:114/255.0 alpha:1]];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [codeButton addTarget:self action:@selector(pressGetVerCode) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:codeButton];
    
    VerCodeTextfield = [[UITextField alloc]initWithFrame:CGRectMake(60*scaleWidth+codeImageView.frame.size.width, phoneView.bottom+24*scaleHeight, viewWidth-130*scaleWidth-codeImageView.image.size.width-codeButton.frame.size.width, codeImageView.frame.size.height)];
    VerCodeTextfield.backgroundColor = [UIColor whiteColor];
    VerCodeTextfield.font = [UIFont systemFontOfSize:15];
    VerCodeTextfield.placeholder = @"请输入验证码";
    VerCodeTextfield.textColor = [UIColor blackColor];
    VerCodeTextfield.delegate = self;
    [bottomScrollView addSubview:VerCodeTextfield];
    
    CALayer *codelaygender = codeButton.layer;
    [codelaygender setMasksToBounds:YES];
    [codelaygender setCornerRadius:3];
    
    UIView* codeView = [[UIView alloc]initWithFrame:CGRectMake(50*scaleWidth, codeImageView.bottom+5*scaleHeight, viewWidth-100*scaleWidth, 1)];
    codeView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:codeView];
    
    //密码
    UIImageView* passwordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_lock.png"]];
    passwordImageView.frame = CGRectMake(50*scaleWidth, codeView.bottom+24*scaleHeight, passwordImageView.image.size.width, passwordImageView.image.size.height);
    [bottomScrollView addSubview:passwordImageView];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(60*scaleWidth+passwordImageView.frame.size.width, codeView.bottom+24*scaleHeight, viewWidth-110*scaleWidth-passwordImageView.image.size.width, passwordImageView.frame.size.height)];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    [bottomScrollView addSubview:passwordTextField];
    
    UIView* passwordView = [[UIView alloc]initWithFrame:CGRectMake(50*scaleWidth, passwordImageView.bottom+5*scaleHeight, viewWidth-100*scaleWidth, 1)];
    passwordView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:passwordView];

    //再次输入密码
    UIImageView* againpasswordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_reset.png"]];
    againpasswordImageView.frame = CGRectMake(50*scaleWidth, passwordView.bottom+24*scaleHeight, againpasswordImageView.image.size.width, againpasswordImageView.image.size.height);
    [bottomScrollView addSubview:againpasswordImageView];
    
    againPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(60*scaleWidth+againpasswordImageView.frame.size.width, passwordView.bottom+24*scaleHeight, viewWidth-110*scaleWidth-againpasswordImageView.image.size.width, againpasswordImageView.frame.size.height)];
    againPasswordTextField.backgroundColor = [UIColor whiteColor];
    againPasswordTextField.font = [UIFont systemFontOfSize:15];
    againPasswordTextField.placeholder = @"请再次输入密码";
    againPasswordTextField.textColor = [UIColor blackColor];
    againPasswordTextField.delegate = self;
    againPasswordTextField.secureTextEntry = YES;
    [bottomScrollView addSubview:againPasswordTextField];
    
    UIView* againpasswordView = [[UIView alloc]initWithFrame:CGRectMake(50*scaleWidth, againpasswordImageView.bottom+5*scaleHeight, viewWidth-100*scaleWidth, 1)];
    againpasswordView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:againpasswordView];
    
    //登录
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(50*scaleWidth, againpasswordImageView.bottom+50*scaleHeight, (viewWidth-100*scaleWidth), 43)];
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
#pragma mark -- 获取验证码
- (void)pressGetVerCode {
    if(!phoneTextField.text.length>0){
        [GlobalFunction makeToast:@"请输入手机号" duration:1.0 HeightScale:0.5];
        return;
    }
    [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
    LoginRequest *request = [LoginRequest new];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
        [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
        if(isSucceed){
            [self beginDownTime];
            
        }else{
            [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
        }
    }];
    [request getVerifyCodeWithPhoneNub:phoneTextField.text];
}
- (void)beginDownTime {
    secondsCountDown=60;
    [self DownTimeHold:YES];
}
-(void)DownTimeHold:(BOOL)isHold{
    
    if(isHold)
    {
        [codeButton setBackgroundColor:[UIColor colorWithHex:uencolor]];
        [codeButton setEnabled:NO];
        //第一秒初始化
        [codeButton setTitle:[NSString stringWithFormat:@"重试(%d)",secondsCountDown] forState:UIControlStateDisabled];
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showDownTime) userInfo:nil repeats:YES];
    }else
    {
        [codeButton setBackgroundColor:[UIColor colorWithHex:encolor]];
        [codeButton setEnabled:YES];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
//检测验证码
-(void)showDownTime{
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        countDownTimer=nil;
        [self DownTimeHold:NO];
    }else {
        secondsCountDown--;
        [codeButton setTitle:[NSString stringWithFormat:@"重试(%d)",secondsCountDown] forState:UIControlStateDisabled];
    }
}
#pragma mark -- 登录
- (void)pressLoginEnterTheIndex {
    if(!phoneTextField.text.length>0){
        [GlobalFunction makeToast:@"请输入手机号" duration:1.0 HeightScale:0.5];
        return;
    }else if(phoneTextField.text.length<11){
        [GlobalFunction makeToast:@"请输入正确的手机号" duration:1.0 HeightScale:0.5];
        return;
    }else if (!VerCodeTextfield.text.length>0){
        [GlobalFunction makeToast:@"请输入验证码" duration:1.0 HeightScale:0.5];
        return;
    }else if (!passwordTextField.text.length>0){
        [GlobalFunction makeToast:@"请输入密码" duration:1.0 HeightScale:0.5];
        return;
    }else if (!againPasswordTextField.text.length>0){
        [GlobalFunction makeToast:@"请重复输入密码" duration:1.0 HeightScale:0.5];
        return;
    }else if (![againPasswordTextField.text isEqualToString:passwordTextField.text]){
        [GlobalFunction makeToast:@"两次输入的密码不一致,请重新输入" duration:1.0 HeightScale:0.5];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        
    }
//    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
//    FenXiangUserInfoModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults1 objectForKey:@"key"]]];
    
    userModel.userPhoneNumber = phoneTextField.text;
    userModel.userPassword = passwordTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
    [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
    LoginRequest *request = [LoginRequest new];
    [request setFinishedLoginBlock:^(BOOL isSucceed, FenXiangUserInfoModel *userModelS, NSString *tips) {
        [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
        if(isSucceed){
#pragma mark -- 进入主页面
            [[NSUserDefaults standardUserDefaults] setObject:@"YES"forKey:@"IsLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            RegisterViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            
            [self.navigationController pushViewController:vc1 animated:YES];
        }else{
            [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
        }
    }];
    [request registerWithUser:userModel andVerifyCode:VerCodeTextfield.text];
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
