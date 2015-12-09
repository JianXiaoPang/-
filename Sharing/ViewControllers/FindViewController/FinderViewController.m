//
//  FinderViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "FinderViewController.h"
#import "WebViewController.h"
@interface FinderViewController ()

@end

@implementation FinderViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDlg.isLoadWebViewString = @"N";
    
}
- (void)clickFinderTopPic:(NSNotification *)notic {
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDlg.isLoadWebViewString isEqualToString:@"N"]){
//        appDlg.isLoadWebViewString = @"Y";
        NSString* string = notic.object;
        NSString* urlStr;
        urlStr = [NSString stringWithFormat:@"%@",[[topArray objectAtIndex:string.intValue] objectForKey:@"url"]];
        
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"发现";
    self.navigationItem.hidesBackButton = YES;
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickFinderTopPic:) name:@"clickFinderTopPic" object:nil];
//    float naviConHeight=self.navigationController.navigationBar.frame.size.height;
    findDataArray = [[NSMutableArray alloc]init];
    topArray = [[NSMutableArray alloc]init];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight-64-49)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    finderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, viewWidth, self.view.height-64-49)];
    finderTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    finderTableView.delegate = self;
    finderTableView.dataSource = self;
    finderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:finderTableView];
    [self createHeaderView];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        FinderRequest *request = [FinderRequest new];
        [MBProgressHUD showHUDAddedTo:finderTableView animated:YES];
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
            [MBProgressHUD hideHUDForView:finderTableView animated:YES];
            if(isSucceed){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                NSArray* array = [dic objectForKey:@"data"];
                [self reloadData:[dic objectForKey:@"banner"] arArray:array];
                
            }else{
                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
            }
        }];
        [request requestFinder:userModel.userKey meId:@"0" type:@"0" limt:@"10"];
    }
}
- (void)reloadData:(NSArray *)pic arArray:(NSArray *)array {
    [topArray addObjectsFromArray:pic];
    [findDataArray addObjectsFromArray:array];
    [finderTableView reloadData];
    finderTableView.contentOffset = CGPointMake(0, 0);
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(findDataArray.count<10){
        return findDataArray.count+1;
    }
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDlg.isFinderReBOOL == YES){
        return findDataArray.count+2;
    }else {
        return findDataArray.count+1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinderTableViewCell *cell = [FinderTableViewCell getInstance];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadcell:topArray arArray:findDataArray width:viewWidth indexRow:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >0) {
        NSString* urlStr;
        urlStr = [NSString stringWithFormat:@"%@",[[findDataArray objectAtIndex:indexPath.row-1] objectForKey:@"url"]];
        NewsViewController *vc1 = [[NewsViewController alloc]init];
        vc1.firestUrl = urlStr;
        vc1.isPush = YES;
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 190;
    }else if(indexPath.row == findDataArray.count+1){
        return 30;
    }else {
        return 66;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UITableView* table = finderTableView;
    if(table) {
        CGPoint contentOffsetPoint = finderTableView.contentOffset;
        CGRect frame = finderTableView.frame;
        if(findDataArray.count>=9){
            if (contentOffsetPoint.y == finderTableView.contentSize.height - frame.size.height || finderTableView.contentSize.height < frame.size.height) {
                AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if(appDlg.isFinderReBOOL){
                    [self getNextPageView];
                }
                
            }else {
                
            }
        }
        
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}
//加载调用的方法
-(void)getNextPageView
{
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary* dict = [findDataArray objectAtIndex:findDataArray.count-1];
    FinderRequest *request = [FinderRequest new];
//    [MBProgressHUD showHUDAddedTo:finderTableView animated:YES];
    [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
//        [MBProgressHUD hideHUDForView:finderTableView animated:YES];
        if(isSucceed){
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            NSArray* array = [dic objectForKey:@"data"];
            if(array.count == 0){
                appDlg.isFinderReBOOL = NO;
            }else {
                appDlg.isFinderReBOOL = YES;
            }
            for(long int i=0;i<array.count;i++){
                NSDictionary* di = [array objectAtIndex:i];
                [findDataArray addObject:di];
            }
            
            
            [finderTableView reloadData];
            
        }else{
            [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
        }
    }];
    [request requestFinder:userModel.userKey meId:[dict objectForKey:@"id"] type:@"1" limt:@"10"];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:finderTableView];
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
    
    [finderTableView addSubview:_refreshHeaderView];
    
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

//刷新调用的方法
-(void)refreshView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    if (userModel == nil) {
        userModel = [[FenXiangUserInfoModel alloc]init];
    }else{
        FinderRequest *request = [FinderRequest new];
        [MBProgressHUD showHUDAddedTo:finderTableView animated:YES];
        [request setFinishedBlock:^(BOOL isSucceed, NSString *tips) {
            [MBProgressHUD hideHUDForView:finderTableView animated:YES];
            if(isSucceed){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tips dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                NSArray* array = [dic objectForKey:@"data"];
                NSMutableArray* ar = [[NSMutableArray alloc]init];
                for(long int i=array.count-1;i>=0;i--){
                    NSDictionary* di = [array objectAtIndex:i];
                    [findDataArray insertObject:di atIndex:0];
                }
                [finderTableView reloadData];
                
            }else{
                [GlobalFunction makeToast:tips duration:1.0 HeightScale:0.5];
            }
        }];
        NSDictionary* dict = [findDataArray objectAtIndex:0];
        [request requestFinder:userModel.userKey meId:[dict objectForKey:@"id"] type:@"0" limt:@"10"];
    }
    [self testFinishedLoadData];
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
