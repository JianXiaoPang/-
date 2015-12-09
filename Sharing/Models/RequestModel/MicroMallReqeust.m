//
//  MicroMallReqeust.m
//  fenxiang
//
//  Created by 磊 on 15/9/18.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import "MicroMallReqeust.h"

@implementation MicroMallReqeust
-(void)requestMicroMall:(NSString *)key{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_MIRCLMALL_URL]];
        request.timeOutSeconds = 20;
        
        NSDictionary *postValue = @{@"vshop":@{@"key":key}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        //CLog(@"response====%@",response);
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if(response.length>0){
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                if(!error){
                    if([dic[@"errcode"]intValue] == 0){
                        self.finishedBlock(YES,response);
                    }else {
                        self.finishedBlock(NO,dic[@"errmsg"]);
                    }
                }else
                {
                    self.finishedBlock(NO,@"请求错误");
                }
            }else
            {
                self.finishedBlock(NO,@"请求超时");
            }
        });
    });
}
-(void)requestmerchantlist:(NSString *)key meId:(NSString *)meId type:(NSString *)type limt:(NSString *)limt{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_MERCHANTLIST_URL]];
        request.timeOutSeconds = 20;
        
        NSDictionary *postValue = @{@"vshop":@{@"key":key,@"id":meId,@"type":type,@"limit":limt}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        //CLog(@"response====%@",response);
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if(response.length>0){
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                if(!error){
                    if([dic[@"errcode"]intValue] == 0){
                        self.finishedBlock(YES,response);
                    }else {
                        self.finishedBlock(NO,dic[@"errmsg"]);
                    }
                }else
                {
                    self.finishedBlock(NO,@"请求错误");
                }
            }else
            {
                self.finishedBlock(NO,@"请求超时");
            }
        });
    });
}
@end