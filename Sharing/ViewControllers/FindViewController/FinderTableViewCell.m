//
//  FinderTableViewCell.m
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "FinderTableViewCell.h"

@implementation FinderTableViewCell

+ (instancetype)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FinderTableViewCell" owner:nil options:nil] lastObject];
}
- (void)loadcell:(NSArray *)pic arArray:(NSArray *)array width:(float)width indexRow:(int)indexRow{
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(indexRow == 0){
        NSMutableArray *viewsArray = [@[] mutableCopy];
        for(int i=0;i<pic.count;i++) {
            //背景图片
            UIImageView* imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[pic objectAtIndex:i] objectForKey:@"pic"]]]];
            imageView.frame = CGRectMake(0, 0, width, 190);
            //图片标题
            UIView* transparentView = [[UIView alloc]initWithFrame:CGRectMake(0, 190-22, imageView.frame.size.width, 22)];
            transparentView.backgroundColor = [UIColor blackColor];
            transparentView.alpha = 0.7;
            [imageView addSubview:transparentView];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 190-22, imageView.frame.size.width-10, 22)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%@",[[pic objectAtIndex:i] objectForKey:@"title"]];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            [imageView addSubview:label];
            [viewsArray addObject:imageView];
        }
        CycleScrollView* mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, 190) animationDuration:2];
        mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        mainScorllView.totalPagesCount = ^NSInteger(void){
            return viewsArray.count;
        };
        mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSString* string = [NSString stringWithFormat:@"%ld",(long)pageIndex];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickFinderTopPic" object:string];
        };
        [self addSubview:mainScorllView];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 189, width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
        [self addSubview:lineView];
        
//        UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,0,width, 1)];
//        lineView1.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
//        [self addSubview:lineView1];
    }if(indexRow==array.count+2-1 && array.count>=9 && appDlg.isFinderReBOOL){
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"正在加载中...";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
        
        UIActivityIndicatorView *activityindicatorview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //设置它的显示位置
        activityindicatorview.frame = CGRectMake((width-[self adaptCharacterWidth:@"正在加载中..." height:30])/2-30, (label.frame.size.height-20)/2, 20, 20);
        //开始动画效果
        [activityindicatorview startAnimating];
        //加载到当前view这样就可以显示了。
        [label addSubview:activityindicatorview];
    }else if(indexRow!=0 && array.count+1 != indexRow){
//        NSLog(@"%@",[[array objectAtIndex:indexRow-1] objectForKey:@"id"]);
            UIImageView* imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexRow-1] objectForKey:@"pic"]]]];
            imageView.frame = CGRectMake(12, 9, 48, 48);
            [self addSubview:imageView];
            
            UIImageView* pointImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"index_threep"]];
            pointImageView.frame = CGRectMake(width-12-pointImageView.image.size.width, (66-pointImageView.image.size.height)/2, pointImageView.image.size.width, pointImageView.image.size.height);
            [self addSubview:pointImageView];
            
            UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(24+imageView.frame.size.width, 15, width-(24+imageView.frame.size.width+12+pointImageView.image.size.width), 16)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = [NSString stringWithFormat:@"%@",[[array objectAtIndex:indexRow-1] objectForKey:@"name"]];
            titleLabel.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
            titleLabel.font = [UIFont systemFontOfSize:16];
            [self addSubview:titleLabel];
            
            UILabel* introLabel = [[UILabel alloc]initWithFrame:CGRectMake(24+imageView.frame.size.width, titleLabel.bottom+5, width-(24+imageView.frame.size.width+12+pointImageView.image.size.width), 13)];
            introLabel.backgroundColor = [UIColor clearColor];
            introLabel.text = [NSString stringWithFormat:@"%@",[[array objectAtIndex:indexRow-1] objectForKey:@"info"]];
            introLabel.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1];
            introLabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:introLabel];
            
            UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, width, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
            [self addSubview:lineView];
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(float)adaptCharacterWidth:(NSString*)characterString height:(float)widthCharacter{
    float sizeFloat;
    sizeFloat = 14.5;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:sizeFloat]};
    CGSize size = [characterString boundingRectWithSize:CGSizeMake(0, widthCharacter) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
