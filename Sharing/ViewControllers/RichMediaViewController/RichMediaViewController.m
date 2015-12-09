//
//  RichMediaViewController.m
//  Sharing
//
//  Created by 黄承琪 on 15/9/20.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "RichMediaViewController.h"
#import "SXTitleLable.h"
#import "HomeRequest.h"
#import "MJRefresh.h"

#import "NewsTableViewController.h"
@interface RichMediaViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSString *classID;
    NSString *appIDStr;
}

/** 标题栏 */
@property (weak, nonatomic) IBOutlet UIScrollView *smallScrollView;
/** 内容栏 */
@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;
@property(nonatomic,strong) SXTitleLable *oldTitleLable;
@property (nonatomic,assign) CGFloat beginOffsetX;

/** 新闻接口的数组 */
@property(nonatomic,strong) NSArray *arrayLists;
/** 头条轮播图片 */
@property(nonatomic,strong) NSArray *arrayBannerPics;
/** 分类数组 */
@property(nonatomic,strong) NSArray *arryClassList;
@property(nonatomic,assign,getter=isWeatherShow)BOOL weatherShow;
@property(nonatomic,strong)UIImageView *tran;
@property(nonatomic,strong)FenXiangUserInfoModel *userInfoModel;

//轮播
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *tilArray;
@property(nonatomic,strong)NSMutableArray *urlArray;
@end

@implementation RichMediaViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Islogin = [userDefaults objectForKey:@"IsLogin"];
    if ([Islogin isEqualToString:@"YES"]) {
         self.tabBarController.tabBar.hidden = YES;
        [self initData];
        
        NSURL *httpurl = [[NSURL alloc] initWithString:@"http://api.jlxmt.com/cgi-bin/version/get.html"];
        NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:httpurl];
        [request setTimeoutInterval:20];
        [request setHTTPMethod:@"GET"];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        //异步方式
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
         ^(NSURLResponse *response, NSData *data, NSError *error){
             if (error) {
                 NSLog(@"find a http request error %@",error);
             } else {
                 NSInteger code = [(NSHTTPURLResponse *)response statusCode];
                 if (code == 200) {
                     NSString *alldata = [[NSString alloc]initWithData:data
                                                              encoding:NSUTF8StringEncoding];
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         
                         NSLog(@"all data is %@",alldata);
                         NSError *error = nil;
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[alldata dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                         NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                         NSString *versionNew = [NSString stringWithFormat:@"%@",[dic objectForKey:@"version"]];
                         if (![version isEqualToString:versionNew]) {
                             NSString *testStr  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
                             appIDStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appid"]];
                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:testStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
                             [alert show];
                         }
                     });
                     
                     
                 }
             }
         }];

        
    }else
    {
     self.tabBarController.tabBar.hidden = NO;
    }
   
    self.navigationController.navigationBarHidden = YES;

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        if (appIDStr.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",appIDStr]]];
        }
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"NO"forKey:@"IsLogin"];
    [userDefaults synchronize];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = NO;
    if (self.arrayLists.count < 1) {
        return;
    }
    
    
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:56.0/255.0 alpha:1];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    self.smallScrollView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self addController];
    [self addLable];
    
   // CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    //self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    //self.smallScrollView.contentSize = CGSizeMake(70 * 6, 0);
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    SXTitleLable *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = 1.0;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;

}
#pragma mark - ******************** 刚进界面请求数据
-(void)initData
{
    [self.view makeToastActivity];
    HomeRequest *request = [HomeRequest new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    [request getJsonForNewWithKey:self.userInfoModel.userKey];//
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
     {
         [self.view hideToastActivity];
         if (tips.length > 0) {
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
             if(!error){
                 if([dic[@"errcode"]intValue] == 0){
                     
                     self.arrayBannerPics =  [dic objectForKey:@"banner"];
                     self.arrayLists = [dic objectForKey:@"data"];
                     self.arryClassList = [dic objectForKey: @"classify"];
                     
                     NSMutableArray * dicArray = [NSMutableArray arrayWithArray:self.arrayLists];
                     [dicArray insertObject:self.arrayBannerPics atIndex:0];
                     self.arrayLists = [NSArray  arrayWithArray:dicArray];
                     [self viewDidLoad];
                 }else {
                     [self.view makeToast:[dic objectForKey:@"errmsg"]];
                     [self viewDidLoad];
                 }
               
             }
         }
         else
         {
             [self.view makeToast:@"网络异常"];
             [self viewDidLoad];

         }
     }];

}
#pragma mark - ******************** 添加方法

