//
//  NewsTableViewCell.h
//  Sharing
//
//  Created by huangchengqi on 15/9/23.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "NewsViewController.h"
@protocol NewsTableViewCellDelegate <NSObject>


- (void)DoSomethingChange:(NSInteger) SeIndex;

@end

@interface NewsTableViewCell : UITableViewCell
{
    NSInteger SeIndex;//原创切换
    
}
@property(nonatomic,strong) NewsModel *NewsModel;
@property(nonatomic,strong) NSArray *PicArray;
@property(nonatomic,strong) UIViewController *SVC;
/** 新闻字典 */
@property(nonatomic,strong) NSDictionary *DataDic;

/** 推荐字典 */
@property(nonatomic,strong) NSDictionary *RDataDic;

/** 分类字典 */
@property(nonatomic,strong) NSDictionary *CDataDic;

/** 文章头展示图标 */
@property (weak, nonatomic) IBOutlet UIImageView *ShowColorImg;

/** 推荐分类切换 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *SwitchingSeC;
#pragma mark-----------------新闻
/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(NSDictionary *)NewsModel IsHashBanner:(BOOL )IsHashBanner;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(NSDictionary *)NewsModel IsHashBanner:(BOOL )IsHashBanner;

#pragma mark-----------------推荐
/**
 *  类方法返回可重用的id
 */

+ (NSString *)idForRecommendRows:(NSDictionary *)DataDic;
/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRecommendRow:(NSDictionary *)DataDIc;

#pragma mark-----------------分类



@property (nonatomic, retain) id <NewsTableViewCellDelegate> delegate;

@end
