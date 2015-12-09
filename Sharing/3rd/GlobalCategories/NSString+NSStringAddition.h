//
//  NSString+NSStringAddition.h
//  iSing
//
//  Created by cui xiaoqian on 13-4-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Base64)

+ (NSString *)encodeBase64UrlWithBase64:(NSString *)strBase64;
+ (NSString *)encodeBase64WithString:(NSString *)strData;

@end


@interface NSString(MD5Addition)

- (NSString *) stringFromMD5;

@end


// add by bwzhu
//
//  获取文本需要的高度
//
@interface NSString (Size)

+ (float)heightWithFont:(UIFont *)font;

+ (float)heightContent:(NSString *)str font:(UIFont *)font width:(float)width;

@end

@interface NSString (Character)

// 返回只有汉字、英文和数字的字符串
- (NSString *)stringWithNormalCharacter;

@end

//
// 如果url字符串中包含有中文字符，再发起请求之前需要转换了。
//
@interface NSString (Covert)

+ (NSURL*)urlEncodeFromString:(NSString*)str;

+ (NSString*)stringDecodeFromString:(NSString*)str;

@end

@interface NSString (NSDate)

+ (NSString *)stringWithDate:(NSDate *)date fromat:(NSString *)fromatStr;

@end

@interface NSString (Weibo)

+ (NSDictionary *)dictionaryFromString:(NSString *)str;

+ (NSString *)stringFromDictionary:(NSDictionary *)dict;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

@end


//Functions for Encoding String.
@interface NSString (WBEncode)
- (NSString *)MD5EncodedString;
//- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
//- (NSString *)base64EncodedString;
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString*)URLDecodedString;
NSString* encodeToPercentEscapeString(NSString *string);
@end

@interface NSString (WBUtil)

+ (NSString *)GUIDString;

@end

@interface NSString (Analyse)

- (BOOL)isPureNumber;

@end
