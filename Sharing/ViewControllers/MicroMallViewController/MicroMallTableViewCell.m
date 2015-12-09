//
//  MicroMallTableViewCell.m
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "MicroMallTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MicroMallTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MicroMallTableViewCell" owner:nil options:nil] lastObject];
}
- (void)loadCell:(float)width indexRow:(int)indexRow dataDict:(NSDictionary *)dataDict dataArray:(NSMutableArray *)dataArray{
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    daArray = dataArray;
    if(indexRow == 0) {
        self.contentView.backgroundColor =[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        //头像
        UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 265)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        UIView* headView = [[UIView alloc]initWithFrame:CGRectMake((width-85)/2,18, 85, 85)];
        headView.backgroundColor = [UIColor colorWithRed:252/255.0 green:241/255.0 blue:225/255.0 alpha:1];
        [bgView addSubview:headView];
        
        UIImageView* headImageView = [[UIImageView alloc]init];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"headimgurl"]]]];
        headImageView.frame = CGRectMake(5, 5, headView.frame.size.width-10, headView.frame.size.height-10);
        [headView addSubview:headImageView];
        [self calyer:headView sizeFloat:headView.frame.size.width/2];
        [self calyer:headImageView sizeFloat:headImageView.frame.size.width/2];
        //掌柜
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, headView.bottom+12, width-20, 17)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"uname"]];
        nameLabel.textColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:0/255.0 alpha:1];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:17];
        [bgView addSubview:nameLabel];
        
        //店铺
        UILabel* storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel.bottom+11, width-20, 14)];
        storeLabel.backgroundColor = [UIColor clearColor];
        storeLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"vname"]];;
        storeLabel.textColor = [UIColor colorWithRed:255/255.0 green:161/255.0 blue:50/255.0 alpha:1];
        storeLabel.textAlignment = NSTextAlignmentCenter;
        storeLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:storeLabel];
        
        UIButton* storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [storeButton setBackgroundColor:[UIColor clearColor]];
        [storeButton setFrame:CGRectMake((width-[self adaptCharacterWidth:[dataDict objectForKey:@"vname"] height:15])/2, nameLabel.bottom+11, [self adaptCharacterWidth:[dataDict objectForKey:@"vname"] height:15], storeLabel.frame.size.height)];
        [storeButton addTarget:self action:@selector(pressMyLevelStore) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:storeButton];
        
        UIButton* boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [boxButton setBackgroundColor:[UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1]];
        [boxButton setFrame:CGRectMake((width-100)/2, storeLabel.bottom+14, 100, 20)];
        boxButton.backgroundColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1];
        [boxButton addTarget:self action:@selector(pressActingMoreBrands) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:boxButton];
        
        //代理
        UILabel* moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, boxButton.frame.size.width-2, boxButton.frame.size.height-2)];
        moreLabel.backgroundColor = [UIColor whiteColor];
        moreLabel.text = @"代理更多品牌";
        moreLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1];
        moreLabel.textAlignment = NSTextAlignmentCenter;
        moreLabel.font = [UIFont systemFontOfSize:13];
        [boxButton addSubview:moreLabel];
        
        [self lineView:bgView left:0 top:boxButton.bottom+25 width:width height:1];
        NSArray* monArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"money"]],[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"total"]], nil];
        NSArray* array = [NSArray arrayWithObjects:@"月收入:",@"总收入:",nil];
        for(int i=0;i<2;i++) {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0+(width)/2*i, boxButton.bottom+26, width/2, 48)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(presIncome:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [bgView addSubview:button];
            
            NSString* st = [NSString stringWithFormat:@"%@",[monArray objectAtIndex:i]];
            
            AttributedLabel* label = [[AttributedLabel alloc]initWithFrame:CGRectMake((button.frame.size.width-[self adaptCharacterWidth:[NSString stringWithFormat:@"%@%@元",[array objectAtIndex:i],[monArray objectAtIndex:i]] height:14])/2, 0, [self adaptCharacterWidth:[NSString stringWithFormat:@"%@%@元",[array objectAtIndex:i],[monArray objectAtIndex:i]] height:14], button.frame.size.height/2+7)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%@%@元",[array objectAtIndex:i],[monArray objectAtIndex:i]];
            [label setColor:[UIColor colorWithRed:61/255.0 green:67/255.0 blue:69/255.0 alpha:1] fromIndex:0 length:4];
            [label setFont:[UIFont systemFontOfSize:14] fromIndex:0 length:4];
            if(i==0){
                [label setColor:[UIColor colorWithRed:251/255.0 green:74/255.0 blue:50/255.0 alpha:1] fromIndex:4 length:st.length];
                [label setFont:[UIFont systemFontOfSize:14] fromIndex:4 length:st.length];
            }else if(i == 1){
                [label setColor:[UIColor colorWithRed:98/255.0 green:192/255.0 blue:22/255.0 alpha:1] fromIndex:4 length:st.length];
                [label setFont:[UIFont systemFontOfSize:14] fromIndex:4 length:st.length];
            }
            [label setColor:[UIColor colorWithRed:61/255.0 green:67/255.0 blue:69/255.0 alpha:1] fromIndex:label.text.length-1 length:1];
            [label setFont:[UIFont systemFontOfSize:14] fromIndex:label.text.length-1 length:1];
            label.textAlignment = NSTextAlignmentCenter;
            [button addSubview:label];
        }
            [self lineView:bgView left:width/2+1 top:boxButton.bottom+36 width:1 height:32];
            
            [self lineView:self left:0 top:boxButton.bottom+74 width:width height:1];
        
            [self lineView:self left:0 top:boxButton.bottom+86 width:width height:1];
            
            UIView* orderView = [[UIView alloc]initWithFrame:CGRectMake(0, boxButton.bottom+87, width, 68)];
            orderView.backgroundColor = [UIColor whiteColor];
            [self addSubview:orderView];
            
            NSArray* arrayImage = [NSArray arrayWithObjects:@"shop_qing_btn",@"hop_huang_btn",@"hop_hong_btn",@"hop_lan_btn",nil];
            NSArray* arrayTitle = [NSArray arrayWithObjects:@"店铺管理",@"订单管理",@"访客统计",@"一元抢购",nil];
            for(int i=0;i<arrayImage.count;i++) {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setFrame:CGRectMake(0+(width-6)/4*i, 0, (width-6)/4, 68)];
                [button addTarget:self action:@selector(pressOptionsStore:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                [orderView addSubview:button];
                
                UIImageView* stImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrayImage objectAtIndex:i]]]];
                stImageView.frame = CGRectMake(6, (68-stImageView.image.size.width/((width-6)/4-6)*stImageView.image.size.height)/2, (width-6)/4-6, stImageView.image.size.width/((width-6)/4-6)*stImageView.image.size.height);
                [button addSubview:stImageView];
                
                UILabel* stLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, stImageView.frame.size.width, stImageView.frame.size.height)];
                stLabel.backgroundColor = [UIColor clearColor];
                stLabel.text = [arrayTitle objectAtIndex:i];
                stLabel.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1];
                stLabel.textAlignment = NSTextAlignmentCenter;
                stLabel.font = [UIFont systemFontOfSize:13];
                [stImageView addSubview:stLabel];
                
                [self lineView:orderView left:0 top:orderView.frame.size.height-1 width:width height:1];
                
                [self lineView:self left:0 top:orderView.bottom+10 width:width height:1];
            }
    }else if(indexRow == dataArray.count+1 && appDlg.isMicroReBOOL){
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
        
    }else if(indexRow!=0 && indexRow != dataArray.count+1) {
            NSDictionary* dict = [dataArray objectAtIndex:indexRow-1];
            self.contentView.backgroundColor =[UIColor whiteColor];
            UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 13, width-24, 15)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = [dict objectForKey:@"name"];
            titleLabel.textColor = [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:1];
            titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:titleLabel];
            
            UILabel* introLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, titleLabel.bottom+10, width-24, 31)];
            introLabel.backgroundColor = [UIColor clearColor];
            introLabel.text = [dict objectForKey:@"info"];
            introLabel.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1];
            introLabel.numberOfLines = 0;
            introLabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:introLabel];
            
            UIImageView* imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]]];
            imageView.frame = CGRectMake(12, introLabel.bottom+12, (width-24), (width-24)/375*195);
            [self addSubview:imageView];
        
        UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,introLabel.bottom+18+(width-24)/375*195,width, 1.5)];
        lineView1.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
        [self addSubview:lineView1];
    }
}
-(float)adaptCharacterWidth:(NSString*)characterString height:(float)widthCharacter{
    float sizeFloat;
    sizeFloat = 14.5;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:sizeFloat]};
    CGSize size = [characterString boundingRectWithSize:CGSizeMake(0, widthCharacter) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}
#pragma mark -- 文章
- (void)pressLookArticle:(UIButton *)button {
    NSDictionary* dict = [daArray objectAtIndex:button.tag];
    NSString* string = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"redArticle" object:string];
}
#pragma mark -- 代理更多品牌
- (void)pressActingMoreBrands {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoreBrands" object:nil];
}
#pragma mark -- 我的店铺
- (void)pressMyLevelStore {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyLevelStore" object:nil];
}
#pragma mark -- 收入 
- (void)presIncome:(UIButton *)button {
    
}
#pragma mark -- 管理店铺
- (void)pressOptionsStore:(UIButton *)button {
    NSString* string = [NSString stringWithFormat:@"%ld",(long)button.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"optionsStore" object:string];
}
- (void)lineView:(UIView *)view left:(float)left top:(float)top width:(float)width height:(float)height{
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(left, top, width, height)];
    lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [view addSubview:lineView];
}
- (void)calyer:(UIView *)view sizeFloat:(float)size {
    CALayer *laygender = view.layer;
    [laygender setMasksToBounds:YES];
    [laygender setCornerRadius:size];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
