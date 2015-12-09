//
//  LDKUtil.h
//  HF2House
//
//  Created by wushou on 13-11-7.
//  Copyright (c) 2013年 星空传媒控股. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalFunction : NSObject
//创建UUID编号
//+(NSString *) UUID;

//判断手机号
+(BOOL) isPhoneId:(NSString *)string;
//判断身份证
+(BOOL) isCardId:(NSString *)string;
//判断用户名
+(BOOL) isUsername:(NSString *)string;

//判断邮箱地址
+(BOOL) isEmail:(NSString *)string;

//判断会员账号是否合法
+(NSInteger) checkAccountWithMember:(NSString *)username;

//判断面积数据
+(BOOL) isAcreageWithSqM:(NSString *)string;
+(BOOL) isAcreageWithMu:(NSString *)string;
//判断是否为数字
+(BOOL)isNumber:(NSString *)string;

//判断真实姓名
+(BOOL) isRealName:(NSString *)string;

//价格验证
+(BOOL) isPrice:(NSString *)string;

//判断网址
+(BOOL) isURL:(NSString *)string;

//星空传媒－图片路径转换(type:B大图，S小图)
+(NSString *) changeImageUrlWithFilename:(NSString *)filename type:(NSString *)type;

//正则表达式 替换字符串
+(NSString*)replaceStr:(NSString*)regexPattern withReplacedStr:(NSString*)str withPlaceStr:(NSString*)pstr;

//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

+(UIImage *)getImageFromView:(UIView *)orgView;
+(UIImage *) getImageFromFullScreen;

+(BOOL)saveImage:(UIImage *)image to:(NSString *)path;
+(UIImage *)readImage:(NSString *)path;

//读取文件夹下所有的文件
+(NSMutableArray *)allFilesAtPath:(NSString *)path;
//读取文件夹下所有指定类型的文件
+(NSMutableArray *)allFilesAtPath:(NSString *)path type:(NSString *)type;
//根据 相对路径 生成文件目录
+(NSString *)pathWithSubPath:(NSString *)subpath;
//根据 用户编号 生成文件目录
+(NSString *)pathWithUser:(NSString *)userId;
//根据用户编号、主题编号 生成文件目录
+(NSString *)pathWithUser:(NSString *)userId theme:(NSString *)themeId;
//判断文件夹是否存在
+(BOOL)isExistWithPath:(NSString *)path;
//创建文件目录（path）
+(NSString *)createFolderWithPath:(NSString *)path;
//在指定路径下创建文件夹(userId)
+(NSString *)createFolderWithUser:(NSString *)userId theme:(NSString *)themeId;

//剪切 文件夹
+(void)moveFolderWithPath:(NSString *)srcPath to:(NSString *)toPath;
//复制 文件夹
+(void)copyFolderWithPath:(NSString *)srcPath to:(NSString *)toPath;
//清空文件夹下所有文件
+(void)clearFilesWithPath:(NSString *)path;
//删除文件夹
+(void)removeFileWithPath:(NSString *)path;
//删除文件
+(void)removeFile:(NSString *)name;

+(NSString *)recombWithBirthday:(NSString *)birthday mark:(NSString *)mark;
+(NSInteger) ageFromBirthday:(NSString *)birthday;
+(NSString *) stringFromDate:(NSDate *)date format:(NSString *)format;

//重新组织年龄段数据
+(NSString *) recombWithAges:(NSString *)ages;
//重新组织性别数据
+(NSString *) recombWithGender:(NSString *)gender;


//自定义导航栏
+(UILabel *) custNavigationTitle:(NSString *)title;
//自定义导航栏－标题
+(UILabel *) custNavigationWithRect:(CGRect)rect title:(NSString *)title;
//自定义导航条贴图
+(void)initNav:(UINavigationController *)nav;
//自定义导航条贴图
//+(void)initNavBar:(UINavigationBar *)navbar;

//初始化plist文件
+(void) initPlist;
//写入数据到plist文件
+(NSMutableDictionary*)saveToPlistWithMessage:(NSString *)message key:(NSString *)key;
//删除一行数据
+(NSMutableDictionary*)removeToPlistByKey:(NSString *)key;
//读取一行数据
+(NSString *)readValueToPlistByKey:(NSString *)key;

// 计算文本在控件的大小
+ (CGSize) sizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight fontSize:(CGFloat)fontSize;

+(void) addLeftBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item;
+(void) addRightBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item;
+(void) addRightBarButtonItem:(UIViewController *)vc items:(NSArray *)items;


+(NSString *) changetoDatetimeFrom:(NSInteger )datetime;
+ (void) createDatabaseFromResourcePathWithName:(NSString *)dbname;

//+ (void) shareToWeixinAppWithTitle:(NSString *)title desc:(NSString *)desc url:(NSString *)url image:(NSString *)image;


//add by Ting
//画虚线
+(void )drawDottedLine:(UIImageView *)img;
//得到系当前时间
+(NSString *)getSystimeNow;
//简单的开始动画
+(void)beginAnimations:(NSTimeInterval)AnimationTime;
+(void)endAnimations;

//add by Ting
+(NSString *) compareCurrentTime:(NSDate*) compareDate;

+ (NSString *)flattenHTML:(NSString *)html;

//拉按图片方法...
+(UIImage *)imageTensile:(UIImage *)image withEdgeInset:(UIEdgeInsets )edgeInsets;

//设置线
+(void)setLineStyle:(UILabel *)lbl;

+(void)setLineStyle:(UILabel *)lbl withColor :(UIColor *)lineColor;

/**
 *  在屏幕上显示toast
 *
 *  @param message  显示的信息
 *  @param duration 显示的时间
 *  @param scale    在整个屏幕的位置, 从上到下 (0.0 - 1.0)
 */
+ (void)makeToast:(NSString *)message duration:(float)duration HeightScale:(float)scale;





@end




