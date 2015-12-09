//
//  ADViewController.m
//  AH2House
//
//  Created by Ting on 14-8-21.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import "ADViewController.h"
#import "UIImageView+WebCache.h"
#import "ADRequest.h"

@interface ADViewController (){
    
    NSString *adImgUrl;
    
}
@end

@implementation ADViewController

@synthesize adImg,imgBottom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    self.navigationController.navigationBar.hidden = YES;
    if(iPhone4 || iPhone5){
        self.imgBottom.image=[UIImage imageNamed:@"ADBottom640"];
    }else if (iPhone6){
        self.imgBottom.image=[UIImage imageNamed:@"ADBottom750"];
    }else {
        self.imgBottom.image=[UIImage imageNamed:@"ADBottom1242"];
    }
    
    _isFinishShow=NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self getAdUrl];
}

-(void)getAdUrl
{
    ADRequest *request = [ADRequest new];
    [request setFinishedBlock:^(BOOL isSucceed , NSString *imUrl, NSString *desc) {
        if(isSucceed){
            adImgUrl= imUrl;
            
            if(adImgUrl.length>0){
                [self downLoadAD];
            }else {
                [self pushHome];
            }
        }else {
            [self pushHome];
        }
    }];
    [request getADPic];
}

-(void)downLoadAD
{
    //启动超时push,如果它一直在下载的话...
    [self performSelector:@selector(pushHome) withObject:nil afterDelay:4.0f];
    
    __block ADViewController *blockSelf = self;
    [adImg sd_setImageWithURL: [NSURL URLWithString:adImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //下载有了响应,停止超时push
        [NSObject cancelPreviousPerformRequestsWithTarget:blockSelf selector:@selector(pushHome) object:nil];
        if(error!=nil){
            //下载出错立即push
            [blockSelf pushHome];
            return;
        }
        //下载图片结束,已经显示,让他看4.0秒
        [blockSelf performSelector:@selector(pushHome) withObject:nil afterDelay:3.0];
    }];
}

-(void)pushHome{
    
    [self.navigationController popViewControllerAnimated:NO];
    if(!_isFinishShow){
        _isFinishShow =YES;
        if([self.delegate respondsToSelector:@selector(ADViewShowComplete)]){
            [self.delegate ADViewShowComplete];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
