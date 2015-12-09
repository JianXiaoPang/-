//
//  LDKUtil.m
//  HF2House
//
//  Created by wushou on 13-11-7.
//  Copyright (c) 2013年 星空传媒控股. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GlobalFunction.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"


@implementation GlobalFunction

//判断会员账号是否合法
+(NSInteger) checkAccountWithMember:(NSString *)username {
    
    //用户名称
    if ([self isUsername:username]) return 1;
    
    //邮箱地址
    if ([self isEmail:username]) return 2;
    
    //手机号
    if ([self isPhoneId:username]) return 3;
    
    return 0;
}

//判断手机号
+(BOOL) isPhoneId:(NSString *)string {
    NSString * regex = @"^13[0-9]{1}[0-9]{8}$|14[0-9]{1}[0-9]{8}$|15[0-9]{1}[0-9]{8}$|18[0-9]{1}[0-9]{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}

//价钱验证  整数部分最长4位，小数部分最长2位
+(BOOL) isPrice:(NSString *)string {
    NSString * regex = @"^\\d{1,4}(?:\\.\\d{0,2})?$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}

//判断身份证号
+(BOOL) isCardId:(NSString *)string {
    //    NSString *regex = @"";
    //    if (string.length == 18) {
    //        regex = @"^[1-9]d{5}[1-9]d{3}((0d)|(1[0-2]))(([0|1|2]d)|3[0-1])d{4}$";
    //    } else if (string.length == 15) {
    //        regex = @"^[1-9]d{7}((0d)|(1[0-2]))(([0|1|2]d)|3[0-1])d{3}$";
    //    } else {
    //        return FALSE;
    //    }
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    BOOL isMatch = [pred evaluateWithObject:string];
    
    return TRUE;
}

//判断用户名
+(BOOL) isUsername:(NSString *)string {
    NSString * regex = @"^[a-zA-Z]\\w{3,29}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}

//判断邮箱地址
+(BOOL) isEmail:(NSString *)string {
    NSString * regex = @"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}

//判断面积数据
+(BOOL) isAcreageWithSqM:(NSString *)string {
    NSString * regex = @"^([0-9]{0,6})(.{0,1})([0-9]{1,2})$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}

//判断是否为数字
+(BOOL)isNumber:(NSString *)string
{
    NSString * regex = @"^[0-9]*$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
    
}

+(BOOL) isAcreageWithMu:(NSString *)string {
    NSString * regex = @"^([0-9]{0,6})(.{0,1})([0-9]{1,2})$";
    //    NSString * regex = @"^[0-9]{1,6}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}


//判断真实姓名
+(BOOL) isRealName:(NSString *)string {
    NSString * regex = @"^[\u4E00-\u9FA5]{2,8}(?:·[\u4E00-\u9FA5]{2,8})*$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}
//判断网址
+(BOOL) isURL:(NSString *)string {
    NSString * regex = @"^(((ht|f)tp(s?))://)?(www.|[a-zA-Z].)[a-zA-Z0-9-.]+.(com|edu|gov|mil|net|org|biz|info|name|museum|us|ca|uk)(:[0-9]+)*(/($|[a-zA-Z0-9.,;?'+&amp;%$#=~_-]+))*$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    
    return isMatch;
}
//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIImage *)getImageFromView:(UIView *)orgView{
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *) getImageFromFullScreen {
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
}

+(BOOL)saveImage:(UIImage *)image to:(NSString *)path {
    NSData *imgData = UIImageJPEGRepresentation(image,1);
    //NSData *imgData = UIImagePNGRepresentation(image);
    
    return [imgData writeToFile:path atomically:YES];
}

+(UIImage *)readImage:(NSString *)path {
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+(NSString *)pathWithSubPath:(NSString *)subpath {
    return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), subpath];
}
+(NSString *)pathWithUser:(NSString *)userId {
    return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), userId];
}

+(NSString *)pathWithUser:(NSString *)userId theme:(NSString *)themeId {
    return [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(), userId, themeId];
}

//判断文件夹是否存在
+(BOOL)isExistWithPath:(NSString *)path {
    // 判断主题资源文件的文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        return FALSE;
    }
    return TRUE;
}

//正则表达式 替换字符串
+(NSString*)replaceStr:(NSString*)regexPattern withReplacedStr:(NSString*)str withPlaceStr:(NSString*)pstr {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:nil];
    return [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:pstr];
}

+(NSString *)createFolderWithPath:(NSString *)path {
    // 判断主题资源文件的文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create theme source Directory Failed.");
            return nil;
        }
    }
    return path;
}

