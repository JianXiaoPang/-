//
//  UIImage+Additions.h
//  liumiao
//
//  Created by darkdong on 13-4-26.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage *)imageNamedNoCache:(NSString *)name;
+ (UIImage *)stretchableImageNamedNoCache:(NSString *)name;
+ (UIImage *)stretchableImageNamed:(NSString *)name;

//- (UIImage *)croppedImage:(CGRect)rect withImageOrientation:(UIImageOrientation)imageOrientation;
- (UIImage *)imageByCroppingToRect:(CGRect)rect;
- (UIImage *)imageByCroppingToZoom:(float)zoomFactor;
- (UIImage *)imageBySquaring;
- (UIImage *)imageByScaling:(float)scaleFactor;
- (UIImage *)imageByRotating:(CGFloat)radian;
- (UIImage *)imageByResizing:(CGSize)newSize;
- (UIImage *)imageByResizing:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)imageToFitSize:(CGSize)newSize;
- (UIImage *)imageToFillSize:(CGSize)newSize;

- (void)print:(NSString *)prefix;

@end
