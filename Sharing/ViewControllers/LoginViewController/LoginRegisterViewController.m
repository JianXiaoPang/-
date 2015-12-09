//
//  LoginRegisterViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/9.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "RegisterViewController.h"
@interface LoginRegisterViewController ()

@end

@implementation LoginRegisterViewController
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDlg.isLoadWebViewString = @"N";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,viewWidth , viewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //背景滑动ScrollView
    NSLog(@"%f",scaleWidth);
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight, viewWidth, viewHeight-statusBarHeight)];
    bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight);
    bottomScrollView.userInteractionEnabled = YES;
    bottomScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomScrollView];
    //本地注册登录
    [self LocalLoginRegister];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        if(userModel.userKey.length!=0){
            LoginRequest *request = [LoginRequest new];
            [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
            [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
                [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
                if(isSucceed){
#pragma mark -- 进入主页面
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES"forKey:@"IsLogin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    RegisterViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                    vc1.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc1 animated:YES];
                }else{
                    [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
                }
            }];
            [request loginWithUser:userModel];
        }
    }
}
- (void)LocalLoginRegister {
    //Logo
    UIImageView* logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_logginicon.png"]];
    logoImageView.frame = CGRectMake((viewWidth-logoImageView.image.size.width*scaleWidth)/2, 75*scaleHeight, logoImageView.image.size.width*scaleWidth, logoImageView.image.size.height*scaleHeight);
    [bottomScrollView addSubview:logoImageView];
    
    //登录按钮
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(50*scaleWidth, logoImageView.bottom+55*scaleHeight, (viewWidth-100*scaleWidth), 43)];
    [loginButton setBackgroundColor:[UIColor colorWithRed:251/255.0 green:162/255.0 blue:0/255.0 alpha:1]];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginButton addTarget:self action:@selector(pressLoginView) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:loginButton];
    
    CALayer *laygender = loginButton.layer;
    [laygender setMasksToBounds:YES];
    [laygender setCornerRadius:3];
    //注册按钮
    UIView* regiView = [[UIView alloc]initWithFrame:CGRectMake(50*scaleWidth,loginButton.bottom+39*scaleHeight, (viewWidth-100*scaleWidth), 43)];
    regiView.backgroundColor = [UIColor colorWithRed:251/255.0 green:162/255.0 blue:0/255.0 alpha:1];
    [bottomScrollView addSubview:regiView];
    
    CALayer *laygenderRe = regiView.layer;
    [laygenderRe setMasksToBounds:YES];
    [laygenderRe setCornerRadius:3];
    
    UIButton* registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(1, 1, (viewWidth-100*scaleWidth)-2, 41)];
    [registerButton setBackgroundColor:[UIColor whiteColor]];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithRed:251/255.0 green:162/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [registerButton addTarget:self action:@selector(pressRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [regiView addSubview:registerButton];
    
    CALayer *laygenderReg = registerButton.layer;
    [laygenderReg setMasksToBounds:YES];
    [laygenderReg setCornerRadius:3];
    
    //其他登录方式
    UIImageView* elseLoginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_hline.png"]];
    elseLoginImageView.frame = CGRectMake((viewWidth-elseLoginImageView.image.size.width)/2, regiView.bottom+58*scaleHeight, elseLoginImageView.image.size.width, elseLoginImageView.image.size.height);
    [bottomScrollView addSubview:elseLoginImageView];
    
    UILabel* elseLoginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, regiView.bottom+51*scaleHeight, viewWidth, 12)];
    elseLoginLabel.backgroundColor = [UIColor clearColor];
    elseLoginLabel.text = @"其他登录方式";
    elseLoginLabel.textAlignment = NSTextAlignmentCenter;
    elseLoginLabel.textColor = [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1];
    elseLoginLabel.font = [UIFont systemFontOfSize:12];
    [bottomScrollView addSubview:elseLoginLabel];
    
    //快速登录
    NSArray* imageArray = [NSArray arrayWithObjects:@"register_wxicon.png",@"register_xlicon.png",@"register_qqicon.png",nil];
    UIImage* image = [UIImage imageNamed:@"register_wxicon.png"];
    for(int i=0;i<imageArray.count;i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:i]]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake((viewWidth-image.size.width*3-32*2)/2+(image.size.width+32)*i,elseLoginLabel.bottom+30*scaleHeight, image.size.width, image.size.height)];
        [button addTarget:self action:@selector(pressElseLoginRegisterItem:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [bottomScrollView addSubview:button];
    }
}
- (void)pressLoginView {
    LoginViewController* loVC = [[LoginViewController alloc]init];
//    loVC.tabBarItem.title = @"手机登录";
    [self.navigationController pushViewController:loVC animated:YES];
}

- (void)pressRegisterView {
    RegisterViewController* loVC = [[RegisterViewController alloc]init];
//    loVC.tabBarItem.title = @"手机注册";
    [self.navigationController pushViewController:loVC animated:YES];
}

