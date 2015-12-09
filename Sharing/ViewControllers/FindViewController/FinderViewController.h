//
//  FinderViewController.h
//  fenxiang
//
//  Created by 磊 on 15/9/14.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinderTableViewCell.h"
#import "FinderRequest.h"
#import "EGORefreshTableHeaderView.h"
@interface FinderViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    UITableView* finderTableView;
    NSMutableArray* findDataArray;
    NSMutableArray* topArray;
    FenXiangUserInfoModel* userModel;
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //
    BOOL _reloading;
    UILabel* loadLabel;
}
@end
