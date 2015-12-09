//
//  NSMutableArray+Additions.m
//  liumiao
//
//  Created by darkdong on 13-5-30.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import "NSMutableArray+Additions.h"
#import "NSArray+Additions.h"

@implementation NSMutableArray (Additions)

- (BOOL)removeObjectsEqualTo:(id)objToRemove {
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [objToRemove isEqual:obj];
    }];
    [self removeObjectsAtIndexes:indexes];
    return indexes.count > 0;
}

- (void)preappendObjectsFromArray:(NSArray *)otherArray {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, otherArray.count)];
    [self insertObjects:otherArray atIndexes:indexSet];
}

//self以及otherArray应该都已经按comparator由大到小排列,并且数组内的每个obj都响应comparator方法
- (void)mergeWithArray:(NSArray *)otherArray comparator:(SEL)comparator mode:(DDArrayMergingMode)mode {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id firstValue = [self.firstObject performSelector:comparator];
    id lastValue = [self.lastObject performSelector:comparator];
#pragma clang diagnostic pop
    
//    NSLog(@"DDArrayMergingMode %d firstValue %@ lastValue %@", mode, firstValue, lastValue);
    
    if (DDArrayMergingModeAppend == mode) {
        //获取更多
        NSUInteger appendFromIndex = NSNotFound;
        for (NSUInteger index = 0; index < otherArray.count; index++) {
            id obj = [otherArray objectAtIndex:index];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id value = [obj performSelector:comparator];
#pragma clang diagnostic pop
            if (value) {
                if (lastValue) {
                    NSComparisonResult result = [value compare:lastValue];
                    if (NSOrderedAscending == result) {
                        appendFromIndex = index;
                        //找到第一个就可以退出了,因为后面都是
                        break;
                    }
                }else {
                    appendFromIndex = index;
                    //找到第一个就可以退出了,因为后面都是
                    break;
                }
            }
        }
//        NSLog(@"appendFromIndex %u", appendFromIndex);
        if (appendFromIndex != NSNotFound) {
            NSArray *arrayToAppend = [otherArray subarrayWithRange:NSMakeRange(appendFromIndex, otherArray.count - appendFromIndex)];
            [self addObjectsFromArray:arrayToAppend];
        }
    }else if (DDArrayMergingModePreappend == mode) {
        //获取最新
        NSUInteger preappendToIndex = NSNotFound;
        for (NSUInteger index = otherArray.count - 1; index != -1; index--) {
            id obj = [otherArray objectAtIndex:index];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id value = [obj performSelector:comparator];
#pragma clang diagnostic pop
            if (value) {
                if (firstValue) {
                    NSComparisonResult result = [value compare:firstValue];
//                    NSLog(@"value %@ result %d", value, result);
                    if (NSOrderedDescending == result) {
                        preappendToIndex = index;
                        //找到第一个就可以退出了,因为前面都是
                        break;
                    }
                }else {
                    preappendToIndex = index;
                    //找到第一个就可以退出了,因为前面都是
                    break;
                }
            }
        }
//        NSLog(@"preappendToIndex %u", preappendToIndex);
        if (preappendToIndex != NSNotFound) {
            NSArray *arrayToPreappend = [otherArray subarrayWithRange:NSMakeRange(0, preappendToIndex + 1)];
            [self preappendObjectsFromArray:arrayToPreappend];
        }
    }else if (DDArrayMergingModeReplace == mode) {
        //完全替换
        [self setArray:otherArray];
    }else if (DDArrayMergingModeIncrementalUpdate == mode) {
        if (0 == self.count) {
            [self setArray:otherArray];
            return;
        }
        //增量更新
        NSUInteger preappendToIndex = NSNotFound;
        NSUInteger appendFromIndex = NSNotFound;
        
        for (NSUInteger index = 0; index < otherArray.count; index++) {
            id obj = [otherArray objectAtIndex:index];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id value = [obj performSelector:comparator];
#pragma clang diagnostic pop
            if (value) {
                NSComparisonResult result = [value compare:firstValue];
                if (NSOrderedDescending == result) {
                    //比数组中的第一个还大,应该插入到前面,并继续找
                    preappendToIndex = index;
                }else {
                    result = [value compare:lastValue];
                    if (NSOrderedAscending == result) {
                        //比数组中最后一个还小,应该追加到后面
                        appendFromIndex = index;
                        //找到第一个就可以退出了,因为后面都是
                        break;
                    }else {
                        //在数组区间里,替换之
                        NSUInteger index = [self indexOfObject:obj];
                        if (index != NSNotFound) {
//                            NSLog(@"replaceObjectAtIndex %u withObject %@", index, obj);
                            [self replaceObjectAtIndex:index withObject:obj];
                        }
                    }
                }
            }
        }
//        NSLog(@"preappendToIndex %u", preappendToIndex);
        if (preappendToIndex != NSNotFound) {
            NSArray *arrayToPreappend = [otherArray subarrayWithRange:NSMakeRange(0, preappendToIndex + 1)];
            [self preappendObjectsFromArray:arrayToPreappend];
        }
//        NSLog(@"appendFromIndex %u", appendFromIndex);
        if (appendFromIndex != NSNotFound) {
            NSArray *arrayToAppend = [otherArray subarrayWithRange:NSMakeRange(appendFromIndex, otherArray.count - appendFromIndex)];
            [self addObjectsFromArray:arrayToAppend];
        }
    }
//    NSLog(@"merged array %@", self);
}

