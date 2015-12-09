//
//  WebContentRequest.m
//  AH2House
//
//  Created by Ting on 14-8-28.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import "WebContentRequest.h"
#import "ShareModel.h"

@implementation WebContentRequest

-(void)returnShareWithShareModel:(ShareModel *)shareModel  andSharePlatform:(SharePlatform)sharePlatform;{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *strRequest = [mainUrl stringByAppendingString:@"cgi-bin/share/create.html"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:strRequest]];
        request.timeOutSeconds = 20;
        
       // {"share":{""},"type":1}
        
        NSString *strPlatForm = [NSString stringWithFormat:@"%ld",sharePlatform];
        
        NSDictionary *postValue = @{@"share":[shareModel.returnDic objectForKey:@"Data"],@"type":strPlatForm};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        ////CLog(@"response====%@",response);
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if(response.length>0){
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                if(!error){
                    if([dic[@"errcode"]intValue] == 0){
                        self.finishedBlock(YES,@"");
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