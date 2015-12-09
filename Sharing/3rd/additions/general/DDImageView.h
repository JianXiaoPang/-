//
//  DDImageView.h
//  dd
//
//  Created by darkdong on 13-11-28.
//  Copyright (c) 2013年 PixShow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDType.h"

@interface DDImageView : UIImageView 

@property (nonatomic) UIButton *button;
//@property (nonatomic) NSURL *url;
@property (nonatomic) BOOL cancelTrackingWhenDraggingInside;
@property (nonatomic) BOOL touchEventEnabled;

@end
