//
//  FenXiangUserInfoModel.m
//  fenxiang
//
//  Created by 磊 on 15/9/18.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import "FenXiangUserInfoModel.h"

@implementation FenXiangUserInfoModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userKey forKey:@"key"];
    [aCoder encodeObject:self.userPhoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:self.userPassword forKey:@"password"];
    [aCoder encodeObject:self.userIsmd5 forKey:@"ismd5"];
    [aCoder encodeObject:self.userMark forKey:@"mark"];
    [aCoder encodeObject:self.userIsThirdPartType forKey:@"thirdType"];
    [aCoder encodeObject:self.showGuideVersion forKey:@"showGuideVersion"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.userKey = [aDecoder decodeObjectForKey:@"key"];
    self.userPhoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    self.userPassword = [aDecoder decodeObjectForKey:@"password"];
    self.userIsmd5 = [aDecoder decodeObjectForKey:@"ismd5"];
    self.userMark= [aDecoder decodeObjectForKey:@"mark"];
    self.userIsThirdPartType= [aDecoder decodeObjectForKey:@"thirdType"];
    self.showGuideVersion= [aDecoder decodeObjectForKey:@"showGuideVersion"];
    return self;
}
@end
