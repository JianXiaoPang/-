//
//  NSData+Additions.m
//  liumiao
//
//  Created by darkdong on 13-4-23.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSData+Additions.h"

@implementation NSData (Additions)

- (NSString *)md5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, self.length, result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15]
            ];
}

- (NSString *)hexStringWithLowercase:(BOOL)lowercase {
    NSUInteger length = self.length;
	const unsigned char *bytes = self.bytes;
    NSString *format = lowercase? @"%02x": @"%02X";
    NSMutableString *mstring = [NSMutableString stringWithCapacity:(length * 2)];
	for (NSUInteger i = 0; i < length; ++i) {
        [mstring appendFormat:format, bytes[i]];
    }    
	return [mstring copy];
}

@end
