//
//  MineHouseViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/13.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "MineHouseViewController.h"

@interface MineHouseViewController ()

@end

@implementation MineHouseViewController
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    MineHouseReqeust *request = [MineHouseReqeust new];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
        if(isSucceed){
//            NSLog(@"%@",tips);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary* dict = [dic objectForKey:@"info"];
            shareDict = [dic objectForKey:@"sharedata"];
            NSString* string = [NSString stringWithFormat:@"%@",[dict objectForKey:@"headimgurl"]];
            if(string.length!=0) {
                [self reloadDataMine:dict];
            }
            
            
        }else{
        }
    }];
    [request requestMineHouse:userModel.userKey];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self topTitle];
    self.navigationItem.title = @"我的窝";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES; 
    //背景滑动ScrollView
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight-statusBarHeight-tabbarHeight)];
    if(iPhone4) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, 727-tabbarHeight);
    }else if(iPhone5) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, 727-tabbarHeight+20);
    }else if(iPhone6) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight-tabbarHeight+100);
    }else if(iPhone6P) {
        bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight-tabbarHeight+80);
    }else{
        bottomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight-statusBarHeight-tabbarHeight+80);
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabbar) name:@"showTabbar" object:nil];
    bottomScrollView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:bottomScrollView];
    
    [self HeadImageCreation];
    [self MineMoney];
    [self MineOrder];
    [self ShareGetMoney];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        MineHouseReqeust *request = [MineHouseReqeust new];
        [MBProgressHUD showHUDAddedTo:bottomScrollView animated:YES];
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
            [MBProgressHUD hideHUDForView:bottomScrollView animated:YES];
            if(isSucceed){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                NSDictionary* dict = [dic objectForKey:@"info"];
                shareDict = [dic objectForKey:@"sharedata"];
                [self reloadDataMine:dict];
                
            }else{
                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
            }
        }];
        [request requestMineHouse:userModel.userKey];
    }
}
//- (void)showTabbar {
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
//    bgTitleView.hidden = YES;
//}
- (void)reloadDataMine:(NSDictionary *)dict {
    subDict = dict;
    
    //头像
//    if(headImageView.sd_imageURL)
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"headimgurl"]]]];
    NSString* string1 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"vtel"]];
    NSString* string2 = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"money"]];
    NSString* string3 = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"mycoupon"]];
    NSString* string4 = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"total"]];
    if(![string1 isEqualToString:phoneLabel.text]) {
        //手机号
        phoneLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"vtel"]];
    }
    if(![string2 isEqualToString:yueeLabel.text]) {
        //我的钱包
        yueeLabel.text = [NSString stringWithFormat:@"%@\n余额",[subDict objectForKey:@"money"]];
    }
    if(![string3 isEqualToString:yhqLael.text]) {
        yhqLael.text = [NSString stringWithFormat:@"%@\n优惠券",[subDict objectForKey:@"mycoupon"]];
    }
    if(![string4 isEqualToString:ljsyLabel.text]) {
        ljsyLabel.text = [NSString stringWithFormat:@"%@\n累计收益",[subDict objectForKey:@"total"]];
    }
}
#pragma mark -- 头像 创作 作品
- (void)HeadImageCreation {
    bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 201)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [bottomScrollView addSubview:bgView1];
    //头像
//    UIView* headView = [[UIView alloc]initWithFrame:];
//    headView.backgroundColor = ;
//    [bgView1 addSubview:headView];
    
    UIButton* headView = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView setFrame:CGRectMake((viewWidth-85)/2,9, 85, 85)];
    [headView setBackgroundColor:[UIColor colorWithRed:252/255.0 green:241/255.0 blue:225/255.0 alpha:1]];
    [headView addTarget:self action:@selector(pressMineInfo) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:headView];
    
    headImageView = [[UIImageView alloc]init];
    headImageView.frame = CGRectMake(5, 5, headView.frame.size.width-10, headView.frame.size.height-10);
    [headView addSubview:headImageView];
    [self calyer:headView sizeFloat:headView.frame.size.width/2];
    [self calyer:headImageView sizeFloat:headImageView.frame.size.width/2];
    //手机号码
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headView.bottom+9, viewWidth, 15)];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.text = @"183****5606";
    phoneLabel.textColor = [UIColor colorWithRed:255/255.0 green:154/255.0 blue:22/255.0 alpha:1];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [bgView1 addSubview:phoneLabel];
    //线
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, phoneLabel.bottom+11, viewWidth, 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [bgView1 addSubview:lineView1];
    
    NSArray* arrayImage = [NSArray arrayWithObjects:@"mine_workicon",@"mine_prizeicon",@"mine_collectionicon",nil];
    NSArray* titleArray = [NSArray arrayWithObjects:@"我要创作",@"我的作品",@"我的收藏",nil];
    for(int i=0;i<arrayImage.count;i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0+(viewWidth)/3*i, lineView1.bottom, (viewWidth)/3, 64)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(pressMineWork:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [bgView1 addSubview:button];
        
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrayImage objectAtIndex:i]]]];
        imageView.frame = CGRectMake((button.frame.size.width-imageView.image.size.width)/2, 8, imageView.image.size.width, imageView.image.size.height);
        [button addSubview:imageView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+5, button.frame.size.width, 13)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [titleArray objectAtIndex:i];
        label.textColor = [UIColor colorWithRed:61/255.0 green:67/255.0 blue:69/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width+1+button.frame.size.width*i, lineView1.bottom+10, 1, 44)];
        lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
        [bgView1 addSubview:lineView];
    }
    
    UIView* lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView1.size.height-1, viewWidth, 1)];
    lineView2.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [bgView1 addSubview:lineView2];
}
- (void)pressMineInfo {
    NSString* urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"infourl"]];
