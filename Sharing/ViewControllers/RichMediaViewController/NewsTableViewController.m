//
//  NewsTableViewController.m
//  Sharing
//
//  Created by huangchengqi on 15/9/23.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "WebViewController.h"
#import "NewsViewController.h"
#import "ClassTableViewController.h"
#import "EditorWebViewController.h"
@interface NewsTableViewController ()<NewsTableViewCellDelegate>

{
    //table 脚部视图
    FCXRefreshFooterView *footerView;
}
/** 下拉刷新->第一次刷新YES 第二次添加NO */
@property(nonatomic,assign)  BOOL UpLoadNews;

/** 推荐->0 分类->1 */
@property(nonatomic,assign) NSInteger SegIndex;
/** 数据源 */
@property(nonatomic,strong) NSMutableArray *arrayList;
/** 轮播图数据源 */
@property(nonatomic,strong) NSMutableArray *arrayBannerPics;
@property(nonatomic,assign)BOOL update;
@property(nonatomic,strong)FenXiangUserInfoModel *userInfoModel;
/** 防止上拉刷新 */
@property (nonatomic ,assign)BOOL isCanResh;
/** 防止重复刷新数组 */
@property (nonatomic,strong) NSMutableArray *RepeatArray;
@end

@implementation NewsTableViewController

-(void)viewWillAppear:(BOOL)animated
{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    self.RepeatArray = [[NSMutableArray alloc]init];
    _isCanResh = NO;
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadData)];
    //    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.update = YES;
    __weak __typeof(self)weakSelf = self;
    //上拉加载更多
    footerView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreData];
    }];
    //自动刷新
    footerView.autoLoadMore = NO;
    
    if (self.IsFirstIn == YES) {
        self.arrayList = [NSMutableArray arrayWithArray:self.FDataArray];
        id  anyS = [self.arrayList firstObject];
        NSMutableArray *copyArray;
        if ([anyS isKindOfClass:[NSArray class]]) {
            copyArray = [[NSMutableArray alloc]initWithObjects:anyS, nil];
            [self.arrayList removeObjectAtIndex:0];
            NSMutableArray *compArray = [self ArrayCompare:self.arrayList];
            [copyArray addObjectsFromArray:compArray];
            self.arrayList = [NSMutableArray arrayWithArray:copyArray];
        }
        else
        {
            NSMutableArray *compArray = [self ArrayCompare:self.arrayList];
            self.arrayList = [NSMutableArray arrayWithArray:compArray];
        }
        //[self.tableView reloadData];
        //[self FootUpLoad];
    }
    else
    {
        if (self.update == YES) {
            [self.tableView headerBeginRefreshing];
            self.update = NO;
        }
        else
        {
            if (self.arrayList.count < 1) {
                self.update = YES;
                [self.tableView headerBeginRefreshing];
            }
        }
    }
   
}

