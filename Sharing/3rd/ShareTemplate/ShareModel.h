//
//  ShareModel.h
//  hfwzone
//
//  Created by star on 14/10/28.
//  Copyright (c) 2014年 hfw.kunwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject


@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *sharePic;
@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic,retain)NSDictionary *returnDic;

@end
