//
//  ArticleTableViewCell.m
//  Sharing
//
//  Created by huangchengqi on 15/9/25.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "ArticleTableViewCell.h"

@implementation ArticleTableViewCell
- (void)awakeFromNib {
    // Initialization code
    [self.HeaderView.layer setBorderColor:[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f].CGColor];
    self.HeaderView.layer.borderWidth = 1.0f;
    
    [self.BottomView.layer setBorderColor:[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f].CGColor];
    self.BottomView.layer.borderWidth = 1.0f;
    
}
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
    NSString *picStr = [RDataDic objectForKey:@"pic"];
    
   
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
