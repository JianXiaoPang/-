//
//  VerifyPhoneViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#define encolor 0xfdce72
#define uencolor 0xcdcdcd
@interface VerifyPhoneViewController ()

@end

@implementation VerifyPhoneViewController
- (void)topTitle {
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    bgView.backgroundColor=[UIColor colorWithRed:248/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:bgView];

    //设置
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80,20,(self.view.width-80*2), 44)];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text = @"手机绑定";
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
    [self topTitle];
    self.navigationItem.title = @"手机绑定";
    naviConHeight=self.navigationController.navigationBar.frame.size.height;
    self.navigationController.navigationBar.hidden = YES;
    //背景滑动ScrollView
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+44, viewWidth, viewHeight-statusBarHeight-44)];
    bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight);
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
    
    [self alertViewShow];
}
- (void)pressHiddenKeyboard {
    [phoneTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [VerCodeTextfield resignFirstResponder];
    [self viewEndEdting];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self viewEndEdting];
    return YES;
}
-(void)viewEndEdting{
    [bottomScrollView setContentOffset:CGPointZero animated:YES];
    [self.view endEditing:YES];
}
- (void)alertViewShow {
    shareBGButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBGButton setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [shareBGButton setBackgroundImage:[UIImage imageNamed:@"translatepic"] forState:UIControlStateNormal];
    [shareBGButton addTarget:self action:@selector(pressHiddenAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBGButton];
    shareBGButton.hidden = YES;
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(53*scaleWidth,(viewHeight-130*scaleHeight)/2, viewWidth-106*scaleWidth, 130*scaleHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [shareBGButton addSubview:bgView];
    
    UILabel* tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24*scaleHeight, bgView.frame.size.width, 18)];
    tipLabel.backgroundColor =[UIColor clearColor];
    tipLabel.text = @"提示";
    tipLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:tipLabel];
    
    UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tipLabel.bottom+12, bgView.frame.size.width, 14)];
    messageLabel.backgroundColor =[UIColor clearColor];
    messageLabel.text = @"此手机号已注册！";
    messageLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:messageLabel];
    
    UIView* lienView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-44*scaleHeight-1, bgView.frame.size.width, 1)];
    lienView.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:222/255.0 alpha:1];
    [bgView addSubview:lienView];
    
    NSArray* array = [NSArray arrayWithObjects:@"重新输入",@"直接登录", nil];
    for (int i=0;i<array.count;i++){
        NSString *buttonTitle =[array objectAtIndex:i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0+bgView.frame.size.width/2*i,bgView.frame.size.height-44*scaleHeight, bgView.frame.size.width/2, 44*scaleHeight)];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:251/255.0 green:162/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonWithPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        if(i==1){
            UIView* lienView1 = [[UIView alloc]initWithFrame:CGRectMake(0, lienView.bottom, 1, 44)];
            lienView1.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:222/255.0 alpha:1];
            [button addSubview:lienView1];
        }
        [bgView addSubview:button];
        
    }
    
    CALayer *laygender = bgView.layer;
    [laygender setMasksToBounds:YES];
    [laygender setCornerRadius:6];
}
- (void)buttonWithPressed:(UIButton *)button {
    if(button.tag == 0){
        shareBGButton.hidden = YES;
    }else if(button.tag == 1){
        shareBGButton.hidden = YES;
        LoginViewController* lVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:lVC animated:YES];
    }
}
- (void)pressHiddenAlertView {
    shareBGButton.hidden = YES;
}
- (void)doBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)LocalLoginRegister {
    //地区
    UILabel* regionLabel = [[UILabel alloc]initWithFrame:CGRectMake(12*scaleWidth, 22*scaleHeight, (viewWidth-24*scaleWidth)/2, 45)];
    regionLabel.backgroundColor = [UIColor clearColor];
    regionLabel.text = @"国家/地区";
    regionLabel.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    regionLabel.font = [UIFont systemFontOfSize:15];
    [bottomScrollView addSubview:regionLabel];
    
    //国家
    UIImageView* rarowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_rarow"]];
    rarowImageView.frame = CGRectMake(viewWidth-rarowImageView.image.size.width, 22*scaleHeight+(45-rarowImageView.image.size.height)/2, rarowImageView.image.size.width, rarowImageView.image.size.height);
    [bottomScrollView addSubview:rarowImageView];
    
    UILabel* countryLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth-rarowImageView.image.size.width-30, 22*scaleHeight, 30, 45)];
    countryLabel.backgroundColor = [UIColor clearColor];
    countryLabel.text = @"中国";
    countryLabel.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    countryLabel.textAlignment = NSTextAlignmentRight;
    countryLabel.font = [UIFont systemFontOfSize:15];
    [bottomScrollView addSubview:countryLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(12*scaleWidth, regionLabel.bottom, viewWidth-12*scaleWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:lineView];
    
    //手机号
    UIImageView* phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_phone"]];
    phoneImageView.frame = CGRectMake(12*scaleWidth, lineView.bottom+(45-phoneImageView.image.size.height)/2, phoneImageView.image.size.width, phoneImageView.image.size.height);
    [bottomScrollView addSubview:phoneImageView];
    
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(17*scaleWidth+phoneImageView.frame.size.width, lineView.bottom, viewWidth-17*scaleWidth-phoneImageView.image.size.width, 45)];
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    phoneTextField.placeholder = @"请输入手机号码";
    phoneTextField.textColor = [UIColor blackColor];
    phoneTextField.delegate = self;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [bottomScrollView addSubview:phoneTextField];
    
    UIView* phoneView = [[UIView alloc]initWithFrame:CGRectMake(12*scaleWidth, phoneTextField.bottom, viewWidth-12*scaleWidth, 1)];
    phoneView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:phoneView];
    
    //验证码
    UIImageView* codeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_toke.png"]];
    codeImageView.frame = CGRectMake(12*scaleWidth, phoneView.bottom+(45-codeImageView.image.size.height)/2, codeImageView.image.size.width, codeImageView.image.size.height);
    [bottomScrollView addSubview:codeImageView];
    
    codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setFrame:CGRectMake(viewWidth-12*scaleWidth-80, phoneView.bottom+12*scaleHeight, 80, 25)];
    [codeButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:206/255.0 blue:114/255.0 alpha:1]];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [codeButton addTarget:self action:@selector(pressGetVerCode) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:codeButton];
    
    VerCodeTextfield = [[UITextField alloc]initWithFrame:CGRectMake(17*scaleWidth+codeImageView.frame.size.width, phoneView.bottom, viewWidth-49*scaleWidth-codeImageView.image.size.width-codeButton.frame.size.width, 45)];
    VerCodeTextfield.backgroundColor = [UIColor whiteColor];
    VerCodeTextfield.font = [UIFont systemFontOfSize:15];
    VerCodeTextfield.placeholder = @"请输入验证码";
    VerCodeTextfield.textColor = [UIColor blackColor];
    VerCodeTextfield.delegate = self;
    [bottomScrollView addSubview:VerCodeTextfield];
    
    CALayer *codelaygender = codeButton.layer;
    [codelaygender setMasksToBounds:YES];
    [codelaygender setCornerRadius:3];
    
    UIView* codeView = [[UIView alloc]initWithFrame:CGRectMake(12*scaleWidth, VerCodeTextfield.bottom, viewWidth-12*scaleWidth, 1)];
    codeView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:codeView];
    
    //密码
    UIImageView* passwordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_lock.png"]];
    passwordImageView.frame = CGRectMake(12*scaleWidth, codeView.bottom+(45-passwordImageView.image.size.height)/2, passwordImageView.image.size.width, passwordImageView.image.size.height);
    [bottomScrollView addSubview:passwordImageView];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(17*scaleWidth+passwordImageView.frame.size.width, codeView.bottom, viewWidth-17*scaleWidth-passwordImageView.image.size.width, 45)];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    [bottomScrollView addSubview:passwordTextField];
    
    UIView* passwordView = [[UIView alloc]initWithFrame:CGRectMake(12*scaleWidth, passwordTextField.bottom, viewWidth-12*scaleWidth, 1)];
    passwordView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:234/255.0 alpha:1];
    [bottomScrollView addSubview:passwordView];
    
    //登录
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(12*scaleWidth, passwordView.bottom+30*scaleHeight, (viewWidth-24*scaleHeight), 43)];
    [loginButton setBackgroundColor:[UIColor colorWithRed:251/255.0 green:162/255.0 blue:0/255.0 alpha:1]];
    [loginButton setTitle:@"提交" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginButton addTarget:self action:@selector(pressLoginEnterTheIndex) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:loginButton];
    
    CALayer *laygender = loginButton.layer;
    [laygender setMasksToBounds:YES];
    [laygender setCornerRadius:3];
}
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
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        
    }
    userModel.userPhoneNumber = phoneTextField.text;
    userModel.userPassword = passwordTextField.text;
    userModel.userIsThirdPartType = [self.dataDict objectForKey:@"type"];
    [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
    [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
    LoginRequest *request = [LoginRequest new];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips){
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
    NSString* gender = @"";
    if([[self.dataDict objectForKey:@"gender"] isEqualToString:@"1"]){
        gender = @"男";
    }else if([[self.dataDict objectForKey:@"gender"] isEqualToString:@"0"]){
        gender = @"女";
    }
    [request thirdPartUserInfo:userModel andVerifyCode:VerCodeTextfield.text signid:[self.dataDict objectForKey:@"partId"] nickname:[self.dataDict objectForKey:@"accountName"] sex:gender province:@"" city:@"" headimgurl:[self.dataDict objectForKey:@"avatarUrl"]];
}
//- (void)thirdLogin {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
//    if (userModel == nil) {
//        userModel = [[FenXiangUserInfoModel alloc]init];
//    }else{
//        
//    }
//    userModel.userPhoneNumber = phoneTextField.text;
//    userModel.userPassword = passwordTextField.text;
//    [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
//    [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
//    LoginRequest *request = [LoginRequest new];
//    [request setFinishedLoginBlock:^(BOOL isSucceed, FenXiangUserInfoModel *userModelS, NSString *tips) {
//        [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
//        if(isSucceed){
//#pragma mark -- 进入主页面
//        }else{
//            [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
//        }
//    }];
//    [request thirdPartLogin:userModel thirdKey:[self.dataDict objectForKey:@"partId"] type:[self.dataDict objectForKey:@"type"]];
//}
#pragma mark -- 获取验证码
- (void)pressGetVerCode {
    [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
    LoginRequest *request = [LoginRequest new];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
        [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
        if(isSucceed){
            [self beginDownTime];
            
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            if([[dic objectForKey:@"errcode"] intValue] == 2){
                [phoneTextField resignFirstResponder];
                [VerCodeTextfield resignFirstResponder];
                [passwordTextField resignFirstResponder];
                shareBGButton.hidden = NO;
            }else {
                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
            }
        }
    }];
    [request thirdPartMessageVerCode:phoneTextField.text];
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
