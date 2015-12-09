//
//  WebViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/19.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
-(id)initWithURLStr:(NSString *)urlStr{
    self = [super init];
    if (self) {
        firestUrl = urlStr;
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    //self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)topTitle {
    UIView* bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    bgView.backgroundColor=[UIColor colorWithRed:248/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:bgView];
    
    //设置
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80,20,(self.view.width-80*2), 44)];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text = @"个人资料";
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
    [self topTitle];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, statusBarHeight)];
    view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"";
    naviConHeight=self.navigationController.navigationBar.frame.size.height;
    self.navigationItem.hidesBackButton = YES;
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 44, 44);
//    [backBtn setImage:[UIImage imageNamed:@"all_lefe"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(verifyPaySuccess:) name:@"Notif_payed" object:nil];
    
    myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, viewWidth, viewHeight-statusBarHeight-naviConHeight)];
    myWebView.delegate =self;
    [self.view addSubview:myWebView];
    myWebView.backgroundColor =[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    NSURL *url = [NSURL URLWithString:firestUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL: url];
    [myWebView loadRequest:request];
    
}
//开始加载的时候
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:myWebView animated:YES];
   
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:myWebView animated:YES];
    
    NSString* string = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"MenuApiList()"]];
    NSLog(@"%@",string);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:myWebView animated:YES];
    
}
- (void)doBack {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDlg.isLoadWebViewString = @"N";
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timeAD=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getState) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"IsRefresh"];
    [userDefaults synchronize];
    [timeAD invalidate];
    timeAD = nil;
}
-(void)getState{
    
    NSString *jsonStr = [myWebView stringByEvaluatingJavaScriptFromString:@"getstate()"];
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
//删除本地用户信息
-(BOOL)WithNameDeleteDataFile:(NSString *)name{ NSFileManager *fileManager = [NSFileManager defaultManager]; NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]]; [fileManager removeItemAtPath:name error:nil]; return YES;
}
-(void)verifyPaySuccess:(NSNotification*) notification{
    NSNumber *number = [notification object];
    NSString *jsFunction = [NSString stringWithFormat:@"appcall(%d)",[number intValue]];
    [self performSelector:@selector(exJs:) withObject:jsFunction afterDelay:0.5];
}

-(void)exJs:(NSString *)jsFunction{
    [myWebView stringByEvaluatingJavaScriptFromString:jsFunction];
}
- (void)webViewLoadWithHtmlNetString:(NSString *)htmlStr {
    NSURL *url = [NSURL URLWithString: htmlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL: url];
    [myWebView loadRequest:request];
}

#pragma mark -
#pragma mark UIWebView delegate Methods

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
#pragma mark 下载图片
-(void )getImageFromURL:(NSString *)fileURL {
    
    [MBProgressHUD showHUDAddedTo:myWebView animated:YES];
    NSURL *url = [NSURL URLWithString:fileURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *resultData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:resultData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:myWebView animated:YES];
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
