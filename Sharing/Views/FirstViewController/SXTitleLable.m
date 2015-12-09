//
//  SXTitleLable.m
//  85 - 网易滑动分页
//
//  Created by 董 尚先 on 15-1-31.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXTitleLable.h"

@implementation SXTitleLable

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        
       // self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
   
    CGFloat cl;
    if (scale == 0.f) {
        cl = _scale;
        self.textColor = [UIColor colorWithRed:scale green:cl blue:0.0 alpha:1.f];
          self.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    }
    else if (scale == 1.f)
    {
        cl = 0.64f;
       self.textColor = [UIColor colorWithRed:scale green:cl blue:0.0 alpha:1.f];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar_bg"]];
    
    }
    else
    {
        
        //self.textColor = [UIColor blackColor];
    }
    
    
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    //self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
