//
//  ViewController.m
//  fenxiang
//
//  Created by 磊 on 15/9/8.
//  Copyright (c) 2015年 fenxiang. All rights reserved.
//

#import "GuideViewController.h"
#import "UIView+Size.h"
#import "UIColor+Hex.h"
#import "RegisterViewController.h"
@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray * imageNameArray;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
//     [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    self.view.backgroundColor = [UIColor blackColor];
    
    if (iPhone4){
        _imageNameArray = [[NSArray alloc] initWithObjects:
                           @"640x960-01.png",@"640x960-02.png",@"640x960-03.png",nil];
    } else if(iPhone5) {
        _imageNameArray = [[NSArray alloc] initWithObjects:
                           @"640x1136-01.png",@"640x1136-02.png",@"640x1136-03.png",nil];
    }else if(iPhone6) {
        _imageNameArray = [[NSArray alloc] initWithObjects:
                           @"750x1334-01.png",@"750x1334-02.png",@"750x1334-03.png",nil];
    }else if(iPhone6P){
        _imageNameArray = [[NSArray alloc] initWithObjects:
                           @"1242x2208-01.png",@"1242x2208-02.png",@"1242x2208-03.png",nil];
    }else {
        _imageNameArray = [[NSArray alloc] initWithObjects:
                           @"1242x2208-01.png",@"1242x2208-02.png",@"1242x2208-03.png",nil];
    }
    [self updateTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (ios7AndLater) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (ios7AndLater) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)updateTheme
{
    UIScreen * scr = [UIScreen mainScreen];
    _scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    for (int i = 0; i < self.imageNameArray.count; i ++)
    {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrView.size.width, -20, _scrView.size.width, _scrView.size.height)];
        imageView.image = [UIImage imageNamed:[_imageNameArray objectAtIndex:i]];
        imageView.tag = 1000 + i;
        [_scrView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        if (i==2){
            UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(0,self.view.frame.size.height - 44 - 45 - 5 , 105, 30);
            loginBtn.centerX = self.view.centerX;
            
            loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            [loginBtn setTitle:@"进入首页" forState:UIControlStateNormal];
            [loginBtn setTitle:@"进入首页" forState:UIControlStateHighlighted];
            [loginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [loginBtn setBackgroundColor:[UIColor colorWithHex:0xdadadb]];
            loginBtn.layer.borderWidth = 0.5;
            loginBtn.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
            loginBtn.layer.cornerRadius = 5.0;
            [loginBtn addTarget:self action:@selector(guideViewShowComplete) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:loginBtn];
        }
    }
    
    [_scrView setContentSize:CGSizeMake(_scrView.size.width * self.imageNameArray.count, viewHeight-100)];
    _scrView.pagingEnabled = YES;
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.bounces = NO;
    _scrView.delegate = self;
    [self.view addSubview:_scrView];
    
//    _scrView.contentOffset = CGPointMake(0, 20);
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(60,  _scrView.size.height -30 -25, 200, 50)];
    _pageControl.centerX = self.view.centerX;
    _pageControl.numberOfPages = self.imageNameArray.count;
    _pageControl.currentPage = 0;
    _pageControl.hidden = NO;
    _pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pageControl];
}

-(void)guideViewShowComplete{
    if ([self.delegate respondsToSelector:@selector(guideViewShowComplete:)]) {
        [self.delegate guideViewShowComplete:self];
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrView == scrollView) {
        CGFloat pageWidth = _scrView.frame.size.width;
        int page = floor((_scrView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageControl.currentPage = page;
    }
}


@end
