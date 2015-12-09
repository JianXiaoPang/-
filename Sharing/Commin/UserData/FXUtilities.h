//
//  FXUtilities.h
//  fenxiang
//
//  Created by 磊 on 15/9/19.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXUtilities : NSObject

//MD5编码
+ (NSString *)md5:(NSString *)str;
//归档的在沙盒中的路径
+ (NSString *)archivePath:(NSString *)pkId;
@end

