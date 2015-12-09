//
//  DDViewController.m
//  dd
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import "DDViewController.h"
#import "UIView+Additions.h"
#import "DDUtility.h"

@interface DDViewController ()

@property BOOL savedStatusBarHidden;
@property UIStatusBarStyle savedStatusBarStyle;
@property BOOL loadingMore;

@end

@implementation DDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _savedStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
        _savedStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
        
        _transitionDeltaX = 320;
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //externalTransitionViews 要此时才能添加,不能写在viewDidLoad里,因为要放在self.view的最上面
    if (self.externalTransitionViews.count > 0) {
        //准备externalTransitionViews, 放在正常的位置
        for (UIView *externalTransitionView in self.externalTransitionViews) {
            [externalTransitionView saveState];
            [self.view addSubview:externalTransitionView];
        }
        //准备internalTransitionViews,放在画面外
        for (UIView *internalTransitionView in self.internalTransitionViews) {
            internalTransitionView.left += self.transitionDeltaX;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.externalTransitionViews.count > 0) {
        //过场动画,只一次
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *externalTransitionView in self.externalTransitionViews) {
                externalTransitionView.left -= self.transitionDeltaX;
            }
            for (UIView *internalTransitionView in self.internalTransitionViews) {
                internalTransitionView.left -= self.transitionDeltaX;
            }
        } completion:^(BOOL finished) {
            for (UIView *externalTransitionView in self.externalTransitionViews) {
                [externalTransitionView restoreState];
            }
            self.externalTransitionViews = nil;
        }];
    }    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        
    if (self == self.navigationController.topViewController) {
        [self restoreStatusBarWithHiddenAnimation:UIStatusBarAnimationNone styleAnimated:NO];
    }
}

- (void)setTransitionMode:(DDTransitionMode)transitionMode {
    _transitionMode = transitionMode;
    if (DDTransitionModePushFromLeft == transitionMode) {
        _transitionDeltaX = -320;
    }else {
        _transitionDeltaX = 320;
    }
}

#pragma mark - public

//- (UIViewController *)ddPresentedViewController {
//    if ([self respondsToSelector:@selector(presentedViewController)]) {
//        return self.presentedViewController;
//    }else {
//        return self.modalViewController;
//    }
//}

- (void)restoreStatusBarWithHiddenAnimation:(UIStatusBarAnimation)animation styleAnimated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:self.savedStatusBarHidden withAnimation:animation];
    [[UIApplication sharedApplication] setStatusBarStyle:self.savedStatusBarStyle animated:animated];
}

- (void)checkScrollViewToLoadMore:(UIScrollView *)scrollView completion:(DDBlockLoadMore)completion {
    if (!self.hasMore) {
        return;
    }
    
    if (self.loadingMore) {
        return;
    }
    
    if (completion && DUScrollViewIsCloseToBottom(scrollView)) {
        self.loadingMore = YES;
        completion(^{
            self.loadingMore = NO;
        });
    }
}

@end
