//
//  MicroMallViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MicroMallTableViewCell.h"
#import "MicroMallReqeust.h"
#import "WebViewController.h"
@interface MicroMallViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    UITableView* microMallTableView;
    NSDictionary* microMallSubDict;
    //EGOFoot
    EGORefreshTableHeaderView *_refreshHeaderView;
    //
    BOOL _reloading;
    FenXiangUserInfoModel* userModel;
    NSDictionary* dataDict;
    NSMutableArray* picArray;
    
}
@end
