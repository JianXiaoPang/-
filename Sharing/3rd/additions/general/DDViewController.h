//
//  DDViewController.h
//  dd
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDType.h"

typedef void (^DDBlockLoadMore)(DDBlockVoid completion);

typedef enum {
    DDTransitionModePushFromRight,
    DDTransitionModePushFromLeft,
} DDTransitionMode;

@interface DDViewController : UIViewController

@property BOOL hasMore;
@property (nonatomic) DDTransitionMode transitionMode;
@property float transitionDeltaX;

@property NSArray *externalTransitionViews;
@property NSArray *internalTransitionViews;

- (void)restoreStatusBarWithHiddenAnimation:(UIStatusBarAnimation)animation styleAnimated:(BOOL)animated;
- (void)checkScrollViewToLoadMore:(UIScrollView *)scrollView completion:(DDBlockLoadMore)completion;

@end
