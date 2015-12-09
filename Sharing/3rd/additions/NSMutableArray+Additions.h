//
//  NSMutableArray+Additions.h
//  liumiao
//
//  Created by darkdong on 13-5-30.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DDArrayMergingModeReplace,
    DDArrayMergingModePreappend,
    DDArrayMergingModeAppend,
    DDArrayMergingModeIncrementalUpdate,
}DDArrayMergingMode;

@interface NSMutableArray (Additions)

- (BOOL)removeObjectsEqualTo:(id)objToRemove;
- (void)preappendObjectsFromArray:(NSArray *)otherArray;
- (void)mergeWithArray:(NSArray *)otherArray comparator:(SEL)comparator mode:(DDArrayMergingMode)mode;
- (void)mergeComparableObjectsWithArray:(NSArray *)otherArray comparator:(SEL)comparator mode:(DDArrayMergingMode)mode;

@end