#pragma mark - *********************************************网络请求区
#pragma mark - **********************下拉刷新
-(void)loadData
{
#warning 传第一个id  添加参数是插入到一个元素
    
    NSLog(@"分类id--:%@,type---:%ld",self.ID,(long)self.tTapy);
    /*
     1.判断刷新还是加载 ->self.UpLoadNews
     2.判断是普通新闻还是原创新闻 ->self.tTapy == 1
     3.判断有没有banner图 ->picArray.count > 0
     4.数据源倒序排序 —>self ArrayCompare:CArray
     */
    if (self.UpLoadNews == YES) {
        //切换不同界面
        [self.view makeToastActivity];
        HomeRequest *request = [HomeRequest new];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
        //self.userInfoModel.userKey - self.userInfoModel.userKey
        if (self.tTapy == 1) {
            if (self.SegIndex == 0) {
                [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"0" IsOriginal:YES ArticleId:@"0"];
            }
            else
            {
                //自动刷新
                [self.tableView headerEndRefreshing];
                [self.view hideToastActivity];
            }
            
        }
        else
        {
            [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"0" IsOriginal:NO ArticleId:@"0"];
        }
        
        //
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
         {
             [self.view hideToastActivity];
             if (tips.length > 0) {
                 [self.tableView headerEndRefreshing];
                 NSError *error = nil;
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                 if(!error){
                     if([dic[@"errcode"]intValue] == 0){
                         NSMutableArray *picArray = [dic objectForKey:@"banner"];
                         if (picArray.count > 0) {
                             self.arrayBannerPics =  [dic objectForKey:@"banner"];
                             NSMutableArray *CArray= [dic objectForKey:@"data"];
                             self.arrayList = [self ArrayCompare:CArray];
                             NSMutableArray * dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                             [dicArray insertObject:self.arrayBannerPics atIndex:0];
                             self.arrayList = [NSMutableArray  arrayWithArray:dicArray];
                             self.UpLoadNews = NO;
                             
                             [self.tableView reloadData];
                             
                             
                         }
                         else
                         {
                             self.arrayBannerPics = [[NSMutableArray alloc]init];
                             //排序
                             NSMutableArray *CArray= [dic objectForKey:@"data"];
                             self.arrayList = [self ArrayCompare:CArray];
                             self.UpLoadNews = NO;
                             
                             [self.tableView reloadData];
                             
                         }
                     }else {
                         [self.view makeToast:[dic objectForKey:@"errmsg"]];
                         
                     }
                     
                 }
             }
             else
             {
                 [self.tableView headerEndRefreshing];
                 
                 [self.view makeToast:@"网络异常"];
                 
             }
         }];
    }
    else
    {
        /*
         1.判断是普通新闻还是原创新闻 ->self.tTapy == 1
         2.判断是否含有banner图 ->
         3.新添加的数据排序
         */
        HomeRequest *request = [HomeRequest new];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
        //self.userInfoModel.userKey - self.userInfoModel.userKey
        if (self.tTapy == 1) {
            if (self.SegIndex == 0) {
                if (self.arrayList.count >0) {
                    NSDictionary *dic = [self.arrayList firstObject];
                    NSString *idStr= [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                    if (idStr.length > 0) {
                        [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"0" IsOriginal:YES ArticleId:[dic objectForKey:@"id"]];
                    }
                    else
                    {
                        [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"0" IsOriginal:YES ArticleId:@"0"];
                    }

                }
                else
                {
                    [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"0" IsOriginal:YES ArticleId:@"0"];
                }
            }
            else
            {
                  
                [self.tableView headerEndRefreshing];
                [self.view hideToastActivity];
            }
            
        }
        else
        {
            //判断数据源中第一个元素是不是banner图
            NSDictionary *dic;
           id  anyS = [self.arrayList firstObject];
           if ([anyS isKindOfClass:[NSArray class]]) {
               dic = [self.arrayList objectAtIndex:1];
           }
           else
           {
               dic = anyS;
           }
            
            NSString *idStr= [dic objectForKey:@"id"];
            if (idStr.length > 0) {
            [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"0" IsOriginal:NO ArticleId:[dic objectForKey:@"id"]];
            }
            else
            {
                [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"0" IsOriginal:NO ArticleId:@"0"];
            
            }
        }
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
         {
             [self.view hideToastActivity];
             if (tips.length > 0) {
                 [self.tableView headerEndRefreshing];
                 NSError *error = nil;
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                 if(!error){
                     if([dic[@"errcode"]intValue] == 0){
                         NSMutableArray *picArray = [dic objectForKey:@"banner"];
                         if (picArray.count > 0) {
                             
                             id  anyS = [self.arrayList firstObject];
                             if ([anyS isKindOfClass:[NSArray class]]) {
                                 [self.arrayList removeObjectAtIndex:0];
                             }

                             
                             self.arrayBannerPics =  [dic objectForKey:@"banner"];
                             NSMutableArray *CArray= [dic objectForKey:@"data"];
                             //插入新闻
                             NSMutableArray * dicArray;
                             dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                             NSMutableArray *dataA = [self ArrayCompare:CArray];
                             [dataA addObjectsFromArray:dicArray];
                             self.arrayList = dataA;
                             //插入banner图
                             dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                             [dicArray insertObject:self.arrayBannerPics atIndex:0];
                             self.arrayList = [NSMutableArray  arrayWithArray:dicArray];
                               
                             self.UpLoadNews = NO;
                             [self.tableView reloadData];
                            

                         }
                         else
                         {
                            // self.arrayBannerPics = [[NSMutableArray alloc]init];
                             NSArray *picArray ;
                             id  anyS = [self.arrayList firstObject];
                             if ([anyS isKindOfClass:[NSArray class]]) {
                                 picArray = anyS;
                                 [self.arrayList removeObjectAtIndex:0];
                                 //排序
                                 NSMutableArray *CArray= [dic objectForKey:@"data"];
                                 //插入新闻
                                 NSMutableArray * dicArray;
                                 dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                                 NSMutableArray *dataA = [self ArrayCompare:CArray];
                                 [dataA addObjectsFromArray:dicArray];
                                 [dataA insertObject:picArray atIndex:0];
                                 self.arrayList = dataA;
                                 self.UpLoadNews = NO;
                                   
                                 [self.tableView reloadData];
                             }
                             else
                             {
                                 //排序
                                 NSMutableArray *CArray= [dic objectForKey:@"data"];
                                 //插入新闻
                                 NSMutableArray * dicArray;
                                 dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                                 NSMutableArray *dataA = [self ArrayCompare:CArray];
                                 [dataA addObjectsFromArray:dicArray];
                                 self.arrayList = dataA;
                                 self.UpLoadNews = NO;
                                   
                                 [self.tableView reloadData];
                             }
                               

                         }
                     }else {
                         [self.view makeToast:[dic objectForKey:@"errmsg"]];
                           

                     }
                     
                 }
             }
             else
             {
                 [self.tableView headerEndRefreshing];
                 [self.view makeToast:@"网络异常"];
                   

             }
         }];
        
    
    }
    
        self.isCanResh  = YES;
}

