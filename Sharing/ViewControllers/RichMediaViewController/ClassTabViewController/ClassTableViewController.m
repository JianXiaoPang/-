//
//  ClassTableViewController.m
//  Sharing
//
//  Created by huangchengqi on 15/9/25.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "ClassTableViewController.h"
#import "HomeRequest.h"
#import "MJRefresh.h"
#import "ArticleImgTableViewCell.h"
#import "ArticleTableViewCell.h"
#import "NewsViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface ClassTableViewController ()<EGORefreshTableDelegate>
{

    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //
    BOOL _reloading;
    //table 脚部视图
    FCXRefreshFooterView *footerView;

}

@property(nonatomic,assign)BOOL update;
/** 数据源 */
@property(nonatomic,strong) NSMutableArray *arrayList;
@property(nonatomic,strong)FenXiangUserInfoModel *userInfoModel;
/** 防止提前上拉刷新 */
@property (nonatomic ,assign)BOOL isCanResh;
@end


@implementation ClassTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
   
    [self.view makeToastActivity];
    HomeRequest *request = [HomeRequest new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    //self.userInfoModel.userKey - self.userInfoModel.userKey
    
    [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ClassID RequestTapy:@"0" IsOriginal:YES ArticleId:@"0"];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
     {
         [self.view hideToastActivity];
         if (tips.length > 0) {
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
             if(!error){
                 if([dic[@"errcode"]intValue] == 0){
                     NSMutableArray *picArray = [dic objectForKey:@"data"];
                     if (picArray.count > 0) {
                         
                         NSMutableArray *CArray= [dic objectForKey:@"data"];
                         self.arrayList = [self ArrayCompare:CArray];
                         [self.tableView reloadData];
                     }
                     else
                     {
                         _isCanResh = NO;
                         [self.view makeToast:@"该分类没有新闻!"];
                     }
                     
                 }else {
                     _isCanResh = NO;
                     [self.view makeToast:[dic objectForKey:@"errmsg"]];
                 }
             }
         }
         else
         {
             //[self.tableView headerEndRefreshing];
             [self.view makeToast:@"网络异常"];
             
         }
     }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    self.navigationController.navigationBarHidden = NO;
    self.title = self.TitleStr;
    [self.tableView addHeaderWithTarget:self action:@selector(loadData)];
    //[self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.update = YES;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [backBtn setImage:[UIImage imageNamed:@"all_lefe"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    __weak __typeof(self)weakSelf = self;
    //上拉加载更多
    footerView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreData];
    }];
    //自动刷新
    footerView.autoLoadMore = NO;
   
}
- (void)doBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --------- 下拉刷新
-(void)loadData
{

    [self.view makeToastActivity];
    HomeRequest *request = [HomeRequest new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    //self.userInfoModel.userKey - self.userInfoModel.userKey
    
   
    NSDictionary *dic = [self.arrayList firstObject];
    [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ClassID RequestTapy:@"0" IsOriginal:YES ArticleId:[dic objectForKey:@"id"]];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
     {
         [self.view hideToastActivity];
         [self.tableView headerEndRefreshing];
         if (tips.length > 0) {
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
             if(!error){
                 if([dic[@"errcode"]intValue] == 0){
                     NSMutableArray *picArray = [dic objectForKey:@"data"];
                     if (picArray.count > 0) {
                         
                         NSMutableArray *CArray= [dic objectForKey:@"data"];
                         NSMutableArray * dicArray;
                         dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                         NSMutableArray *dataA = [self ArrayCompare:CArray];
                         [dataA addObjectsFromArray:dicArray];
                         self.arrayList = dataA;
                         [self.tableView reloadData];
                         
                     }
                     else
                     {
                         [self.view makeToast:@"该分类没有新闻!"];
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
#pragma mark --------- 上拉刷新
-(void)loadMoreData
{
    
    __weak UITableView *weakTableView = self.tableView;
    __weak FCXRefreshFooterView *weakFooterView = footerView;
//    if (_isCanResh == NO) {
//        [weakFooterView endRefresh];
//        return;
//    }
    [self.view makeToastActivity];
    HomeRequest *request = [HomeRequest new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    //self.userInfoModel.userKey - self.userInfoModel.userKey
     NSDictionary *dic = [self.arrayList lastObject];
    [request getJsonForNEWS:self.userInfoModel.userKey ClassID:self.ClassID RequestTapy:@"0" IsOriginal:YES ArticleId:[dic objectForKey:@"id"]];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips)
     {
         [self.view hideToastActivity];
         [weakFooterView endRefresh];
         if (tips.length > 0) {
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
             if(!error){
                 if([dic[@"errcode"]intValue] == 0){
                     NSMutableArray *picArray = [dic objectForKey:@"data"];
                     if (picArray.count > 0) {
                         
                         NSMutableArray *CArray= [dic objectForKey:@"data"];
                         if (CArray.count < 1) {
//                             UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                             [window makeToast:@"没有新闻请查看其他!"];
                             return;
                         }
                         NSMutableArray *dataA = [self ArrayCompare:CArray];
                         NSMutableArray * dicArray = [NSMutableArray arrayWithArray:self.arrayList];
                         [dicArray addObjectsFromArray:dataA];
                         self.arrayList = dicArray;
                         [self.tableView reloadData];

                     }
                     else
                     {
                         
                         
                         [self.view makeToast:@"该分类没有新闻!"];
                     }
                     
                 }else {
                     [self.view makeToast:[dic objectForKey:@"errmsg"]];
                 }
                 
             }
         }
         else
         {
             [weakTableView reloadData];
             [weakFooterView endRefresh];
             [self.view makeToast:@"网络异常"];
             
         }
     }];


}
#pragma mark - ******************************数组倒序
-(NSMutableArray *)ArrayCompare:(NSMutableArray *)DataArray
{
    NSMutableArray *backArray = [NSMutableArray arrayWithArray:DataArray];
    NSSortDescriptor *delay = [NSSortDescriptor sortDescriptorWithKey:@"id.integerValue" ascending:NO];
    [backArray sortUsingDescriptors:[NSArray arrayWithObject:delay]];
    
    return backArray;
}

#pragma mark - Table view data source

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if(tableView.contentOffset.y+ (tableView.frame.size.height)
//       > tableView.contentSize.height-200){
//        if (self.arrayList.count > 0) {
//            [self loadMoreData];
//        }
//    }
//    
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ArticleID";
    NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row];
    NSString *pic = [dic objectForKey:@"pic"];
    if (pic.length > 0) {
       ArticleImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell =  [[[NSBundle mainBundle]loadNibNamed:@"ArticleImgTableViewCell" owner:self options:nil]lastObject];
        }
        cell.RDataDic = dic;
         return cell;
    }
    else
    {
        ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell =  [[[NSBundle mainBundle]loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]lastObject];
        }
        cell.RDataDic = dic;
         return cell;
    
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row];
    NSString *pic = [dic objectForKey:@"pic"];
    if (pic.length > 0) {
        return 324;
    }
    else
    {
        return 146;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.arrayList objectAtIndex:indexPath.row];
    NSString *urlStr = [dic objectForKey:@"url"];
    if (urlStr.length > 0 ) {
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
//        vc1.isPush = NO;
//        [self presentViewController:vc1 animated:YES completion:nil];
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
