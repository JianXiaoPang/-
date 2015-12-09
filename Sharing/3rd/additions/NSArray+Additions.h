//
//  NSArray+Additions.h
//  liumiao
//
//  Created by darkdong on 13-4-10.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Additions.h"

@interface NSArray (Additions)

- (id)firstObject;
- (NSArray *)reversedArray;
- (NSArray *)arrayByRemovingObjectsEqualTo:(id)objToRemove;
- (NSArray *)arrayByMergingWithArray:(NSArray *)array comparator:(SEL)comparator mode:(DDArrayMergingMode)mode;
- (NSArray *)arrayByMergingComparableObjectsWithArray:(NSArray *)array comparator:(SEL)comparator mode:(DDArrayMergingMode)mode;
- (NSArray *)arrayBySegment:(NSUInteger)length;
@end
