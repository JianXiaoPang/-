//
//  NSString+Additions.m
//  dd
//
//  Created by darkdong on 13-4-9.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "NSString+Additions.h"
#import "NSData+Base64.h"
#import <UIKit/UIKit.h>
@implementation NSString (Additions)

+ (NSString *)UUID {
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
    CFRelease(uuidRef);
    return uuidString;
}

- (NSString *)stringByTrimmingWhiteSpaceAndNewline {
    NSMutableCharacterSet *charset = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:charset];
}

- (NSUInteger)lengthOfBytesUsingGBKEncoding
{
	NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	return [self lengthOfBytesUsingEncoding:encoding];
}

- (NSString *)stringByTruncatingToLengthOfBytes:(NSInteger)lengthOfBytes encoding:(NSStringEncoding)encoding {
//    NSLog(@"truncate to length %d %@", lengthOfBytes, self);
    char buf[lengthOfBytes];
//    BOOL res = [self getCString:buf maxLength:lengthOfBytes encoding:encoding];
    NSRange range = NSMakeRange(0, lengthOfBytes);
    NSUInteger usedBufferCount;
    [self getBytes:buf maxLength:lengthOfBytes usedLength:&usedBufferCount encoding:encoding options:NSStringEncodingConversionAllowLossy range:range remainingRange:NULL];
    
    NSString *truncatedString = [[NSString alloc] initWithBytes:buf length:usedBufferCount encoding:encoding];
//    NSLog(@"res %d truncatedString %@", res, truncatedString);
    
//    NSData *data = [self dataUsingEncoding:encoding];
//    NSLog(@"self %@ data %@", self, data);
//    NSString *truncatedString = [[NSString alloc] initWithBytes:data.bytes length:lengthOfBytes encoding:encoding];
//    NSLog(@"truncatedString %@", truncatedString);
    return truncatedString;
}

- (CGSize)safeSizeWithFont:(UIFont *)font {
    NSComparisonResult result = [[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch];
    
    if (NSOrderedDescending == result || NSOrderedSame == result) {
        //system version >= 6.0
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName : font}];
        return [attributedString size];
    }else {
        return [self sizeWithFont:font];
    }
}

- (CGSize)safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize {
    NSComparisonResult result = [[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch];
    
    if (NSOrderedDescending == result || NSOrderedSame == result) {
        //system version >= 6.0
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName : font}];
        return [attributedString boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }else {
        return [self sizeWithFont:font constrainedToSize:constrainedToSize];
    }
}

- (NSString *)HMACWithKey:(NSString *)key {
    const char *keyBytes = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *stringBytes = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char digestBytes[CC_SHA1_DIGEST_LENGTH];
    
	CCHmacContext ctx;
    CCHmacInit(&ctx, kCCHmacAlgSHA1, keyBytes, strlen(keyBytes));
	CCHmacUpdate(&ctx, stringBytes, strlen(stringBytes));
	CCHmacFinal(&ctx, digestBytes);
    
	NSData *digestData = [NSData dataWithBytes:digestBytes length:CC_SHA1_DIGEST_LENGTH];
    return [digestData base64EncodedString];
}

- (NSData *)hexData {
    const char *chars = [self UTF8String];
    
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    int i = 0;
    while (i < self.length) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return [data copy];
}

@end
