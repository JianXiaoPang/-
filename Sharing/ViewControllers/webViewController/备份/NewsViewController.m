//
//  NewsViewController.m
//  Sharing
//
//  Created by huangchengqi on 15/9/28.
//  Copyright (c) 2015年 黄承琪. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()
{
    NSMutableArray *dicsArray;
    NSTimer * timeAD;
}

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UILabel *CerTitleLabel;

@property (nonatomic,strong) NSMutableArray *URLArray;
@property (weak, nonatomic) IBOutlet UIButton *GoBackBtn;

@end

@implementation NewsViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timeAD invalidate];
    timeAD = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(verifyPaySuccess:) name:@"Notif_payed" object:nil];
    
    _myWebView.scrollView.alwaysBounceVertical = NO;
   // scroller.alwaysBounceHorizontal = NO;
//    self.myWeb.scrollView.bounces =NO;
//    [self webViewLoadWithHtmlNetString:firestUrl];
    
    self.URLArray = [[NSMutableArray alloc]init];
    _myWebView = [[UIWebView alloc]init];
    _myWebView.delegate =self;
    _myWebView.frame = CGRectMake(0, 65, kDeviceWidth, KDeviceHeight-64);
    [self.view addSubview:_myWebView];
    NSURL *url = [NSURL URLWithString:_firestUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL: url];
    [_myWebView loadRequest:request];
}

#pragma mark - *********************************************开始加载的时候
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:_myWebView animated:YES];
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:_myWebView animated:YES];
    NSString *currentURL = [_myWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if (self.URLArray.count == 0) {
        [self.URLArray addObject:currentURL];
    }
    else
    {
        if ([self.URLArray containsObject:currentURL]) {
            
        }
        else
        {
            [self.URLArray addObject:currentURL];
        }
        
        
    
    
    }
    if (self.URLArray.count > 1) {
        self.GoBackBtn.hidden = NO;
    }
    NSString *title = [_myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.CerTitleLabel.text = title;
    [self getJsonForJSBtn];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [MBProgressHUD hideHUDForView:_myWebView animated:YES];
    
}

#pragma mark - *********************************************点击事件
- (IBAction)BackHomeClick:(UIButton *)sender {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDlg.isLoadWebViewString = @"N";
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goBack:(UIButton *)sender {
    if (self.URLArray.count <= 1 ) {
        AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDlg.isLoadWebViewString = @"N";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.URLArray removeLastObject];
        NSString *URLStr = [self.URLArray lastObject];
        NSURL *url = [NSURL URLWithString:URLStr];
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL: url];
        [_myWebView loadRequest:request];
        
    }
    
}
- (IBAction)BtnClick:(UIButton *)sender {
    if (dicsArray.count < 1) {
        
    }
    else
    {
        NSString *jsonStr= [_myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onMenuClick(%ld,1)",(long)sender.tag]];
        
        if(jsonStr.length>0){
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            if(!error){
                int JSkey=[dic[@"Key"]intValue];
                if(JSkey == 1){
                    NSDictionary *shareDic = dic[@"Data"];
                    ShareModel *shareModel = [ShareModel new];
                    shareModel.shareTitle = shareDic[@"ShareTitle"];
                    shareModel.shareContent = shareDic[@"ShareContent"];
                    shareModel.sharePic = shareDic[@"SharePic"];
                    shareModel.shareUrl = shareDic[@"ShareUrl"];
                    
                    NSArray *reDic = dic[@"Report"];
                    if (reDic.count > 0) {
                        shareModel.returnDic = dic[@"Report"][@"Data"];
                    }
//修改275行
                    
                    ShareTemplate *s= [[ShareTemplate alloc]init];
                    [s actionWithShare:self WithSinaModel:shareModel];
                }else if(JSkey == 2){
                    NSDictionary *paramInfo = dic[@"Data"];
                    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
                        PayReq* req             = [[PayReq alloc] init];
                        req.openID              = [paramInfo objectForKey:@"appid"];
                        req.partnerId           = [paramInfo objectForKey:@"partnerid"];
                        req.prepayId            = [paramInfo objectForKey:@"prepayid"];
                        req.nonceStr            = [paramInfo objectForKey:@"noncestr"];
                        req.timeStamp           = [[paramInfo objectForKey:@"timestamp"] intValue];
                        req.package             = [paramInfo objectForKey:@"package"];
                        req.sign                = [paramInfo objectForKey:@"sign"];
                        [WXApi sendReq:req];
                    }else {
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请安装最新版本微信客户端" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
                    }
                }else if (JSkey == 3){
                    NSString * Scheme = @"MiniMini";
                    NSString *orderStr = dic[@"Data"][@"str"];
                    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:Scheme callback:^(NSDictionary *resultDic) {
                        if (9000 ==  [resultDic[@"resultStatus"] integerValue]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(0)];
                        }else{
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(1)];
                        }
                    }];
                }else if (JSkey == 0){
                    NSString *copyStr = dic[@"Data"][@"str"];
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = copyStr;
                    [GlobalFunction makeToast:@"复制成功" duration:1.0 HeightScale:0.5];
                }else if (JSkey == 5){
                    int iShare =[(dic[@"Data"][@"isShare"])intValue];
                    //下载图片
                    if(iShare==0){
                        NSString *imgUrl = dic[@"Data"][@"img"];
                        if(imgUrl.length >0){
                            [self getImageFromURL:imgUrl];
                        }
                    }
                    //分享图片
                    else if (iShare == 1){
                        
                        ShareModel *shareModel = [ShareModel new];
                        shareModel.shareTitle = @"";
                        shareModel.shareContent = @"";
                        shareModel.sharePic = dic[@"Data"][@"img"];
                        shareModel.shareUrl = @"";
                        shareModel.returnDic = nil;
                        ShareTo *shareTo= [ShareTo new];
                        
                        NSString *sharePlatForm = dic[@"Data"][@"Share"];
                        
                        if([sharePlatForm isEqualToString:@"ShareAppMessage"]){
                            [shareTo actionShare:self withSinaModel:shareModel andPlatformType:ShareAppMessage];
                        }else if([sharePlatForm isEqualToString:@"ShareTimeline"]){
                            [shareTo actionShare:self withSinaModel:shareModel andPlatformType:ShareTimeline];
                        }
                    }
                }else if (JSkey == 6){
                    NSNumber * typeStyle = dic[@"Data"][@"type"];
                    if([typeStyle intValue]==1){
                        //注销退出
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
                        [self WithNameDeleteDataFile:[NSString stringWithFormat:@"fenxiang%@.archive",userModel.userKey]];
                    }else if ([typeStyle intValue]==2){
                        //重新登录进入不需要做任何操作
                    }
                    //MainViewController
                    NSArray *viewControllers = self.navigationController.viewControllers;
                    for (UIViewController *vc in viewControllers) {
                        if([vc isKindOfClass:[LoginRegisterViewController class]]){
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
                    
                }
            }
        }
    
    }
    
}