- (void)pressElseLoginRegisterItem:(UIButton *)button {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDlg.isLoadWebViewString = @"N";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        
    }
    if(button.tag == 0){
        if([WXApi isWXAppInstalled]) {
            [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[NSString stringWithFormat:@"wxsession"]];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                //获取微博用户名、uid、token等
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccounts = [[UMSocialAccountManager socialAccountDictionary] valueForKey:[NSString stringWithFormat:@"wxtimeline"]];
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:[NSString stringWithFormat:@"wxsession"]];
                    NSLog(@"%@",[UMSocialAccountManager socialAccountDictionary]);
                    NSDictionary * sourceDic = @{@"source": @"微信", @"accountName":snsAccount.userName, @"gender":@"", @"avatarUrl":snsAccount.iconURL,@"partId":snsAccount.usid,@"type":@"1"};
                    LoginRequest *request = [LoginRequest new];
                    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips){
                        [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
                        if(isSucceed){
#pragma mark -- 进入主页面
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                            NSString* strPhone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
                            NSString* strPass = [NSString stringWithFormat:@"%@",[dic objectForKey:@"keypwd"]];
                            NSString* stMd5 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ismd5"]];
                            
                            if([strPhone length]!=0 &&[strPass length]!=0 && [stMd5 length]!=0){
                                userModel.userPhoneNumber = [dic objectForKey:@"telephone"];
                                userModel.userPassword = [dic objectForKey:@"keypwd"];
                                userModel.userIsmd5 = [dic objectForKey:@"ismd5"];
                                userModel.userKey = [dic objectForKey:@"key"];
                                [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
                                [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
                                [[NSUserDefaults standardUserDefaults] synchronize];
#pragma mark -- 进入主页面
                                [[NSUserDefaults standardUserDefaults] setObject:@"YES"forKey:@"IsLogin"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                RegisterViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                                 vc1.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:vc1 animated:YES];
                            }else {
                                VerifyPhoneViewController* vc = [[VerifyPhoneViewController alloc]init];
                                vc.dataDict = sourceDic;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }else{
                            [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
                        }
                    }];
                    [request thirdPartLogin:userModel thirdKey:snsAccount.usid type:@"1"];
                    
                }else {
                    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"微信登录失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                    [alertView show];
                }
            });
        }else {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未安装微信,不能使用微信进行快速登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
        }
        
    }else if(button.tag == 1){
        NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeSina];
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                if ([platformName isEqualToString:UMShareToSina]) {
                    [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                        NSDictionary * sourceDic = @{@"source": @"微博",@"partId":[accountResponse.data objectForKey:@"uid"],@"type":@"3",@"accountName":[[[accountResponse.data objectForKey:@"accounts"] objectForKey:@"sina"] objectForKey:@"username"],@"gender":[[[accountResponse.data objectForKey:@"accounts"] objectForKey:@"sina"] objectForKey:@"gender"],@"avatarUrl":[[[accountResponse.data objectForKey:@"accounts"] objectForKey:@"sina"] objectForKey:@"icon"]};
                        LoginRequest *request = [LoginRequest new];
                        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips){
                            [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
                            if(isSucceed){
#pragma mark -- 进入主页面
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                                if([[dic objectForKey:@"telephone"] length]!=0 &&[[dic objectForKey:@"keypwd"] length]!=0 && [[dic objectForKey:@"ismd5"] length]!=0){
                                    userModel.userPhoneNumber = [dic objectForKey:@"telephone"];
                                    userModel.userPassword = [dic objectForKey:@"keypwd"];
                                    userModel.userIsmd5 = [dic objectForKey:@"ismd5"];
                                    userModel.userKey = [dic objectForKey:@"key"];
                                    [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
                                    [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
#pragma mark -- 进入主页面
                                    [[NSUserDefaults standardUserDefaults] setObject:@"YES"forKey:@"IsLogin"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    RegisterViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                                    [self.navigationController pushViewController:vc1 animated:YES];
                                }else {
                                    VerifyPhoneViewController* vc = [[VerifyPhoneViewController alloc]init];
                                    vc.dataDict = sourceDic;
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }else{
                                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
                            }
                        }];
                        [request thirdPartLogin:userModel thirdKey:[accountResponse.data objectForKey:@"uid"] type:@"3"];
                    }];
                }
            }else {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"微博快速登录失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alertView show];
            }
        });

    }else if(button.tag == 2){
        if([TencentOAuth iphoneQQInstalled]){
            [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            snsPlatform.haveWebViewAuth=YES;
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    if ([UMShareToQQ isEqualToString:@"qq"]) {
                        [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                            NSDictionary * sourceDic = @{@"source": @"QQ", @"accountName":[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"username"], @"gender":[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"gender"], @"avatarUrl":[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"icon"],@"partId":[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"openid"],@"type":@"2"};
                            LoginRequest *request = [LoginRequest new];
                            [request setFinishedBlock:^(BOOL isSucceed,NSString *tips) {
                                [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
                                if(isSucceed){
#pragma mark -- 进入主页面
                                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                                    if([[dic objectForKey:@"telephone"] length]!=0 &&[[dic objectForKey:@"keypwd"] length]!=0 && [[dic objectForKey:@"ismd5"] length]!=0){
                                        userModel.userPhoneNumber = [dic objectForKey:@"telephone"];
                                        userModel.userPassword = [dic objectForKey:@"keypwd"];
                                        userModel.userIsmd5 = [dic objectForKey:@"ismd5"];
                                        userModel.userKey = [dic objectForKey:@"key"];
                                        [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
                                        [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
//                                        LoginRequest *request = [LoginRequest new];
//                                        [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
//                                        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
//                                            [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
//                                            if(isSucceed){
#pragma mark -- 进入主页面
                                        [[NSUserDefaults standardUserDefaults] setObject:@"YES"forKey:@"IsLogin"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        RegisterViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                                        [self.navigationController pushViewController:vc1 animated:YES];
//                                            }else{
//                                                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
//                                            }
//                                        }];
//                                        [request loginWithUser:userModel];
                                    }else {
                                        VerifyPhoneViewController* vc = [[VerifyPhoneViewController alloc]init];
                                        vc.dataDict = sourceDic;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                }else{
                                    [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
                                }
                            }];
                            [request thirdPartLogin:userModel thirdKey:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"openid"] type:@"2"];
                        }];
                        
                    }
                }else {
                    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"QQ进行快速登录失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                    [alertView show];
                }
            });
        }else {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未安装QQ,不能使用QQ进行快速登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
        }
        
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
