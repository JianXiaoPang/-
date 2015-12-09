//
//  DDPreprocessMacro.h
//  dd
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#ifndef dd_DDPreprocessMacro_h
#define dd_DDPreprocessMacro_h

#ifndef DDLog
#if !defined(DD_FINAL_RELEASE)
    #define DDLog(...) NSLog(__VA_ARGS__) 
#else
    #define DDLog(...) do {} while (0)
#endif
#endif // #ifndef DDLog

#ifndef DDLogDetail
#if !defined(DD_FINAL_RELEASE)
    #define DDLogDetail(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
    #define DDLogDetail(...) do {} while (0)
#endif
#endif // #ifndef DDLogDetail

#ifndef DDAssert
#if !defined(DD_FINAL_RELEASE)
    #define DDAssert(condition, ...)                                                        \
        do {                                                                                \
            if (!(condition)) {                                                             \
                [[NSAssertionHandler currentHandler]                                        \
                handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                file:[NSString stringWithUTF8String:__FILE__]                               \
                lineNumber:__LINE__                                                         \
                description:__VA_ARGS__];                                                   \
            }                                                                               \
        }while(0)
#else
    #define DDAssert(condition, ...) do {} while (0)
#endif 
#endif // #ifndef DDAssert

#ifndef DD_MONITOR_MAKE_UNRETAINED_SELF
#if defined(__has_feature) && __has_feature(objc_arc)
    #if __has_feature(objc_arc_weak)
//        #error ARC and WEAK
        #define DD_MONITOR_ADD_SELF
        #define DD_MONITOR_REMOVE_SELF
        #define DD_MONITOR_CHECK_UNRETAINED_SELF unretainedSelf
        #define DD_MONITOR_MAKE_UNRETAINED_SELF id __weak unretainedSelf = self
    #else
//        #error ARC but not WEAK
        #define DD_MONITOR_ADD_SELF [DDUtility monitorAddObject:self.hash]
        #define DD_MONITOR_REMOVE_SELF [DDUtility monitorRemoveObject:self.hash]
        #define DD_MONITOR_CHECK_UNRETAINED_SELF [DDUtility monitorContainsObject:selfHashCode]
        #define DD_MONITOR_MAKE_UNRETAINED_SELF \
            id __unsafe_unretained unretainedSelf = self; \
            NSUInteger selfHashCode = self.hash
    #endif
#else
//    #error not ARC
    #define DD_MONITOR_ADD_SELF [DDUtility monitorAddObject:self.hash]
    #define DD_MONITOR_REMOVE_SELF [DDUtility monitorRemoveObject:self.hash]
    #define DD_MONITOR_CHECK_UNRETAINED_SELF [DDUtility monitorContainsObject:selfHashCode]
    #define DD_MONITOR_MAKE_UNRETAINED_SELF \
        id __block unretainedSelf = self; \
        NSUInteger selfHashCode = self.hash
#endif

#endif // #ifndef DD_MONITOR_MAKE_UNRETAINED_SELF

#endif // #ifndef dd_DDDefines_h
