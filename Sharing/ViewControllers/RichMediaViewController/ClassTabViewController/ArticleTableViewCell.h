//
//  ArticleTableViewCell.h
//  Sharing
//
//  Created by huangchengqi on 15/9/25.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTableViewCell : UITableViewCell

/** 文章头展示图标 */
@property (weak, nonatomic) IBOutlet UIImageView *ShowColorImg;
/** 文章headerView */
@property (weak, nonatomic) IBOutlet UIView *HeaderView;
/** 文章BottomView */
@property (weak, nonatomic) IBOutlet UIView *BottomView;


/** 文章标题 */
@property (weak, nonatomic) IBOutlet UILabel *ArticleTitleLabel;

/** 文章副标题内容 */
@property (weak, nonatomic) IBOutlet UILabel *SubtitleLabel;
/** 作者标题内容 */
@property (weak, nonatomic) IBOutlet UIButton *AuthorTitleBtn;
/** 点赞数 */
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
/** 阅读数 */
@property (weak, nonatomic) IBOutlet UIButton *readsBtn;

/** 推荐字典 */
@property(nonatomic,strong) NSDictionary *RDataDic;

@end
