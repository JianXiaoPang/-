//
//  NSObject+Additions.m
//  liumiao
//
//  Created by darkdong on 13-5-14.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Additions.h"

static char kAssociatedObjectKey;

@implementation NSObject (Additions)

- (id)associatedObject {
    return objc_getAssociatedObject (self, &kAssociatedObjectKey);
}

- (void)setAssociatedObject:(id)associatedObject {
    objc_setAssociatedObject (self,
                              &kAssociatedObjectKey,
                              associatedObject,
                              OBJC_ASSOCIATION_RETAIN
                              );
}

@end
