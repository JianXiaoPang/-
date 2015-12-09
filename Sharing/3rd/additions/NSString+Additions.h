//
//  NSString+Additions.h
//  dd
//
//  Created by darkdong on 13-4-9.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Additions)

+ (NSString *)UUID;
- (NSString *)stringByTrimmingWhiteSpaceAndNewline;
- (NSUInteger)lengthOfBytesUsingGBKEncoding;
- (NSString *)stringByTruncatingToLengthOfBytes:(NSInteger)lengthOfBytes encoding:(NSStringEncoding)encoding;
- (CGSize)safeSizeWithFont:(UIFont *)font;
- (CGSize)safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize;
- (NSString *)HMACWithKey:(NSString *)key;
- (NSData *)hexData;

@end
