//
//  UIDeviceHardware.h
//  dd
//
//  Created by darkdong on 11-10-20.
//  Copyright (c) 2011年 darkdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject

+ (NSString *)MACAddress;
+ (NSString *)deviceName;
+ (NSString *)deviceRawName;
+ (NSString *)deviceUniqueID;
@end