//清空文件夹下所有文件
+(void)clearFilesWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager contentsOfDirectoryAtPath:path error:nil]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
}
//在指定路径下创建文件夹
+(NSString *)createFolderWithUser:(NSString *)userId theme:(NSString *)themeId {
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(), userId, themeId];
    // 判断主题资源文件的文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create theme source Directory Failed.");
            return nil;
        }
    }
    return path;
}

//剪切 文件夹
+(void)moveFolderWithPath:(NSString *)srcPath to:(NSString *)toPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *srcFile = [srcPath stringByAppendingPathComponent:fileName];
        NSString *toFile = [toPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:srcFile isDirectory:&flag]) {
            if (!flag) {
                [fileManager moveItemAtPath:srcFile toPath:toFile error:nil];
            }
        }
    }
}

//复制 文件夹
+(void)copyFolderWithPath:(NSString *)srcPath to:(NSString *)toPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *srcFile = [srcPath stringByAppendingPathComponent:fileName];
        NSString *toFile = [toPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:srcFile isDirectory:&flag]) {
            if (!flag) {
                [fileManager copyItemAtPath:srcFile toPath:toFile error:nil];
            }
        }
    }
}

//删除文件夹
+(void)removeFileWithPath:(NSString *)path {
    NSLog(@"removeFolder:%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if(isDirExist && isDir)
    {
        BOOL bCreateDir = [fileManager removeItemAtPath:path error:nil];
        if(!bCreateDir){
            NSLog(@"Remove Directory Failed.");
        }
    }
}

//删除文件
+(void)removeFile:(NSString *)name {
    NSLog(@"remove:%@",name);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isFileExist = [fileManager fileExistsAtPath:name];
    if (isFileExist) {
        BOOL bCreateDir = [fileManager removeItemAtPath:name error:nil];
        if(!bCreateDir){
            NSLog(@"Remove file Failed.");
        }
    }
}

//读取文件夹下所有的文件
+(NSMutableArray *)allFilesAtPath:(NSString *)path
{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                // ignore .DS_Store
                if (![[fileName substringToIndex:1] isEqualToString:@"."]) {
                    [pathArray addObject:fullPath];
                }
            } else {
                [pathArray addObject:[self allFilesAtPath:fullPath]];
            }
        }
    }
    
    return pathArray;
}
//读取文件夹下所有（指定类型）的文件
+(NSMutableArray *)allFilesAtPath:(NSString *)path type:(NSString *)type
{
    NSMutableArray *pathArray = [NSMutableArray array];
    NSInteger len = type.length;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSInteger lenFile = fileName.length;
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                // 指定类型匹配
                if (![[fileName substringFromIndex:(lenFile-len)] caseInsensitiveCompare:type]) {
                    [pathArray addObject:fullPath];
                }
            } else {
                [pathArray addObject:[self allFilesAtPath:fullPath]];
            }
        }
    }
    
    return pathArray;
}

+(NSString *)recombWithBirthday:(NSString *)birthday mark:(NSString *)mark {
    NSString *year = [birthday substringToIndex:4];
    NSString *month = [birthday substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [birthday substringFromIndex:6];
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",year, mark, month, mark, day];
}

+(NSInteger) ageFromBirthday:(NSString *)birthday {
    if ([birthday length] < 8) {
        return 0;
    }
    NSInteger nyear = [[birthday substringToIndex:4] integerValue];
    if (nyear == 0) {
        return 0;
    }
    NSInteger nnowYear = [[[self stringFromDate:[NSDate date] format:@"yyyyMMdd"] substringToIndex:4] integerValue];
    
    return nnowYear - nyear;
}

+(NSString *) stringFromDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//重新组织年龄段数据
+(NSString *) recombWithAges:(NSString *)ages {
    NSString *newages = @"";
    if ([ages isEqualToString:@""]) {
        return @"不限";
    }
    NSArray *array=[ages componentsSeparatedByString:@","];
    NSString *begin = [array objectAtIndex:0];
    NSString *end = [array objectAtIndex:1];
    if ([begin isEqualToString:@""]) {
        newages = [NSString stringWithFormat:@"%@ 岁以下", end];
    } else if ([end isEqualToString:@""]) {
        newages = [NSString stringWithFormat:@"%@ 岁以上", begin];
    } else {
        newages = [NSString stringWithFormat:@"%@－%@ 岁",begin,end];
    }
    
    return newages;
}

//重新组织性别数据
+(NSString *) recombWithGender:(NSString *)gender {
    NSString *newgender = @"不限";
    if ([gender isEqualToString:@"1"]) {
        newgender = @"男";
    } else if ([gender isEqualToString:@"2"]) {
        newgender = @"女";
    }
    return newgender;
}

//自定义导航栏－标题
+(UILabel *) custNavigationTitle:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor darkGrayColor];
    lbl.font = [UIFont fontWithName:@"HelveticaNeue-light" size:18.0];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    return lbl;
}