//    WebViewController *vc1 = [[WebViewController alloc]initWithURLStr:urlStr];
//    //    vc1.firestUrl = urlStr;
//    //    vc1.isPush = YES;
//    [self.navigationController pushViewController:vc1 animated:YES];
    NewsViewController *vc1 = [[NewsViewController alloc]init];
    vc1.firestUrl = urlStr;
    vc1.isPush = YES;
    vc1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)pressMineWork:(UIButton *)button {
    NSString* urlStr;
    if(button.tag == 0){
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"cz_url"]];
    }else if(button.tag == 1) {
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"zp_url"]];
    }else if(button.tag == 2){
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"sc_url"]];
    }
    NewsViewController *vc1 = [[NewsViewController alloc]init];
    vc1.firestUrl = urlStr;
    
    vc1.isPush = YES;
    vc1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)calyer:(UIView *)view sizeFloat:(float)size {
    CALayer *laygender = view.layer;
    [laygender setMasksToBounds:YES];
    [laygender setCornerRadius:size];
}
- (void)lineView:(UIView *)view left:(float)left top:(float)top width:(float)width height:(float)height{
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(left, top, width, height)];
    lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [view addSubview:lineView];
}
#pragma mark -- 我的钱包
- (void)MineMoney {
    bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView1.bottom+10, viewWidth, 88)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [bottomScrollView addSubview:bgView2];
    
    [self lineView:bgView2 left:0 top:0 width:viewWidth height:1];
    
    //我的钱包
    UIButton* poketbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [poketbutton setFrame:CGRectMake(0,1,viewWidth, 42)];
    [poketbutton setBackgroundColor:[UIColor clearColor]];
    [poketbutton addTarget:self action:@selector(pressMinePoket) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:poketbutton];
    
    UIImageView* poketImgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_poket"]];
    poketImgeView.frame = CGRectMake(6,6, poketImgeView.image.size.width, poketImgeView.image.size.height);
    [poketbutton addSubview:poketImgeView];
    
    UILabel* poketLabel = [[UILabel alloc]initWithFrame:CGRectMake(13+poketImgeView.image.size.width, 1, 80, poketbutton.frame.size.height)];
    poketLabel.backgroundColor = [UIColor clearColor];
    poketLabel.text = @"我的钱包";
    poketLabel.textColor = [UIColor colorWithRed:61/255.0 green:67/255.0 blue:69/255.0 alpha:1];
    poketLabel.textAlignment = NSTextAlignmentLeft;
    poketLabel.font = [UIFont systemFontOfSize:15];
    [poketbutton addSubview:poketLabel];
    
    UIImageView* rightArrowImgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_rarow"]];
    rightArrowImgeView.frame = CGRectMake(poketbutton.frame.size.width-rightArrowImgeView.image.size.width, (poketbutton.frame.size.height-rightArrowImgeView.frame.size.height)/2, rightArrowImgeView.image.size.width, rightArrowImgeView.image.size.height);
    [poketbutton addSubview:rightArrowImgeView];
    
    UILabel* billLabel = [[UILabel alloc]initWithFrame:CGRectMake(poketbutton.frame.size.width-rightArrowImgeView.image.size.width-80, 0, 80, poketbutton.frame.size.height)];
    billLabel.backgroundColor = [UIColor clearColor];
    billLabel.text = @"提现、账单等";
    billLabel.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1];
    billLabel.font = [UIFont systemFontOfSize:13];
    [poketbutton addSubview:billLabel];
    
    [self lineView:bgView2 left:6 top:poketbutton.bottom width:viewWidth-6 height:1];
    
    NSArray* moneyArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"0"],[NSString stringWithFormat:@"0张"],[NSString stringWithFormat:@"0"], nil];
    NSArray* titleArray = [NSArray arrayWithObjects:@"余额",@"优惠券",@"累计收益", nil];
    for(int i=0;i<titleArray.count;i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0+(viewWidth)/3*i, 43, (viewWidth)/3, 49)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(pressBalanceOpouns:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [bgView2 addSubview:button];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, button.frame.size.width, button.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%@\n%@",[moneyArray objectAtIndex:i],[titleArray objectAtIndex:i]];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [button addSubview:label];
        if(i==0) {
            yueeLabel = label;
        }else if(i==1) {
            yhqLael= label;
        }else if(i==2) {
            ljsyLabel = label;
        }
//        [self lineView:bgView2 left:button.frame.size.width+1 top:10 width:1 height:button.frame.size.height-20];
    }
    [self lineView:bgView2 left:0 top:bgView2.frame.size.height-1 width:viewWidth height:1];
    
}
- (void)pressMinePoket {
    NSString* urlStr;
    urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"money_url"]];
    NewsViewController *vc1 = [[NewsViewController alloc]init];
    vc1.firestUrl = urlStr;
    
    vc1.isPush = YES;
    vc1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)pressBalanceOpouns:(UIButton *)button {
    NSString* urlStr;
    if(button.tag == 0) {
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"money_url"]];
    }else if(button.tag == 1){
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"mycoupon_url"]];
    }else if(button.tag == 2) {
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"total_url"]];
    }
    NewsViewController *vc1 = [[NewsViewController alloc]init];
    vc1.firestUrl = urlStr;
    
    vc1.isPush = YES;
    vc1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc1 animated:YES];
}
#pragma mark -- 我的订单
- (void)MineOrder {
    bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView2.bottom+10, viewWidth, 102)];
    bgView3.backgroundColor = [UIColor whiteColor];
    [bottomScrollView addSubview:bgView3];
    
    //我的订单
    UIButton* orderbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderbutton setFrame:CGRectMake(0,1,viewWidth, 38)];
    [orderbutton setBackgroundColor:[UIColor clearColor]];
    [orderbutton addTarget:self action:@selector(pressMineOrder) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:orderbutton];
    
    UIImageView* poketImgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_dlist"]];
    poketImgeView.frame = CGRectMake(6,6, poketImgeView.image.size.width, poketImgeView.image.size.height);
    [orderbutton addSubview:poketImgeView];
    
    UILabel* poketLabel = [[UILabel alloc]initWithFrame:CGRectMake(13+poketImgeView.image.size.width, 1, 80, orderbutton.frame.size.height)];
    poketLabel.backgroundColor = [UIColor clearColor];
    poketLabel.text = @"我的订单";
    poketLabel.textColor = [UIColor colorWithRed:61/255.0 green:67/255.0 blue:69/255.0 alpha:1];
    poketLabel.textAlignment = NSTextAlignmentLeft;
    poketLabel.font = [UIFont systemFontOfSize:15];
    [orderbutton addSubview:poketLabel];
    
    UIImageView* rightArrowImgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_rarow"]];
    rightArrowImgeView.frame = CGRectMake(orderbutton.frame.size.width-rightArrowImgeView.image.size.width, (orderbutton.frame.size.height-rightArrowImgeView.frame.size.height)/2, rightArrowImgeView.image.size.width, rightArrowImgeView.image.size.height);
    [orderbutton addSubview:rightArrowImgeView];
    
    UILabel* billLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderbutton.frame.size.width-rightArrowImgeView.image.size.width-55, 0, 55, orderbutton.frame.size.height)];
    billLabel.backgroundColor = [UIColor clearColor];
    billLabel.text = @"全部订单";
    billLabel.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1];
    billLabel.font = [UIFont systemFontOfSize:13];
    [orderbutton addSubview:billLabel];
    
    [self lineView:bgView3 left:6 top:orderbutton.bottom width:viewWidth-6 height:1];
    
    NSArray* moneyArray = [NSArray arrayWithObjects:@"mine_wait",@"mine_carbox",@"mine_carclock",@"mine_prizeicon",@"mine_backpay", nil];
    NSArray* titleArray = [NSArray arrayWithObjects:@"待付款",@"待发货",@"待收货",@"待评价",@"退款/售后",nil];
    for(int i=0;i<titleArray.count;i++) {
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0+(viewWidth)/5*i, 46, (viewWidth)/5, 59)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(pressWaitCarBox:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [bgView3 addSubview:button];
        
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[moneyArray objectAtIndex:i]]]];
        imageView.frame = CGRectMake((button.frame.size.width-imageView.image.size.width)/2, 8, imageView.image.size.width, imageView.image.size.height);
        [button addSubview:imageView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+5, button.frame.size.width, 13)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [titleArray objectAtIndex:i];
        label.textColor = [UIColor colorWithRed:61/255.0 green:67/255.0 blue:69/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    [self lineView:bgView3 left:0 top:bgView3.frame.size.height-1 width:viewWidth height:1];

}
- (void)pressMineOrder {
    NSString* urlStr;
    urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"order_url"]];
    NewsViewController *vc1 = [[NewsViewController alloc]init];
    vc1.firestUrl = urlStr;
    
    vc1.isPush = YES;
    vc1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (void)pressWaitCarBox:(UIButton *)button {
    NSString* urlStr;
    urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:[NSString stringWithFormat:@"order_url_%ld",button.tag + 1]]];
    NewsViewController *vc1 = [[NewsViewController alloc]init];
    vc1.firestUrl = urlStr;
    
    vc1.isPush = YES;
    vc1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc1 animated:YES];
}
#pragma mark -- 分享更多
- (void)ShareGetMoney {
    bgView4 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView3.bottom+10, viewWidth, 226)];
    bgView4.backgroundColor = [UIColor whiteColor];
    [bottomScrollView addSubview:bgView4];
    
    [self lineView:bgView4 left:0 top:0 width:viewWidth height:1];
    
    
    NSArray* imageArray = [NSArray arrayWithObjects:@"mine_link",@"mine_fly",@"mine_adress",@"mine_touch",@"mine_flow",nil];
    NSArray* titleArray = [NSArray arrayWithObjects:@"分享好友一起赚钱",@"我转发的作品",@"收货地址",@"帮助说明",@"关于久领", nil];
    
    for(int i=0;i<imageArray.count;i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0,1+45*i, viewWidth, 45)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(pressShare:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [bgView4 addSubview:button];
        
        
        UIImageView* titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:i]]]];
        titleImageView.frame = CGRectMake(6, (button.frame.size.height-titleImageView.image.size.height)/2, titleImageView.image.size.width, titleImageView.image.size.height);
        [button addSubview:titleImageView];
        
        UIImageView* rightArrowImgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_rarow"]];
        rightArrowImgeView.frame = CGRectMake(button.frame.size.width-rightArrowImgeView.image.size.width, (button.frame.size.height-rightArrowImgeView.frame.size.height)/2, rightArrowImgeView.image.size.width, rightArrowImgeView.image.size.height);
        [button addSubview:rightArrowImgeView];
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13+titleImageView.image.size.width, 0, (button.frame.size.width-titleImageView.image.size.width-rightArrowImgeView.image.size.width), 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [titleArray objectAtIndex:i];
        titleLabel.textColor = [UIColor colorWithRed:61/255.0 green:67/255.0 blue:69/255.0 alpha:1];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [button addSubview:titleLabel];
        
        [self lineView:button left:0 top:button.frame.size.height-1 width:viewWidth height:1];
    }
}
- (void)topTitle {
    bgTitleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    bgTitleView.backgroundColor=[UIColor colorWithRed:248/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:bgTitleView];
    
    //设置
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80,20,(self.view.width-80*2), 44)];
    titleLabel.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:17];
    titleLabel.text = @"我的窝";
    titleLabel.textColor=[UIColor colorWithRed:(96 / 255.0) green:(96 / 255.0) blue:(96 / 255.0) alpha:1];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [bgTitleView addSubview:titleLabel];

    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63, viewWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:(212 / 255.0) green:(212 / 255.0) blue:(212 / 255.0) alpha:1];
    [bgTitleView addSubview:lineView];
    
    bgTitleView.hidden = YES;
}
- (void)pressShare:(UIButton *)button {
    NSString* urlStr;
    if(button.tag == 0) {
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"sharing_url"]];
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }else if(button.tag == 1){
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"share_url"]];
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
        
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }else if(button.tag == 2){
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"address_url"]];
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
        
    }else if(button.tag == 3){
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"help_url"]];
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }else if(button.tag == 4){
        urlStr = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"about_url"]];
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
        
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
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
