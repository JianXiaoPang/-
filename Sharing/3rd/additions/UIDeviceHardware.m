//
//  UIDeviceHardware.m
//  dd
//
//  Created by darkdong on 11-10-20.
//  Copyright (c) 2011年 darkdong. All rights reserved.
//

#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <UIKit/UIKit.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <ifaddrs.h>
#include <net/ethernet.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDeviceHardware

+ (NSString *)MACAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        ////CLog(@"Error: if_nametoindex error\n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        ////CLog(@"Error: sysctl, take 1\n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        ////CLog(@"Error: Memory allocation error\n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        ////CLog(@"Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

+ (NSString *)deviceName {
    NSString *rawName = [self deviceRawName];
    if ([rawName isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([rawName isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([rawName isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([rawName isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([rawName isEqualToString:@"iPhone4,1"])    return @"iPhone 4s";
    if ([rawName isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([rawName isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([rawName isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([rawName isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([rawName isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([rawName isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([rawName isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    
    if ([rawName isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([rawName isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([rawName isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([rawName isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([rawName hasPrefix:@"iPod5"])    return @"iPod Touch 5";
    if ([rawName isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([rawName isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([rawName isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([rawName isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([rawName isEqualToString:@"iPad2,5"])      return @"iPad mini";
    
    if ([rawName hasPrefix:@"iPad3"])      return @"New iPad";
    if ([rawName isEqualToString:@"i386"])         return @"Simulator";
    if ([rawName isEqualToString:@"x86_64"])       return @"Simulator";
    return rawName;
}

+ (NSString *)deviceRawName{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *rawName = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return rawName;
}

+ (NSString *)deviceUniqueID {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if (NSOrderedAscending == [systemVersion compare:@"6" options:NSNumericSearch]) {
        return [UIDeviceHardware MACAddress];
    }else {
        return [[UIDevice currentDevice] identifierForVendor].UUIDString;
    }
}

@end