//自定义导航栏－标题
+(UILabel *) custNavigationWithRect:(CGRect)rect title:(NSString *)title {
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor darkGrayColor];
    lbl.font = [UIFont fontWithName:@"HelveticaNeue-light" size:19.0];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    return lbl;
}


//自定义导航条贴图
+(void)initNav:(UINavigationController *)nav
{
    //让你的导航条不透明,从而不占位置
    [nav.navigationBar setTranslucent:NO];
    //返回按钮
    
    //在这里设置颜色没用
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [nav.navigationBar setTintColor:[GlobalFunction hexStringToColor:@"#f4f4f4"]];
        // Load resources for iOS 6.1 or earlier
        
    } else {
        [nav.navigationBar setBarTintColor:[GlobalFunction hexStringToColor:@"#f4f4f4"]];
        
    }
}

//写入数据到plist文件
+(NSMutableDictionary*)saveToPlistWithMessage:(NSString *)message key:(NSString *)key
{
    NSString *sysKey = @"XKHouse";
    //获取路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"hfhouseset.plist"];
    NSMutableDictionary *applist = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] mutableCopy];
    
    NSMutableDictionary *info = [applist objectForKey:sysKey];
    NSString *value = [info objectForKey:key];
    if (![message isEqualToString:@""]) {
        value = message;
    }
    [info setValue:value forKey:key];
    
    [applist setValue:info forKey:sysKey];
    //写入文件
    [applist writeToFile:path atomically:YES];
    return applist;
}

//删除一行数据
+(NSMutableDictionary*)removeToPlistByKey:(NSString *)key
{
    NSString *sysKey = @"XKHouse";
    //获取路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"hfhouseset.plist"];
    NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
    NSMutableDictionary *info = [applist objectForKey:sysKey];
    [info removeObjectForKey:key];
    
    [applist setValue:info forKey:sysKey];
    //写入文件
    [applist writeToFile:path atomically:YES];
    
    return applist;
    
}
//读取一行数据
+(NSString *)readValueToPlistByKey:(NSString *)key
{
    NSString *sysKey = @"XKHouse";
    //获取路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"hfhouseset.plist"];
    NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
    NSMutableDictionary *info = [applist objectForKey:sysKey];
    if (info != nil) {
        return [info objectForKey:key];
    }
    return @"";
}

+(void) initPlist {
    NSString *sysKey = @"XKHouse";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"hfhouseset.plist"];
    //判断是否以创建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        //        //此处可以自己写显示plist文件内容
        //        NSLog(@"文件已存在");
        //    } else {
        //如果没有plist文件就自动创建
        NSMutableDictionary *dictplist = [[NSMutableDictionary alloc ] init];
        NSMutableDictionary *dicttxt = [[NSMutableDictionary alloc ] init];
        [dictplist setObject:dicttxt forKey:sysKey];
        //写入文件
        [dictplist writeToFile:plistPath atomically:YES];
    }
}

//星空传媒－图片路径转换(type:B大图，S小图)
+(NSString *) changeImageUrlWithFilename:(NSString *)filename type:(NSString *)type {
    NSString *tempFilename = filename;
    if (tempFilename.length < 11) {
        return @"http://news.hfhouse.com/images/noimage.jpg";
    }
    if ([[filename substringToIndex:7] isEqualToString:@"http://"]) {
        if ([type isEqualToString:@"B"]) {
            return [filename stringByReplacingOccurrencesOfString:@"cache_s" withString:@"cache_b"];
        } else {
            return [filename stringByReplacingOccurrencesOfString:@"cache_b" withString:@"cache_s"];
        }
    }
    NSString *path = @"";
    NSString *typePath = @"cache_s";
    if ([type isEqualToString:@"B"]) {
        typePath = @"cache_b";
    }
    NSString *submark = [[tempFilename substringFromIndex:2] substringToIndex:6];
    
    if ([submark intValue] > 110903) {
        path = [NSString stringWithFormat:@"http://img5.hfhouse.com/oldhouse/%@",typePath];
    } else if ([submark intValue] > 100817) {
        path = [NSString stringWithFormat:@"http://img3.hfhouse.com/oldhouse/%@",typePath];
    } else {
        path = [NSString stringWithFormat:@"http://img2.hfhouse.com/oldhouse/%@",typePath];
    }
    NSString *year = [[filename substringFromIndex:2] substringToIndex:2];
    NSString *day = [[filename substringFromIndex:4] substringToIndex:4];
    
    return [NSString stringWithFormat:@"%@/%@/%@/%@",path,year,day,filename];
}

