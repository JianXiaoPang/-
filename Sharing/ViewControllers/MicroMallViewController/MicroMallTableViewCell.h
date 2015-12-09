//
//  MicroMallTableViewCell.h
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedLabel.h"
#import "AppDelegate.h"
@interface MicroMallTableViewCell : UITableViewCell
{
    NSMutableArray *daArray;
}
- (void)loadCell:(float)width indexRow:(int)indexRow dataDict:(NSDictionary *)dataDict dataArray:(NSMutableArray *)dataArray;
+ (instancetype)getInstance;
@end
