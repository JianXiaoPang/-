//
//  PAD.m
//  AH2House
//
//  Created by Ting on 14-8-28.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import "ADRequest.h"

@implementation ADRequest

-(void)getADPic{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_ADVEN_URL]];
        request.timeOutSeconds = 5;
        
        NSNumber *deviceType;
        if(iPhone4){
            deviceType =@(1);
        }else if (iPhone5){
            deviceType =@(2);
        }else if (iPhone6){
            deviceType =@(3);
        }else {
            deviceType =@(4);
        }
        
        NSDictionary *postValue = @{@"img":@{@"type":deviceType}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if(response.length>0){
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                if(!error){
                    if([dic[@"errcode"]intValue] == 0){
                        self.finishedBlock(YES,dic[@"data"],dic[@"errmsg"]);
                    }else {
                        self.finishedBlock(NO,nil,dic[@"errmsg"]);
                    }
                }else
                {
                    self.finishedBlock(NO,nil,@"请求错误");
                }
            }else
            {
                self.finishedBlock(NO,nil,@"请求超时");
            }
        });
    });
}


@end