//删除本地用户信息
-(BOOL)WithNameDeleteDataFile:(NSString *)name{ NSFileManager *fileManager = [NSFileManager defaultManager]; NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]]; [fileManager removeItemAtPath:name error:nil]; return YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timeAD=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getState) userInfo:nil repeats:YES];
}



-(void)getState{
    
    NSString *jsonStr = [_myWebView stringByEvaluatingJavaScriptFromString:@"getstate()"];
    //CLog(@"jsonStr----%@",jsonStr);
    
    if(jsonStr.length>0){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(!error){
            int JSkey=[dic[@"Key"]intValue];
            if(JSkey == 1){
                NSDictionary *shareDic = dic[@"Data"];
                ShareModel *shareModel = [ShareModel new];
                shareModel.shareTitle = shareDic[@"ShareTitle"];
                shareModel.shareContent = shareDic[@"ShareContent"];
                shareModel.sharePic = shareDic[@"SharePic"];
                shareModel.shareUrl = shareDic[@"ShareUrl"];
                shareModel.returnDic = dic[@"Report"][@"Data"];
                
                ShareTemplate *s= [[ShareTemplate alloc]init];
                [s actionWithShare:self WithSinaModel:shareModel];
            }else if(JSkey == 2){
                NSDictionary *paramInfo = dic[@"Data"];
                if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = [paramInfo objectForKey:@"appid"];
                    req.partnerId           = [paramInfo objectForKey:@"partnerid"];
                    req.prepayId            = [paramInfo objectForKey:@"prepayid"];
                    req.nonceStr            = [paramInfo objectForKey:@"noncestr"];
                    req.timeStamp           = [[paramInfo objectForKey:@"timestamp"] intValue];
                    req.package             = [paramInfo objectForKey:@"package"];
                    req.sign                = [paramInfo objectForKey:@"sign"];
                    [WXApi sendReq:req];
                }else {
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请安装最新版本微信客户端" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
                }
            }else if (JSkey == 3){
                NSString * Scheme = @"FenXiang";
                NSString *orderStr = dic[@"Data"][@"str"];
                [[AlipaySDK defaultService] payOrder:orderStr fromScheme:Scheme callback:^(NSDictionary *resultDic) {
                    if (9000 ==  [resultDic[@"resultStatus"] integerValue]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(0)];
                    }else{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"Notif_payed" object:@(1)];
                    }
                }];
            }else if (JSkey == 0){
                NSString *copyStr = dic[@"Data"][@"str"];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = copyStr;
                [GlobalFunction makeToast:@"复制成功" duration:1.0 HeightScale:0.5];
            }else if (JSkey == 5){
                int iShare =[(dic[@"Data"][@"isShare"])intValue];
                //下载图片
                if(iShare==0){
                    NSString *imgUrl = dic[@"Data"][@"img"];
                    if(imgUrl.length >0){
                        [self getImageFromURL:imgUrl];
                    }
                }
                //分享图片
                else if (iShare == 1){
                    
                    ShareModel *shareModel = [ShareModel new];
                    shareModel.shareTitle = @"";
                    shareModel.shareContent = @"";
                    shareModel.sharePic = dic[@"Data"][@"img"];
                    shareModel.shareUrl = @"";
                    shareModel.returnDic = nil;
                    ShareTo *shareTo= [ShareTo new];
                    
                    NSString *sharePlatForm = dic[@"Data"][@"Share"];
                    
                    if([sharePlatForm isEqualToString:@"ShareAppMessage"]){
                        [shareTo actionShare:self withSinaModel:shareModel andPlatformType:ShareAppMessage];
                    }else if([sharePlatForm isEqualToString:@"ShareTimeline"]){
                        [shareTo actionShare:self withSinaModel:shareModel andPlatformType:ShareTimeline];
                    }
                }
            }else if (JSkey == 6){
                NSNumber * typeStyle = dic[@"Data"][@"type"];
                if([typeStyle intValue]==1){
                    //注销退出
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    FenXiangUserInfoModel* userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
                    [self WithNameDeleteDataFile:[NSString stringWithFormat:@"fenxiang%@.archive",userModel.userKey]];
                    NSUserDefaults *userDefaultss = [NSUserDefaults standardUserDefaults];
                    FenXiangUserInfoModel* userModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaultss objectForKey:@"key"]]];
                    if (userModels == nil) {
                        userModels = [[FenXiangUserInfoModel alloc]init];
                    }
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    userModels.showGuideVersion = [NSString stringWithFormat:@"%@",version];
                    [[NSUserDefaults standardUserDefaults] setObject:userModels.userKey forKey:@"key"];
                    [NSKeyedArchiver archiveRootObject:userModels toFile:[FXUtilities archivePath:userModels.userKey]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [GlobalFunction makeToast:@"退出成功" duration:1.0 HeightScale:0.5];
                    
                    
                    //                    LoginViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                    //                    [self dismissViewControllerAnimated:YES completion:nil];
                    //                    [[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController] removeFromParentViewController];
                    
                    LoginRegisterViewController* lVC = [[LoginRegisterViewController alloc]init];
                    [self presentViewController:lVC animated:YES completion:nil];
                }else if ([typeStyle intValue]==2){
                    //重新登录进入不需要做任何操作
                }
                //MainViewController
                NSArray *viewControllers = self.navigationController.viewControllers;
                for (UIViewController *vc in viewControllers) {
                    if([vc isKindOfClass:[LoginRegisterViewController class]]){
                        [self.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
                
            }
        }
    }
}