/** 添加子控制器 */
- (void)addController
{
    
    /*
     @property(nonatomic,copy)NSString *ID;
     @property(nonatomic,assign) NSInteger tTapy;
     
     @property(nonatomic,strong)NSArray *FDataArray;
     @property (nonatomic,assign)BOOL IsFirstIn;

     */
    for (int i=0 ; i<self.arryClassList.count ;i++){
        NewsTableViewController *vc1 = [[UIStoryboard storyboardWithName:@"NewsStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        vc1.title = self.arryClassList[i][@"name"];
        vc1.ID =  [NSString stringWithFormat:@"%@",self.arryClassList[i][@"id"] ];
        id  tape = self.arryClassList[i][@"type"];
        vc1.tTapy = [tape integerValue];
        if (i == 0&&self.arrayLists.count > 0) {
            vc1.FDataArray = self.arrayLists;
            vc1.IsFirstIn = YES;
        }
        else
        {
            vc1.IsFirstIn = NO;
            vc1.FDataArray = nil;
        }
        [self addChildViewController:vc1];
    }
    self.bigScrollView.contentSize = CGSizeMake(kDeviceWidth * self.arryClassList.count, 0);
    
}

/** 添加标题栏 */
- (void)addLable
{
//    CGFloat Swith = 0;
    CGFloat LWith = 0;
    for (int i = 0; i < self.arryClassList.count; i++) {
        CGFloat lblW = 80;
        CGFloat lblH = 44;
        CGFloat lblY = 0;
        
        
        SXTitleLable *lbl1 = [[SXTitleLable alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text =vc.title;
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:@"HYQiHei" size:18]};
          CGSize titleSize = [lbl1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        lbl1.frame = CGRectMake(LWith, lblY, titleSize.width+20, lblH);
      
//        NSLog(@"宽度---%f,平均---%f",LWith,titleSize.width);
        LWith = LWith + titleSize.width +20;
        
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:18];
        [self.smallScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
        
    }
    NSLog(@"宽度---%f1",LWith);
    self.smallScrollView.contentSize = CGSizeMake(LWith, 0);
    
}


/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    SXTitleLable *titlelable = (SXTitleLable *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];
    
}






#pragma mark - ******************** scrollView代理方法

/** 滚动结束后调用（代码导致） */

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
//    NSLog(@"偏移值----%f,tableScr宽度----%f,index ---%lu",scrollView.contentOffset.x,self.bigScrollView.frame.size.width,(unsigned long)index);
    // 滚动标题栏
    SXTitleLable *titleLable = (SXTitleLable *)self.smallScrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - self.smallScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
    [self.smallScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    NewsTableViewController *newsVc = self.childViewControllers[index];
    //newsVc.index = index;
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            SXTitleLable *temlabel = self.smallScrollView.subviews[idx];
            temlabel.scale = 0.0;
            
        }
    }];
    
    if (newsVc.view.superview) return;
    newsVc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
//    if (value > 0&&value < 1) {
//        SXTitleLable *labelLeft = self.smallScrollView.subviews[0];
//        labelLeft.textColor = [UIColor orangeColor];
//    }
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SXTitleLable *labelLeft = self.smallScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        SXTitleLable *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
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
