//
//  NSData+Additions.h
//  liumiao
//
//  Created by darkdong on 13-4-23.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)

- (NSString *)md5;
- (NSString *)hexStringWithLowercase:(BOOL)lowercase;

@end
