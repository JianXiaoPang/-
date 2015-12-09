//
//  HomeRequest.m
//  Sharing
//
//  Created by huangchengqi on 15/9/21.
//  Copyright (c) 2015年 简小胖 All rights reserved.
//

#import "HomeRequest.h"


@implementation HomeRequest
#pragma mark - *********************************************普通新闻
#pragma mark - ***********首页分类
-(void)getJsonForNewWithKey:(NSString *)KEY{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:GET_NEWS_URL]];
        request.timeOutSeconds = 20;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        FenXiangUserInfoModel* model = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
        //@{@"dream":@{@"key":key,@"id":meId,@"type":type,@"limit":limt}};
        NSDictionary *postValue = @{@"menu":@{@"classify":@"1",@"key":model.userKey}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
       
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        self.finishedBlock(YES ,response);
           
        });
    });
}
#pragma mark - ***********没有数据获取新闻  
-(void)getJsonForNEWS:(NSString *)KEYs ClassID:(NSString *)Class RequestTapy:(NSString *)RequestTapy IsOriginal:(BOOL)isOriginal ArticleId:(NSString *)articleId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request;
        if (isOriginal== YES) {
            request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:GET_OrginalNEWS_URL]];
        }
        else
        {
            request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:GET_NEWSNums_URL]];
        }
        request.timeOutSeconds = 20;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        FenXiangUserInfoModel* model = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
        //@{@"dream":@{@"key":key,@"id":meId,@"type":type,@"limit":limt}};
        NSDictionary *postValue = @{@"article":@{@"key":model.userKey,@"classid":Class,@"id":articleId,@"type":RequestTapy,@"limit":@"10"}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (response.length > 0) {
                self.finishedBlock(YES ,response);
            }
            else{
                self.finishedBlock(NO ,@"");
            }
            
            
        });
    });

}
#pragma mark - ***********有数据后获取新闻 刷新新闻
-(void)UpJsonForNEWS:(NSString *)KEYs ClassID:(NSString *)Class RequestTapy:(NSString *)RequestTapy ArticleID:(NSString *)articleId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:GET_NEWSNums_URL]];
        request.timeOutSeconds = 20;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        FenXiangUserInfoModel* model = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
        //@{@"dream":@{@"key":key,@"id":meId,@"type":type,@"limit":limt}};
        NSDictionary *postValue = @{@"article":@{@"key":model.userKey,@"classid":Class,@"id":articleId,@" type":RequestTapy,@"limit":@"5"}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.finishedBlock(YES ,response);
            
        });
    });
    
}

#pragma mark - *********************************************原创新闻
#pragma mark - ***********获取原创分类
-(void)getJsonForOriginalNews:(NSString *)IDKey
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:GET_OriginalNums_URL]];
        request.timeOutSeconds = 20;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        FenXiangUserInfoModel* model = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults objectForKey:@"key"]]];
        //@{@"dream":@{@"key":key,@"id":meId,@"type":type,@"limit":limt}};
        NSDictionary *postValue = @{@"original":@{@"classify":@"1",@"key":model.userKey}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        
        //  NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.finishedBlock(YES ,response);
            
        });
    });

}


@end
