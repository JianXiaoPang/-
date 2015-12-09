//
//  NewsTableViewController.h
//  Sharing
//
//  Created by huangchengqi on 15/9/23.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewController : UITableViewController

{
  
    //
    BOOL _reloading;
}
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,assign) NSInteger tTapy;

@property(nonatomic,strong)NSArray *FDataArray;
@property (nonatomic,assign)BOOL IsFirstIn;

@end
