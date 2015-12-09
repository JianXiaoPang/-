//
//  EditorWebViewController.m
//  Sharing
//
//  Created by 黄承琪 on 15/10/7.
//  Copyright © 2015年 简小胖 All rights reserved.
//

#import "EditorWebViewController.h"

@interface EditorWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *Title;

@end

@implementation EditorWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _myWebView = [[UIWebView alloc]init];
    _myWebView.delegate = self;
    _myWebView.frame = CGRectMake(0, 65, kDeviceWidth, KDeviceHeight-64);
    [self.view addSubview:_myWebView];
    
    NSURL *url = [NSURL URLWithString:_firestUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL: url];
    [_myWebView loadRequest:request];
}
#pragma mark - *********************************************开始加载的时候
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:_myWebView animated:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:_myWebView animated:YES];
    NSString *title = [_myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.Title.text = title;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [MBProgressHUD hideHUDForView:_myWebView animated:YES];
    
}


- (IBAction)goBack:(UIButton *)sender {
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