#pragma mark - **********************上拉刷新
-(void)loadMoreData
{
#warning 传最后一个id  添加参数是添加到最后一个元素
    
    
    __weak FCXRefreshFooterView *weakFooterView = footerView;
    
    HomeRequest *request = [HomeRequest new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    //self.userInfoModel.userKey - self.userInfoModel.userKey
    if (self.tTapy == 1) {
        if (self.SegIndex == 0)
        {
            NSDictionary *dic = [self.arrayList lastObject];
            NSString *idStr= [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            if (idStr.length > 0) {
                [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"1" IsOriginal:YES ArticleId:[dic objectForKey:@"id"]];
            }
            else
            {
                [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"1" IsOriginal:YES ArticleId:@"0"];
            }
            
            
            
        }
        else
        {
            [weakFooterView endRefresh];
            
            [self.view hideToastActivity];
        }
        
    }
    else
    {
        NSDictionary *dic = [self.arrayList lastObject];
        NSString *idStr= [dic objectForKey:@"id"];
        if (idStr.length > 0) {
        [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"1" IsOriginal:NO ArticleId:[dic objectForKey:@"id"]];
        }
        else
        {
            [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ID RequestTapy:@"1" IsOriginal:NO ArticleId:@"0"];
        }
    }
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
     {
         [weakFooterView endRefresh];
         [self.view hideToastActivity];
         if (tips.length > 0) {
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
             if(!error){
                 if([dic[@"errcode"]intValue] == 0){
                    
                    NSMutableArray *CArray= [dic objectForKey:@"data"];
                     if (CArray.count < 1) {
//                         UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                         [window makeToast:@"没有新闻请查看其他!"];
                         return ;
                     }
                     NSMutableArray *dataA = [self ArrayCompare:CArray];
                     NSMutableArray * dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                     [dicArray addObjectsFromArray:dataA];
                     self.arrayList = dicArray;
                     self.UpLoadNews = NO;
                     [self.tableView reloadData];
                     
                 }else {
                     [weakFooterView endRefresh];
                     [self.view makeToast:[dic objectForKey:@"errmsg"]];
                 }
                 
             }
         }
         else
         {
             [weakFooterView endRefresh];
             [self.view makeToast:@"网络异常"];
             
         }
     }];
    
    
}
#pragma mark - **********************求请求原创分类
-(void)RequestOriginalData
{
    [self.view makeToastActivity];
    HomeRequest *request = [HomeRequest new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    //self.userInfoModel.userKey - self.userInfoModel.userKey
    
    [request getJsonForOriginalNews:self.userInfoModel.userKey];//
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
     {
         [self.view hideToastActivity];
         if (tips.length > 0) {
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
             if(!error){
                 if([dic[@"errcode"]intValue] == 0){
                     self.arrayList = [dic objectForKey:@"data"];
                     [self.tableView reloadData];
                 }else {
                     [self.view makeToast:[dic objectForKey:@"errmsg"]];
                 }
                 
             }
         }
         else
         {
             
             [self.view makeToast:@"网络异常"];
             
         }
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if(self.tableView.contentOffset.y+ (self.tableView.frame.size.height)
//       > self.tableView.contentSize.height-200){
//        if (self.arrayList.count > 0) {
//            NSDictionary *dic = [self.arrayList lastObject];
//            NSString *IDStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
//            if (![_RepeatArray containsObject:IDStr]) {
//                [_RepeatArray addObject:IDStr];
//                [self loadMoreData];
//            }
//            else
//            {
//                [_RepeatArray removeObject:IDStr];
//            }
//        }
//    }
//    
//}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (self.tTapy == 1) {
        return self.arrayList.count + 1;
    }
    else
    return self.arrayList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //---------------------------------------原创新闻
    if (self.tTapy == 1) {
        
        if (indexPath.row == 0) {
             NSString *ID  = @"ClassTabCell";
             NewsTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.SVC = self;
            cell.delegate = self;
            return cell;
        }
        if (self.SegIndex == 1) {
            //--------------------------------分类列表
            NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row -1 ];
            NSString *ID  = @"RecommendTabCell";
            NewsTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.CDataDic = dic;
            cell.delegate = self;
            return cell;
        }
        else
        {
             //--------------------------------推荐列表
            NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row -1 ];
            NSString *ID = [NewsTableViewCell idForRecommendRows:dic];
            NewsTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.delegate  = self;
            NSInteger Cycletag = indexPath.row %3;
            switch (Cycletag) {
                case 0:
                {
                    [cell.ShowColorImg setImage:[UIImage imageNamed:@"groom_tipblue"]];
                }
                    break;
                case 1:
                {
                    [cell.ShowColorImg setImage:[UIImage imageNamed:@"groom_tipbluet"]];
                }
                    break;
                case 2:
                {
                    [cell.ShowColorImg setImage:[UIImage imageNamed:@"groom_tipred"]];
                }
                    break;
                    
                default:
                    break;
            }
            cell.RDataDic = dic;
            return cell;
            
        }
        
    }
    else
    {
        //---------------------------------------普通新闻
        NSString *ID;
        NewsTableViewCell * cell;
       // NSLog(@"self.arraylist.count--- %lu, index.row----%ld",(unsigned long)self.arrayList.count,(long)indexPath.row);
        id  anyS = [self.arrayList objectAtIndex:indexPath.row ];
        if ([anyS isKindOfClass:[NSArray class]]) {
            
            ID = [NewsTableViewCell idForRow:nil IsHashBanner:YES];
            cell = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.PicArray = anyS;
            cell.SVC = self;
        }
        else
        {
            
            NSDictionary *newsModel = (NSDictionary *)anyS;
            ID = [NewsTableViewCell idForRow:newsModel IsHashBanner:NO];
            cell = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.DataDic = newsModel;
        }
        return cell;
    }
    
  
    
   
}
#pragma mark - ********************CellDelegate
-(void)DoSomethingChange:(NSInteger)SeIndex
{
    self.SegIndex = SeIndex;
    //请求最新的
    if (SeIndex == 0) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        self.arrayList = [userDef objectForKey:@"DataArray"];
        [userDef removeObjectForKey:@"DataArray"];
        [userDef synchronize];
         footerView.hidden = NO;
        [self.tableView reloadData];
    }
    else
    {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef  setObject:self.arrayList forKey:@"DataArray"];
        [userDef synchronize];
         footerView.hidden = YES;
        [self RequestOriginalData];
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
    
     if (self.tTapy == 1) {
         
         if (indexPath.row == 0) {
             
         }
         else
         {
             if (self.SegIndex == 1) {
                 //--------------------------------跳转原创分类二级页面
                NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row-1];
                 ClassTableViewController *cvc = [[ClassTableViewController alloc]init];
                 NSInteger ids = [[dic objectForKey:@"id"] integerValue];
                 cvc.ClassID = [NSString stringWithFormat:@"%ld",(long)ids];
                 cvc.TitleStr = [dic objectForKey:@"name"];
                 [self.navigationController pushViewController:cvc animated:YES];
             }
             else
             {
                 NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row-1];
                 NSString *urlStr = [dic objectForKey:@"url"];
                 NewsViewController *vc1 = [[NewsViewController alloc]init];
                 vc1.firestUrl = urlStr;
//                 vc1.isPush = NO;
//                 ;
//                  [self presentViewController:vc1 animated:YES completion:nil];
                 vc1.isPush = YES;
                 vc1.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:vc1 animated:YES];
             }
            
         
         }
     }
    else
    {
        id anyS = [self.arrayList objectAtIndex:indexPath.row];
        if ([anyS isKindOfClass:[NSArray class]]) {
            return;
        }
        else
        {
            NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row];
            
            NSString *urlStr = [dic objectForKey:@"url"];
            if (urlStr.length > 0 ) {
                NewsViewController *vc1 = [[NewsViewController alloc]init];
                vc1.firestUrl = urlStr;
//                vc1.isPush = NO;
//                [self presentViewController:vc1 animated:YES completion:nil];
                vc1.isPush = YES;
                vc1.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc1 animated:YES];
            }
        
        }
       
    }
    
    
  

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.tTapy == 1) {
       
        if (indexPath.row == 0) {
            
            return 60;
        }
        if (self.SegIndex == 1) {
            //--------------------------------分类列表
            return 50;
        }
        else
        {
            NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row-1 ];
            CGFloat rowHeight = [NewsTableViewCell heightForRecommendRow:dic];
            
            return rowHeight;
        }
        
       
    }
    else{
    
    id  anyS = [self.arrayList objectAtIndex:indexPath.row ];
    CGFloat rowHeight;
    if ([anyS isKindOfClass:[NSArray class]]) {
         rowHeight = [NewsTableViewCell
                              heightForRow:nil IsHashBanner:YES];
       
    }
    else
    {
        NSDictionary *newsModel = (NSDictionary *)anyS;
        rowHeight = [NewsTableViewCell
                     heightForRow:newsModel IsHashBanner:NO];
    }
     return rowHeight;
    
    }
    

}

#pragma mark - ******************************数组倒序
-(NSMutableArray *)ArrayCompare:(NSMutableArray *)DataArray
{
    NSMutableArray *backArray = [NSMutableArray arrayWithArray:DataArray];
    NSSortDescriptor *delay = [NSSortDescriptor sortDescriptorWithKey:@"id.integerValue" ascending:NO];
    [backArray sortUsingDescriptors:[NSArray arrayWithObject:delay]];
    
    return backArray;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