//跳过两端不能响应comparator的obj,对中间部分执行合并
- (void)mergeComparableObjectsWithArray:(NSArray *)otherArray comparator:(SEL)comparator mode:(DDArrayMergingMode)mode {
    if (0 == otherArray.count) {
        return;
    }
    
    //跳过两端不能响应comparator的obj
    
    //顺序查找第一个能响应comparator的obj
    NSUInteger firstIndex = NSNotFound;
    for (NSUInteger index = 0; index < otherArray.count; index++) {
        id obj = [otherArray objectAtIndex:index];
        if ([obj respondsToSelector:comparator]) {
            firstIndex = index;
            //找到第一个就可以退出了,因为后面都是
            break;
        }
    }
    if (NSNotFound == firstIndex) {
        return;
    }
    
    //反向查找第一个能响应comparator的obj
    NSUInteger lastIndex = NSNotFound;
    for (NSUInteger index = otherArray.count - 1; index != -1; index--) {
        id obj = [otherArray objectAtIndex:index];
        if ([obj respondsToSelector:comparator]) {
            lastIndex = index;
            //找到第一个就可以退出了,因为前面都是
            break;
        }
    }
    
    //lastIndex一定会找到,至少等于firstIndex
    NSArray *arrayToPreappend = [otherArray subarrayWithRange:NSMakeRange(0, firstIndex)];
    NSArray *arrayToAppend = [otherArray subarrayWithRange:NSMakeRange(lastIndex + 1, otherArray.count - lastIndex - 1)];
    NSArray *arrayToMerge = [otherArray subarrayWithRange:NSMakeRange(firstIndex, lastIndex - firstIndex + 1)];
    
//    NSLog(@"arrayToPreappend %@", arrayToPreappend);
//    NSLog(@"arrayToAppend %@", arrayToAppend);
//    NSLog(@"arrayToMerge %@", arrayToMerge);
    
    NSMutableArray *marray = [NSMutableArray arrayWithArray:arrayToMerge];
    [marray mergeWithArray:otherArray comparator:comparator mode:mode];
    [marray preappendObjectsFromArray:arrayToPreappend];
    [marray addObjectsFromArray:arrayToAppend];
//    NSLog(@"marray %@", marray);
    
    [self setArray:marray];
    
//    NSLog(@"safe merged array %@", self);
}

@end