-(void)verifyPaySuccess:(NSNotification*) notification{
    NSNumber *number = [notification object];
    NSString *jsFunction = [NSString stringWithFormat:@"appcall(%d)",[number intValue]];
    [self performSelector:@selector(exJs:) withObject:jsFunction afterDelay:0.5];
}

-(void)exJs:(NSString *)jsFunction{
    [_myWebView stringByEvaluatingJavaScriptFromString:jsFunction];
}

#pragma mark - BackButtonDelegate

- (void)actionWithBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark - *****************************获取按钮
-(void)getJsonForJSBtn
{
    
    NSString *jsonStr = [_myWebView stringByEvaluatingJavaScriptFromString:@"MenuApiList()"];
    if(jsonStr.length>0){
        NSError *error = nil;
        NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if(!error){
            
            if (dicArray.count == 0) {
                return;
            }
            else if (dicArray.count == 1)
            {
                NSDictionary *dic = [dicArray firstObject];
                [self seDicToBtn1:dic];
            }
            else
            {
                
                NSDictionary *dic1 = [dicArray firstObject];
                NSDictionary *dic2 = [dicArray lastObject];
                [self seDicToBtn1:dic1];
                [self seDicToBtn2:dic2];
            }
            dicsArray = [[NSMutableArray alloc]initWithArray:dicArray];
            
        }
        
    }
}
#pragma mark - ***********赋值
-(void)seDicToBtn1:(NSDictionary *)dic
{
    NSInteger difi = [[dic objectForKey:@"ispic"] integerValue];
    if (difi == 1) {
        
        [self.btn1 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"data"]]]] forState:UIControlStateNormal];
    }
    else
    {
        [self.btn1 setTitle:[dic objectForKey:@"data"] forState:UIControlStateNormal];
    }
    NSInteger tag1 = [[dic objectForKey:@"type"] integerValue];
    self.btn1.tag  = tag1;

}
-(void)seDicToBtn2:(NSDictionary *)dic
{
    NSInteger difi = [[dic objectForKey:@"ispic"] integerValue];
    if (difi == 1) {
       [self.btn2 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"data"]]]] forState:UIControlStateNormal];
    }
    else
    {
        [self.btn2 setTitle:[dic objectForKey:@"data"] forState:UIControlStateNormal];
    }
    NSInteger tag1 = [[dic objectForKey:@"type"] integerValue];
    self.btn2.tag  = tag1;
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
#pragma mark 下载图片
-(void )getImageFromURL:(NSString *)fileURL {
    
    [MBProgressHUD showHUDAddedTo:_myWebView animated:YES];
    NSURL *url = [NSURL URLWithString:fileURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *resultData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:resultData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_myWebView animated:YES];
            [self saveImageToPhotos:img];
        });
    });
}

#pragma mark 保存图片进相册
- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
-(void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    [GlobalFunction makeToast:msg duration:1.0 HeightScale:0.5];
    
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
