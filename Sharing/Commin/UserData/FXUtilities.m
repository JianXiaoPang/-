//
//  FXUtilities.m
//  fenxiang
//
//  Created by 磊 on 15/9/19.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import "FXUtilities.h"
#import <CommonCrypto/CommonDigest.h>
@implementation FXUtilities
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+ (NSString *)archivePath:(NSString *)pkId
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *archivePath = [[documents objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"fenxiang%@.archive",pkId]];
    return archivePath;
}
@end
