//
//  FenXiangBaseModel.h
//  fenxiang
//
//  Created by 磊 on 15/9/18.
//  Copyright © 2015年 fenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenXiangBaseModel : NSObject<NSCoding>{
    
}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串


@end
