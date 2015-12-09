//
//  PhotoReviewViewController.m
//  Sharing
//
//  Created by 磊 on 15/10/11.
//  Copyright © 2015年 简小胖 All rights reserved.
//

#import "PhotoReviewViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+Size.h"
@interface PhotoReviewViewController ()

@end

@implementation PhotoReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.contentMode = UIViewContentModeScaleToFill;
    [view sd_setImageWithURL:[NSURL URLWithString:self.photoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        CGSize rect = image.size;
        float scale = 1.f;
        if (rect.width > self.view.width)
        {
            scale = self.view.width / rect.width;
        }
        
        view.frame = CGRectMake(0, 0, rect.width * scale, rect.height * scale);
        view.centerX = self.view.centerX;
        view.centerY = self.view.centerY;
    }];
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPhoto:)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
}

- (void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)tapOnPhoto:(UIGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
