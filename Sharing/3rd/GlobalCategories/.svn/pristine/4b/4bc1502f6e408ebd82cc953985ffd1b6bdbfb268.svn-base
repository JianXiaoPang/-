//
//  NSString+NSStringAddition.m
//  iSing
//
//  Created by cui xiaoqian on 13-4-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "NSString+NSStringAddition.h"
#import "NSData+NSDataAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Base64)

+ (NSString *)encodeBase64UrlWithBase64:(NSString *)strBase64
{
	// Switch a base64 encoded string into a "base 64 url" encoded string
	// all that really means is no "=" padding and switch "-" for "+" and "_" for "/"
    
	// This is not a "standard" per se, but it is a widely used variant.
	// See http://en.wikipedia.org/wiki/Base64#URL_applications for more information
    
	NSString * strStep1 = [strBase64 stringByReplacingOccurrencesOfString:@"=" withString:@""];
	NSString * strStep2 = [strStep1 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
	NSString * strStep3 = [strStep2 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	return strStep3;
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
	return [NSData encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}
@end




@implementation NSString(MD5Addition)

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}

@end

// add by bwzhu
//
//  获取文本需要的高度
//
@implementation NSString (Size)

+ (float)heightWithFont:(UIFont *)font
{
    NSString *test = @"测试";
    return [test sizeWithFont:font].height;
}

+ (float)heightContent:(NSString *)str font:(UIFont *)font width:(float)width
{
    if (!font || !str)
    {
        return 0;
    }
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width,NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

@end

@implementation NSString (Character)

- (NSString *)stringWithNormalCharacter
{
    NSMutableString *str = [NSMutableString string];
    NSRange range;
    range.length = 1;
    for (int i = 0; i < self.length; i++)
    {
        range.location = i;
        NSString *singleStr = [self substringWithRange:range];
        int unicode = [self characterAtIndex:i];
        //
        if ((unicode >= 0x4e00 && unicode <= 0x9fa5) || (unicode <= 128))
        {
            [str appendString:singleStr];
        }
    }
    return str;
}

@end

@implementation NSString (NSDate)

+ (NSString *)stringWithDate:(NSDate *)date fromat:(NSString *)fromatStr
{
    if (!date || !fromatStr)
    {
        return nil;
    }
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:fromatStr];
    
    return [formatter stringFromDate:date];
}

@end


@implementation NSString (Convert)

+(NSURL*)urlEncodeFromString:(NSString *)str
{
//    if (str==nil) {
//        return [NSURL URLWithString:@""];
//    }
    if ([str rangeOfString:@"%"].location!=NSNotFound) {
        return [NSURL URLWithString:str];
    }
    NSString *convertstr = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, nil, kCFStringEncodingUTF8);
    return [NSURL URLWithString:[convertstr autorelease]];
}

+ (NSString*)stringDecodeFromString:(NSString*)str
{
    CFStringRef string = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)str, NULL, NSUTF8StringEncoding);
    NSString * retStr = [(NSString *)string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CFRelease(string);
    return retStr;
}

@end

@implementation NSString (Weibo)

+ (NSDictionary *)dictionaryFromString:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *subStr in array)
    {
        NSArray *keyValue = [subStr componentsSeparatedByString:@"="];
        if (keyValue && [keyValue count] == 2)
        {
            [dict setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
        }
    }
    return dict;
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	//NSString *str = [pairs componentsJoinedByString:@"&"];
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    if (![httpMethod isEqualToString:@"GET"])
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [NSString stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

@end


#pragma mark - NSString (WBEncode)

@implementation NSString (WBEncode)

- (NSString *)MD5EncodedString
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5EncodedString];
}

//- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key
//{
//	return [[self dataUsingEncoding:NSUTF8StringEncoding] HMACSHA1EncodedDataWithKey:key];
//}
//
//- (NSString *) base64EncodedString
//{
//	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
//}

NSString* encodeToPercentEscapeString(NSString *string) {
    return (NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString*)URLDecodedString
{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding) autorelease];
}

@end

#pragma mark - NSString (WBUtil)

@implementation NSString (WBUtil)

+ (NSString *)GUIDString
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}

@end

#pragma mark - NSString(PureNumber)

@implementation NSString (Analyse)

- (BOOL)isPureNumber
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
