//
//  LoginRequest.m
//  fenxiang
//
//  Created by 磊 on 15/9/18.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest
-(void)getVerifyCodeWithPhoneNub:(NSString *)phoneNub{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:GET_PHONENUBVERIFYCODE_URL]];
        request.timeOutSeconds = 20;
        
        NSDictionary *postValue = @{@"smsservice":@{@"mobile":phoneNub}};
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
-(void)registerWithUser:(FenXiangUserInfoModel *)userModel andVerifyCode:(NSString *)verifyCode{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_PHONEREGISTER_URL]];
        request.timeOutSeconds = 20;
        
        //{"register":{"mobile":"12345678911","verify":"3101","password":"234200"}}
        
        NSDictionary *postValue =@{@"register":@{@"mobile":userModel.userPhoneNumber,@"verify":verifyCode,@"password":userModel.userPassword}};
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
//                        fenxiang *returnModel = [UserModel new];
//                        returnModel.userKey = dic[@"key"];
//                        returnModel.pwd = userModel.pwd;
//                        returnModel.phoneNub = userModel.phoneNub;
                        
                        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
                        FenXiangUserInfoModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults1 objectForKey:@"key"]]];
                        userModel.userKey = dic[@"key"];
                        userModel.userPhoneNumber =userModel.userPhoneNumber;
                        userModel.userPassword = userModel.userPassword;
                        [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
                        [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        self.finishedLoginBlock(YES,userModel,@"");
                    }else {
                        self.finishedLoginBlock(NO,nil,dic[@"errmsg"]);
                    }
                }else
                {
                    self.finishedLoginBlock(NO,nil,@"请求错误");
                }
            }else
            {
                self.finishedLoginBlock(NO,nil,@"请求超时");
            }
        });
    });
}

-(void)loginWithUser:(FenXiangUserInfoModel *)userModel{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_PHONELOGIN_URL]];
        request.timeOutSeconds = 20;
        NSDictionary *postValue = @{@"sign":@{@"mobile":userModel.userPhoneNumber,@"password":userModel.userPassword,@"ismd5":userModel.userIsmd5}};
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
                        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
                        FenXiangUserInfoModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults1 objectForKey:@"key"]]];
                        userModel.userKey = dic[@"key"];
                        userModel.userPhoneNumber =userModel.userPhoneNumber;
                        userModel.userPassword = userModel.userPassword;
                        [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
                        [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
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

-(void)findMyPwd:(FenXiangUserInfoModel *)userModel andVerifyCode:(NSString *)verifyCode{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_FINDERMYPASSWORD_URL]];
        request.timeOutSeconds = 20;
        
        //{"register":{"mobile":"12345678911","verify":"3101","password":"234200"}}
        
        NSDictionary *postValue =@{@"recovery":@{@"mobile":userModel.userPhoneNumber,@"verify":verifyCode,@"password":userModel.userPassword}};
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
- (void)thirdPartLogin:(FenXiangUserInfoModel *)userModel thirdKey:(NSString *)thirdKey type:(NSString *)type {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_THIRDPARTLOGIN_URL]];
        request.timeOutSeconds = 20;
        NSDictionary *postValue = @{@"sign":@{@"signid":thirdKey,@"type":type}};
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:postValue
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:[bodyData mutableCopy]];
        [request startSynchronous];
        NSString *response = [request responseString];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if(response.length>0){
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                if(!error){
                    if([dic[@"errcode"]intValue] == 0){
                        
//                        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
//                        FenXiangUserInfoModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults1 objectForKey:@"key"]]];
//                        userModel.userKey = dic[@"key"];
//                        userModel.userPhoneNumber =userModel.userPhoneNumber;
//                        userModel.userPassword = userModel.userPassword;
//                        userModel.userIsmd5 = @"1";
//                        [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
//                        [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
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
- (void)thirdPartMessageVerCode:(NSString *)verifyCode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_THIRDMESSAGEVERCODE_URL]];
        request.timeOutSeconds = 20;
        
        NSDictionary *postValue = @{@"smsservice":@{@"mobile":verifyCode}};
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
                        self.finishedBlock(YES,@"");
                    }else {
                        self.finishedBlock(NO,response);
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
- (void)thirdPartUserInfo:(FenXiangUserInfoModel *)userModel andVerifyCode:(NSString *)verifyCode signid:(NSString *)signid nickname:(NSString *)nickname sex:(NSString *)sex province:(NSString *)province city:(NSString *)city headimgurl:(NSString *)headimgurl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc]initWithString:REQUEST_THIRDTHEBINDINGPHONENUMBER_URL]];
        request.timeOutSeconds = 20;
        
        NSDictionary *postValue = @{@"register":@{@"mobile":userModel.userPhoneNumber,@"verify":verifyCode,@"password":userModel.userPassword,@"type":userModel.userIsThirdPartType,@"data":@{@"signid":signid,@"nickname":nickname,@"sex":sex,@"province":province,@"city":city,@"headimgurl":headimgurl}}};
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
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                        
                        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
                        FenXiangUserInfoModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FXUtilities archivePath:[userDefaults1 objectForKey:@"key"]]];
                        userModel.userKey = dic[@"key"];
                        userModel.userIsmd5 = @"0";
                        [[NSUserDefaults standardUserDefaults] setObject:userModel.userKey forKey:@"key"];
                        [NSKeyedArchiver archiveRootObject:userModel toFile:[FXUtilities archivePath:userModel.userKey]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
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
