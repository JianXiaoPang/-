//
//  NewsTableViewCell.m
//  Sharing
//
//  Created by huangchengqi on 15/9/23.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "NewsTableViewCell.h"
#import "SDCycleScrollView.h"
#import "WebViewController.h"
#import "EditorWebViewController.h"
#import "NewsViewController.h"
@interface NewsTableViewCell ()<SDCycleScrollViewDelegate>

//轮播
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *tilArray;
@property(nonatomic,strong)NSMutableArray *urlArray;
@property(nonatomic,strong)FenXiangUserInfoModel *userInfoModel;

/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/** 描述 */
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitles;
/** 第二张图片（如果有的话）*/
@property (weak, nonatomic) IBOutlet UIImageView *imgOther1;
/** 第三张图片（如果有的话）*/
@property (weak, nonatomic) IBOutlet UIImageView *imgOther2;
/** 收藏人数 */
@property (weak, nonatomic) IBOutlet UIButton *CollectPersonLabel;
/** 参与人数 */
@property (weak, nonatomic) IBOutlet UIButton *ParticipatePersonLabel;

#pragma mark - *******************************************************


#pragma mark - *****推荐
/** 文章headerView */
@property (weak, nonatomic) IBOutlet UIView *HeaderView;
/** 文章BottomView */
@property (weak, nonatomic) IBOutlet UIView *BottomView;


/** 文章标题 */
@property (weak, nonatomic) IBOutlet UILabel *ArticleTitleLabel;

/** 文章内容图 */
@property (weak, nonatomic) IBOutlet UIImageView *ShowArticleImg;
/** 文章副标题内容 */
@property (weak, nonatomic) IBOutlet UILabel *SubtitleLabel;
/** 作者标题内容 */
@property (weak, nonatomic) IBOutlet UIButton *AuthorTitleBtn;
/** 点赞数 */
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
/** 阅读数 */
@property (weak, nonatomic) IBOutlet UIButton *readsBtn;

#pragma mark - *****分类

/** 分类HeaderImg */
@property (weak, nonatomic) IBOutlet UIImageView *RHeaderImg;
/** 分类标题 */
@property (weak, nonatomic) IBOutlet UILabel *RTitle;

@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.HeaderView.layer setBorderColor:[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f].CGColor];
    self.HeaderView.layer.borderWidth = 1.0f;
    
    [self.BottomView.layer setBorderColor:[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f].CGColor];
    self.BottomView.layer.borderWidth = 1.0f;
    
    
}
#pragma mark - **************************************************** 分类推荐区域
//分段切换事件
- (IBAction)SwitchingClick:(UISegmentedControl *)sender {
     SeIndex = sender.selectedSegmentIndex;
    [_delegate DoSomethingChange:SeIndex];
    
}
//写文章
- (IBAction)WriteBtn:(UIButton *)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
    
    
    NewsViewController *edvc = [[NewsViewController alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.jlxmt.com/jlonghtml/UserCenter/Original/Edit.html?wid=2&key=%@",self.userInfoModel.userKey];
    edvc.firestUrl = urlStr;
    edvc.isPush = YES;
    edvc.hidesBottomBarWhenPushed = YES;
    [self.SVC.navigationController pushViewController:edvc animated:YES];
    
}

#pragma mark - ****************推荐页
-(void)setRDataDic:(NSDictionary *)RDataDic
{
    _RDataDic = RDataDic;
    /*
     author 作者
     hits 阅读
     id 文章id
     info 副标题
     love 点赞
     name 标题
     pic 大图
     url webview的url
     */
    self.ArticleTitleLabel.text = [_RDataDic objectForKey:@"name"];
    [self.ShowArticleImg sd_setImageWithURL:[RDataDic objectForKey:@"pic"] placeholderImage:nil];
    self.SubtitleLabel.text = [NSString stringWithFormat:@" %@",[_RDataDic objectForKey:@"info"]];
    [self.AuthorTitleBtn setTitle:[_RDataDic objectForKey:@"author"] forState:UIControlStateNormal];
    [self.AuthorTitleBtn setTitle:[_RDataDic objectForKey:@"author"] forState:UIControlStateHighlighted];
    
    
    CGFloat count1 =  [self.RDataDic[@"love"] intValue];
    NSString *displayCount1;
    if (count1 > 10000) {
        displayCount1 = [NSString stringWithFormat:@"赞%.1f",count1/10000];
    }else{
        displayCount1 = [NSString stringWithFormat:@"赞%.0f",count1];
    }
    [self.likesBtn setTitle:displayCount1 forState:UIControlStateNormal];
    [self.likesBtn setTitle:displayCount1 forState:UIControlStateHighlighted];
    
    
    
    CGFloat count2 =  [self.RDataDic[@"hits"] intValue];
    NSString *displayCount2;
    if (count2 > 10000) {
        displayCount2 = [NSString stringWithFormat:@"阅读%.1f",count2/10000];
    }else{
        displayCount2 = [NSString stringWithFormat:@"阅读%.0f",count2];
    }
    [self.readsBtn setTitle:displayCount2 forState:UIControlStateNormal];
    [self.readsBtn setTitle:displayCount2 forState:UIControlStateHighlighted];
    
}

+ (NSString *)idForRecommendRows:(NSDictionary *)DataDic 
{
    
    NSString *pic = [DataDic objectForKey:@"pic"];
    if (pic.length > 0) {
        return @"ArticleImgTabCell";
    }
    else
    {
        return @"ArticleTabCell";
    }
    
}
+ (CGFloat)heightForRecommendRow:(NSDictionary *)DataDIc
{
    NSString *pic = [DataDIc objectForKey:@"pic"];
    if (pic.length > 0) {
        return 324;
    }
    else
    {
        return 146;
    }
}

#pragma mark - ****************分类页
-(void)setCDataDic:(NSDictionary *)CDataDic
{
    _CDataDic = CDataDic;
    [self.RHeaderImg sd_setImageWithURL:[CDataDic objectForKey:@"pic"] placeholderImage:[UIImage imageNamed:@"sort_moneyicon"]];
    self.RTitle.text = [CDataDic objectForKey:@"name"];

}

#pragma mark - **************************************************** 新闻区域
-(void)setSVC:(UIViewController *)SVC
{
    _SVC = SVC;
}
/** 轮播图片---需要取值请求图片 */
-(void)setPicArray:(NSArray *)PicArray
{
    _PicArray = PicArray;
    /*
      pic;
     title;
      url;
     */
    
    NSMutableArray *PIC = [[NSMutableArray alloc]init];
    NSMutableArray *Til = [[NSMutableArray alloc]init];
    NSMutableArray *Url = [[NSMutableArray alloc]init];
    NSMutableArray *picArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _PicArray) {
        [PIC addObject:[dic objectForKey:@"pic"]];
        [Til addObject:[dic objectForKey:@"title"]];
        [Url addObject:[dic objectForKey:@"url"]];
        NSString *urlStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pic"]];
        if (urlStr.length < 1) {
            
            return ;
        }
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        dispatch_queue_t queue =dispatch_queue_create("loadImage",NULL);
        dispatch_async(queue, ^{
            
            NSData *resultData = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:resultData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (img) {
                    [picArr addObject:img];
                }
                else
                {
                    [self.SVC.view makeToast:@"网络异常!"];
                }
                
                if (picArr.count == _PicArray.count) {
                    _imgArray  = [[NSMutableArray alloc]initWithArray:picArr];
                    _tilArray  = [[NSMutableArray alloc]initWithArray:Til];
                    _urlArray  = [[NSMutableArray alloc]initWithArray:Url];
                    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kDeviceWidth, 244) imagesGroup:_imgArray];
                    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
                    cycleScrollView2.delegate = self;
                    cycleScrollView2.titlesGroup = _tilArray;
                    cycleScrollView2.autoScrollTimeInterval = 2.0;
                    cycleScrollView2.backgroundColor = [UIColor whiteColor];
                    [self.contentView addSubview:cycleScrollView2];
                    
                }
                
            });
            
        });
    }
    
}
#pragma mark - ****************SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.urlArray.count > 0) {
        id  urlStr = [self.urlArray objectAtIndex:index];
        if (![urlStr isKindOfClass:[NSNull class]]) {
             NSString *urlStr = [self.urlArray objectAtIndex:index];
            NewsViewController *vc1 = [[NewsViewController alloc]init];
            vc1.firestUrl = urlStr;
            vc1.isPush = YES;
            vc1.hidesBottomBarWhenPushed = YES;
            [_SVC.navigationController pushViewController:vc1 animated:YES ];
        }
    }
    
}


