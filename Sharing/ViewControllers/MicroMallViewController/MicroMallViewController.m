//
//  MicroMallViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "MicroMallViewController.h"

@interface MicroMallViewController ()

@end

@implementation MicroMallViewController
- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.frame = CGRectMake(0, KDeviceHeight-tabbarHeight, kDeviceWidth, tabbarHeight);
    self.tabBarController.tabBar.hidden = NO;
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDlg.isLoadWebViewString = @"N";
    self.navigationController.navigationBarHidden = NO;
    
    
}
- (void)MyLevelStore {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDlg.isLoadWebViewString isEqualToString:@"N"]){
        NSString* string = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"mylevel_url"]];
        
        NewsViewController *vc1 = [[NewsViewController alloc]init];
//        appDlg.isLoadWebViewString = @"Y";
        vc1.firestUrl = string;
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (void)MoreBrands {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDlg.isLoadWebViewString isEqualToString:@"N"]){
        NSString* string = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"ppurl"]];
        
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = string;
//        appDlg.isLoadWebViewString = @"Y";
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (void)redArticle:(NSNotification *)notic {
    
}
- (void)optionstore:(NSNotification *)notic {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDlg.isLoadWebViewString isEqualToString:@"N"]){
        
        NSString* string = notic.object;
        NSString *urlStr;
        if(string.intValue == 0){
            urlStr = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"shop_url"]];
        }else if(string.intValue == 1){
            urlStr = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"order_url"]];
        }else if(string.intValue == 2){
            urlStr = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"statistics_url"]];
        }else if(string.intValue == 3){
            urlStr = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"discount_url"]];
        }
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
//        appDlg.isLoadWebViewString = @"Y";
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //标题
    self.navigationItem.title = @"微电商";
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionstore:) name:@"optionsStore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redArticle:) name:@"redArticle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoreBrands) name:@"MoreBrands" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyLevelStore) name:@"MyLevelStore" object:nil];
    microMallTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, viewWidth, self.view.height-64-49)];
    microMallTableView.backgroundColor = [UIColor whiteColor];
    microMallTableView.delegate = self;
    microMallTableView.dataSource = self;
    microMallTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:microMallTableView];
    [self createHeaderView];
    picArray = [[NSMutableArray alloc]init];
    
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDlg.isLoadWebViewString = @"N";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        MicroMallReqeust *request = [MicroMallReqeust new];
        [MBProgressHUD showHUDAddedTo:microMallTableView animated:YES];
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
            [MBProgressHUD hideHUDForView:microMallTableView animated:YES];
            if(isSucceed){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                NSMutableArray* array = [dic objectForKey:@"data"];
                [self reloadData:[dic objectForKey:@"info"] array:array];
                
            }else{
                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
            }
        }];
        [request requestMicroMall:userModel.userKey];
    }
}
- (void)reloadData:(NSDictionary *)daDict array:(NSMutableArray *)array{
    dataDict = daDict;
    [picArray addObjectsFromArray:array];
    [microMallTableView reloadData];
    [self testFinishedLoadData];
//    [self performSelector:@selector(dataFinishedLoadData) withObject:nil afterDelay:0.0f];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDlg.isMicroReBOOL){
        return [picArray count]+2;
    }else {
        return [picArray count]+1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MicroMallTableViewCell *cell = [MicroMallTableViewCell getInstance];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadCell:viewWidth indexRow:indexPath.row dataDict:dataDict dataArray:picArray];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 0){
        NSString* string = [NSString stringWithFormat:@"%@",[[picArray objectAtIndex:indexPath.row-1] objectForKey:@"url"]];
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = string;
        vc1.isMirco = @"Y";
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 358;
    }else if(indexPath.row == picArray.count+1){
        return 30;
    }else{
        return 68+(int)((viewWidth-24)/375*195)+20;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UITableView* table = microMallTableView;
    if(table) {
        CGPoint contentOffsetPoint = microMallTableView.contentOffset;
        CGRect frame = microMallTableView.frame;
        if (contentOffsetPoint.y == microMallTableView.contentSize.height - frame.size.height || microMallTableView.contentSize.height < frame.size.height) {
            AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if(appDlg.isMicroReBOOL){
                [self getNextPageView];
            }
        }else {
            if (_refreshHeaderView)
            {
                [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
            }
        }
    }
}
//加载调用的方法
-(void)getNextPageView
{
    if(picArray.count != 0){
        AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MicroMallReqeust *request = [MicroMallReqeust new];
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
            if(isSucceed){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                NSArray* array = [dic objectForKey:@"data"];
                if(array.count == 0){
                    appDlg.isMicroReBOOL = NO;
                }else {
                    appDlg.isMicroReBOOL = YES;
                }
                for(long int i=0;i<array.count;i++){
                    NSDictionary* di = [array objectAtIndex:i];
                    [picArray addObject:di];
                }
                [microMallTableView reloadData];
            }else{
                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
            }
        }];
        [request requestmerchantlist:userModel.userKey meId:[[picArray objectAtIndex:picArray.count-1] objectForKey:@"id"] type:@"1" limt:@"5"];
    }
    
}
//刷新调用的方法
-(void)refreshView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    MicroMallReqeust *request = [MicroMallReqeust new];
    [MBProgressHUD showHUDAddedTo:microMallTableView animated:YES];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
        [MBProgressHUD hideHUDForView:microMallTableView animated:YES];
        if(isSucceed){
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            NSArray* array = [dic objectForKey:@"data"];
            for(long int i=array.count-1;i>=0;i--){
                NSDictionary* di = [array objectAtIndex:i];
                [picArray insertObject:di atIndex:0];
            }
            [microMallTableView reloadData];
            [self testFinishedLoadData];
            
        }else{
            [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
        }
    }];
    [request requestmerchantlist:userModel.userKey meId:[[picArray objectAtIndex:0] objectForKey:@"id"] type:@"0" limt:@"5"];
}
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:microMallTableView];
    }
}
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [microMallTableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
    [self finishReloadingData];
}
#pragma mark -
#pragma mark method that should be called when the refreshing is finished
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
    // overide, the actual loading data operation is done in the subclass
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    
    [self beginToReloadData:aRefreshPos];
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
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