+ (CGSize) sizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //设置一个行高上限
    CGSize size = CGSizeMake(maxWidth, maxHeight);
    //计算实际frame大小，并将label的frame变成实际大小
    return [text sizeWithFont:font constrainedToSize:size];
}

//画虚线  addBy Ting
+(void )drawDottedLine:(UIImageView *)img{
    UIGraphicsBeginImageContext(img.frame.size);   //开始画线
    [img.image drawInRect:CGRectMake(0, 0, img.frame.size.width, img.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[] = {3,3};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor grayColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 5.0);    //开始画线
    CGContextAddLineToPoint(line, kDeviceWidth - 10, 5.0);
    CGContextStrokePath(line);
    img.image = UIGraphicsGetImageFromCurrentImageContext();
}

+(NSString *)getSystimeNow
{
    NSDate *selected = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat stringFromDate:selected];
}



//删除数据
+ (void)removeHouseCity {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HouseCityData"];
}

+(void) addLeftBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    } else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -16;
    }
    
    vc.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
}

+(void) addRightBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    } else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -15;
    }
    vc.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
}
+(void) addRightBarButtonItem:(UIViewController *)vc items:(NSArray *)items {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    } else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -16;
    }
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:negativeSpacer];
    for (UIBarButtonItem *item in items) {
        [array addObject:item];
    }
    vc.navigationItem.rightBarButtonItems = array;
}

+(NSString *) changetoDatetimeFrom:(NSInteger )datetime{
    NSString *temp = @"";
    
    //等于0的时候反回空
    if(datetime ==0 ){
        return temp;
    }
    
    NSDate *timestmp = [NSDate dateWithTimeIntervalSince1970:datetime];
    temp = [self stringFromDate:timestmp format:@"yyyy-MM-dd HH:mm:ss"];
    
    return temp;
}

+ (void) createDatabaseFromResourcePathWithName:(NSString *)dbname {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbname];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (!success) {
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbname];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}


#define BUFFER_SIZE 1024 * 100
//+ (void) shareToWeixinAppWithTitle:(NSString *)title desc:(NSString *)desc url:(NSString *)url image:(NSString *)image {
//
//
//
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = title;
//    message.description = desc;
//    [message setThumbImage:[UIImage imageNamed:image]];
//
//    WXAppExtendObject *ext = [WXAppExtendObject object];
//    ext.extInfo = @"<xml>extend info</xml>";
//    ext.url = url;
//
//    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
//    memset(pBuffer, 0, BUFFER_SIZE);
//    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
//    free(pBuffer);
//
//    ext.fileData = data;
//    message.mediaObject = ext;
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = WXSceneTimeline;
//
//    [WXApi sendReq:req];
//
//}

+(void)beginAnimations:(NSTimeInterval)AnimationTime
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:AnimationTime];
}


+(void)endAnimations
{
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


//计算时间差
+(NSString *) compareCurrentTime:(NSDate*) compareDate{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    //    else if((temp = temp/24) <30){
    //        result = [NSString stringWithFormat:@"%d天前",temp];
    //    }
    //
    //    else if((temp = temp/30) <12){
    //        result = [NSString stringWithFormat:@"%d月前",temp];
    //    }
    //    else{
    //        temp = temp/12;
    //        result = [NSString stringWithFormat:@"%d年前",temp];
    //    }
    
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    
    return  result;
}

//过滤HTML标签
+ (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return html;
}



//拉伸图片方法
+(UIImage *)imageTensile:(UIImage *)image withEdgeInset:(UIEdgeInsets)edgeInsets{
    
    image = [image resizableImageWithCapInsets:edgeInsets];
    
    return image;
}

//设置线
+(void)setLineStyle:(UILabel *)lbl{
    
    float height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        height  =1;
        lbl.backgroundColor=[GlobalFunction hexStringToColor:@"#dadada"];
    } else {
        height =0.5;
        // Load resources for iOS 7 or later
        lbl.backgroundColor=[GlobalFunction hexStringToColor:@"#cccccc"];
    }
    
    
    lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, lbl.frame.size.width, height);
    
}

+(void)setLineStyle:(UILabel *)lbl withColor :(UIColor *)lineColor{
    lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, lbl.frame.size.width, 0.5);
    lbl.backgroundColor=lineColor;
}

+ (void)makeToast:(NSString *)message duration:(float)duration HeightScale:(float)scale
{
    
    UIWindow *toastDisplaywindow = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
    {
        if (![[testWindow class] isEqual:[UIWindow class]])
        {
            toastDisplaywindow = testWindow;
            break;
        }
    }
    [toastDisplaywindow makeToast:message duration:duration HeightScale:scale];
}


 

@end