#pragma mark - ****************内容cell赋值

-(void)setDataDic:(NSDictionary *)DataDic
{
    _DataDic = DataDic;
    
    
//    NSLog(@"展示图片----%@",self.NewsModel.pics);
    NSArray *imgArray = [NSArray arrayWithArray:self.DataDic[@"pics"]];
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:[imgArray firstObject]] placeholderImage:[UIImage imageNamed:@"egister_logginicon"]];
    self.lblTitle.text = self.DataDic[@"name"];
    self.lblSubtitles.text = self.DataDic[@"info"];
    
    // 如果回复太多就改成几点几万
    CGFloat count =  [self.DataDic[@"hits"] intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"阅读%.1f",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"阅读%.0f",count];
    }
    [self.ParticipatePersonLabel setTitle:displayCount forState:UIControlStateNormal];
    [self.ParticipatePersonLabel setTitle:displayCount forState:UIControlStateHighlighted];
    
    
    CGFloat count1 =  [self.DataDic[@"love"] intValue];
    NSString *displayCount1;
    if (count1 > 10000) {
        displayCount1 = [NSString stringWithFormat:@"收藏%.1f万人",count1/10000];
    }else{
        displayCount1 = [NSString stringWithFormat:@"收藏%.0f人",count1];
    }
    [self.CollectPersonLabel setTitle:displayCount1 forState:UIControlStateNormal];
    [self.CollectPersonLabel setTitle:displayCount1 forState:UIControlStateHighlighted];
    
    if (imgArray.count == 3) {
        
        [self.imgOther1 sd_setImageWithURL:[NSURL URLWithString:[imgArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"egister_logginicon"]];
        [self.imgOther2 sd_setImageWithURL:[NSURL URLWithString:[imgArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"egister_logginicon"]];
    }



}


#pragma mark - ****************类方法返回可重用的id
+ (NSString *)idForRow:(NSDictionary *)NewsModel IsHashBanner:(BOOL )IsHashBanner
{
    
    if (IsHashBanner == YES) {
        return @"BannerTabCell";
    }
    else
    {
        NSInteger type  = [[NewsModel objectForKey:@"type"] integerValue];
        if (type == 2){
            return @"BigImgTabCell";
        }else if (type == 1){
            return @"ImgTabCell";
        }else{
            return @"ContTabCell";
        }
    
    }

}

#pragma mark - ****************类方法返回行高

+ (CGFloat)heightForRow:(NSDictionary *)NewsModel IsHashBanner:(BOOL )IsHashBanner
{

    if (IsHashBanner == YES) {
        return 245;
    }
    else
    {
         NSInteger type  = [[NewsModel objectForKey:@"type"] integerValue];
        if (type == 2){
                        return 165
            ;
            }else if (type == 1){
                        return 150;
            }else{
                        return 85;
            }
        
    }


}











- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
