//
//  NSString+DateFormatter.m
//  hfwzone
//
//  Created by star on 14-8-29.
//  Copyright (c) 2014年 hfw.kunwang. All rights reserved.
//

#import "NSString+DateFormatter.h"

@implementation NSString (DateFormatter)


+ (NSString * )getDateMMddHHmmString:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)year:(NSDate *)date {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)month:(NSDate *)date {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)day:(NSDate *)date {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)hourAndMinute:(NSDate *)date {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getYearMonthDayString:(NSDate *)date {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getFullDateStringWithoutSecond:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getFullDateString:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDayAndMonthStringInMyMoment:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddM月"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [dateFormatter stringFromDate:date];
}

/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示          :    刚刚
 ///    2）1小时以内 显示          :    X分钟前
 ///    3）今天或者昨天 显示        :    今天 09:30   昨天 09:30 前天 09:30
 ///    4) 今年显示               :   09月12日 09:30
 ///    5) 大于本年 显示           :    09月12日 09:30
 **/

+ (NSString *)formatDateForBlog:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate * nowDate = [NSDate date];
    
    /////  取当前时间和转换时间两个日期对象的时间间隔
    /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
    NSTimeInterval time = [nowDate timeIntervalSinceDate:date];
    
    //// 再然后，把间隔的秒数折算成天数和小时数：
    
    NSString *dateStr = @"";
    
    if (time <= 60)
    {  //// 1分钟以内的
        dateStr = @"刚刚";
    }
    else if (time <= 60 * 60)
    {  ////  一个小时以内的
        int mins = time / 60;
        dateStr = [NSString stringWithFormat:@"%d分钟前", mins];
        
    }
    else if (time <= 60 * 60 * 24 * 3)
    {   //// 在三天内的
    
        [dateFormatter setDateFormat:@"HH:mm"];
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *today = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
        NSDate *beforeYearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay * 2];

        NSCalendar* calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents* comparedDateC = [calendar components:unitFlags fromDate:date];
        NSDateComponents* todayC = [calendar components:unitFlags fromDate:today];
        NSDateComponents* yearsterDayC = [calendar components:unitFlags fromDate:yearsterDay];
        NSDateComponents* beforeYearsterDayC = [calendar components:unitFlags fromDate:beforeYearsterDay];

        if ( comparedDateC.year == todayC.year && comparedDateC.month == todayC.month && comparedDateC.day == todayC.day) {
            dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:date]];
        }
        else if (comparedDateC.year == yearsterDayC.year && comparedDateC.month == yearsterDayC.month && comparedDateC.day == yearsterDayC.day)
        {
            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
        }
        else if (comparedDateC.year == beforeYearsterDayC.year && comparedDateC.month == beforeYearsterDayC.month && comparedDateC.day == beforeYearsterDayC.day)
        {
            dateStr = [NSString stringWithFormat:@"前天 %@",[dateFormatter stringFromDate:date]];
        }
        else
        {
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            dateStr = [dateFormatter stringFromDate:date];
        }
    }
    else
    {
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        dateStr = [dateFormatter stringFromDate:date];
    }
    
    return dateStr;
}

@end
