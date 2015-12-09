//
//  DDGlobal.h
//  dd
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#ifndef dd_DDGlobal_h
#define dd_DDGlobal_h

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define DD_INVALIDATE_TIMER(__TIMER) do {[__TIMER invalidate];__TIMER = nil;} while (0)
#define DD_CFRELEASE(__CFTypeRef) do {if (__CFTypeRef) {CFRelease(__CFTypeRef);__CFTypeRef = nil;}} while (0)

#endif
