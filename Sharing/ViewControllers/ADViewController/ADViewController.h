//
//  ADViewController.h
//  AH2House
//
//  Created by Ting on 14-8-21.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginRegisterViewController.h"
@class ADViewController;

@protocol ADViewControllerDelegate <NSObject>

- (void)ADViewShowComplete;

@end

@interface ADViewController : UIViewController
{
  
}

@property (retain,nonatomic)IBOutlet UIImageView *adImg;
@property (retain, nonatomic)IBOutlet UIImageView *imgBottom;
@property (assign, atomic) BOOL isFinishShow;
@property (nonatomic , weak) id<ADViewControllerDelegate> delegate;
@end
