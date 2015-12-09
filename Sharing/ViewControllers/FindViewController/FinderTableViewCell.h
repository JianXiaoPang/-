//
//  FinderTableViewCell.h
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "CycleScrollView.h"
#import "AppDelegate.h"
@interface FinderTableViewCell : UITableViewCell
- (void)loadcell:(NSArray *)pic arArray:(NSArray *)array width:(float)width indexRow:(int)indexRow;
+ (instancetype)getInstance;
@end
