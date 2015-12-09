//
//  NSArray+Additions.m
//  liumiao
//
//  Created by darkdong on 13-4-10.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (id)firstObject {
    if (0 == self.count) {
        return nil;
    }
    return [self objectAtIndex:0];
}

- (NSArray *)reversedArray {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)arrayByRemovingObjectsEqualTo:(id)objToRemove {
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    BOOL didRemove = [marray removeObjectsEqualTo:objToRemove];
    if (didRemove) {
        return [marray copy];
    }else {
        return self;
    }
}

- (NSArray *)arrayByMergingWithArray:(NSArray *)array comparator:(SEL)comparator mode:(DDArrayMergingMode)mode {
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray mergeWithArray:array comparator:comparator mode:mode];
    return [marray copy];
}

- (NSArray *)arrayByMergingComparableObjectsWithArray:(NSArray *)array comparator:(SEL)comparator mode:(DDArrayMergingMode)mode {
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray mergeComparableObjectsWithArray:array comparator:comparator mode:mode];
    return [marray copy];
}

- (NSArray *)arrayBySegment:(NSUInteger)length {
    NSMutableArray *segmentedArray = [NSMutableArray array];
    NSRange range = NSMakeRange(0, 0);
    while (range.location + length <= self.count) {
        NSArray *subarray = [self subarrayWithRange:NSMakeRange(range.location, length)];
        [segmentedArray addObject:subarray];
        range.location += length;
    }
    NSUInteger rangeLength = self.count - range.location;
    if (rangeLength) {
        NSArray *subarray = [self subarrayWithRange:NSMakeRange(range.location, rangeLength)];
        [segmentedArray addObject:subarray];
    }
    return [segmentedArray copy];
}

@end
