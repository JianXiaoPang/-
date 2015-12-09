//
//  UIImage+Additions.m
//  liumiao
//
//  Created by darkdong on 13-4-26.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import "UIImage+Additions.h"

#define MAKE_IMAGE_ORIENTATION_UP_AFTER_RESIZE

@implementation UIImage (Additions)

+ (UIImage *)imageNamedNoCache:(NSString *)name {
    NSArray *baseNames = @[[name stringByAppendingString:@"@2x"], name];
    NSArray *extNames = @[@"png", @"jpg"];
    NSBundle *bundle = [NSBundle mainBundle];
    for (NSString *extName in extNames) {
        for (NSString *baseName in baseNames) {
            NSString *path = [bundle pathForResource:baseName ofType:extName];
            if (path) {
                return [UIImage imageWithContentsOfFile:path];
            }
        }
    }
    return nil;
}

+ (UIImage *)stretchableImageNamedNoCache:(NSString *)name {
    UIImage *image = [self imageNamedNoCache:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

+ (UIImage *)stretchableImageNamed:(NSString *)name {
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

//rect是相对UIImageOrientationUp方向,并且不考虑image.scale,最终的image方向不变
//- (UIImage *)croppedImage:(CGRect)rect withImageOrientation:(UIImageOrientation)imageOrientation {
//    CGFloat width = CGRectGetWidth(rect);
//    CGFloat height = CGRectGetHeight(rect);
//    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    switch (imageOrientation) {
//        case UIImageOrientationRight:
//            //相对image自己的坐标系逆时针旋转90°
//            transform = CGAffineTransformMakeRotation(-M_PI_2);
//            //相对image自己的坐标系向负x轴移动width
//            transform = CGAffineTransformTranslate(transform, -width, 0);
//            break;
//        case UIImageOrientationLeft:
//            //相对image自己的坐标系顺时针旋转90°
//            transform = CGAffineTransformMakeRotation(M_PI_2);
//            //相对image自己的坐标系向负y轴移动height
//            transform = CGAffineTransformTranslate(transform, 0, -height);
//            break;
//        case UIImageOrientationDown:
//            //相对image自己的坐标系顺时针旋转180°
//            transform = CGAffineTransformMakeRotation(M_PI);
//            //相对image自己的坐标系向负x轴移动width,向负y轴移动height
//            transform = CGAffineTransformTranslate(transform, -width, -height);
//            break;
//        case UIImageOrientationUpMirrored:
//            //相对image自己的坐标系以y为轴翻转
//            transform = CGAffineTransformMakeScale(-1, 1);
//            //现在image是趴着的,相对image自己的坐标系向负x轴移动width
//            transform = CGAffineTransformTranslate(transform, -width, 0);
//            break;
//        case UIImageOrientationDownMirrored:
//            //相对image自己的坐标系顺时针旋转180°
//            transform = CGAffineTransformMakeRotation(M_PI);
//            //相对image自己的坐标系以y为轴翻转
//            transform = CGAffineTransformScale(transform, -1, 1);
//            //现在image是趴着的,相对image自己的坐标系向负y轴移动height
//            transform = CGAffineTransformTranslate(transform, 0, -height);
//            break;
//        case UIImageOrientationLeftMirrored:
//            //相对image自己的坐标系顺时针旋转90°
//            transform = CGAffineTransformMakeRotation(M_PI_2);
//            //相对image自己的坐标系以x为轴翻转
//            transform = CGAffineTransformScale(transform, 1, -1);
//            break;
//        case UIImageOrientationRightMirrored:
//            //相对image自己的坐标系逆时针旋转90°
//            transform = CGAffineTransformMakeRotation(-M_PI_2);
//            //相对image自己的坐标系以x为轴翻转
//            transform = CGAffineTransformScale(transform, 1, -1);
//            //现在image是趴着的,相对image自己的坐标系向负x轴移动width,向负y轴移动height
//            transform = CGAffineTransformTranslate(transform, -width, -height);
//            break;
//        default:
//            break;
//    }
//    //计算出当前imageOrientation下的变换rect
//    CGRect transformedRect = CGRectApplyAffineTransform(rect, transform);
//    return [self croppedImage:transformedRect];
//}

- (UIImage *)imageByCroppingToRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)imageByCroppingToZoom:(float)zoomFactor {
    CGSize originalSize = self.size;
    if (UIImageOrientationLeft == self.imageOrientation
        || UIImageOrientationRight == self.imageOrientation) {
        //交换 宽 高
        originalSize = CGSizeMake(originalSize.height, originalSize.width);
    }
    CGSize zoomSize = CGSizeMake(originalSize.width / zoomFactor, originalSize.height / zoomFactor);
    CGRect zoomRect = CGRectMake((originalSize.width - zoomSize.width) / 2, (originalSize.height - zoomSize.height) / 2, zoomSize.width, zoomSize.height);
    return [self imageByCroppingToRect:zoomRect];
}

- (UIImage *)imageBySquaring {
    float squareSideLength = MIN(self.size.width, self.size.height);    
    CGRect rect = CGRectMake((self.size.width - squareSideLength) / 2, (self.size.height - squareSideLength) / 2, squareSideLength, squareSideLength);
    return [self imageByCroppingToRect:rect];
}

- (UIImage *)imageByScaling:(float)scaleFactor {
	CGSize scaledSize = CGSizeMake(self.size.width * scaleFactor, self.size.height * scaleFactor);
	return [self imageByResizing:scaledSize];
}

- (UIImage *)imageByRotating:(CGFloat)radian {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radian);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, radian);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByResizing:(CGSize)newSize {
#ifdef MAKE_IMAGE_ORIENTATION_UP_AFTER_RESIZE
    //最终的image方向为UIImageOrientationUp
    return [self imageByResizing:newSize interpolationQuality:kCGInterpolationDefault];
#else
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale));
	size_t destWidth = CGRectGetWidth(newRect);//(size_t)(newSize.width * self.scale);
	size_t destHeight = CGRectGetHeight(newRect);//(size_t)(newSize.height * self.scale);
	if (self.imageOrientation == UIImageOrientationLeft
		|| self.imageOrientation == UIImageOrientationLeftMirrored
		|| self.imageOrientation == UIImageOrientationRight
		|| self.imageOrientation == UIImageOrientationRightMirrored)
	{
		size_t temp = destWidth;
		destWidth = destHeight;
		destHeight = temp;
	}
    
    /// Create an ARGB bitmap context
    static CGColorSpaceRef rgbColorSpace = NULL;
    if (!rgbColorSpace) {
        rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGContextRef bmContext = CGBitmapContextCreate(NULL, destWidth, destHeight, 8/*Bits per component*/, destWidth * 4, rgbColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
	if (!bmContext)
		return nil;
    
	/// Image quality
	CGContextSetShouldAntialias(bmContext, true);
	CGContextSetAllowsAntialiasing(bmContext, true);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
	/// Draw the image in the bitmap context
    
	UIGraphicsPushContext(bmContext);
    CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), self.CGImage);
	UIGraphicsPopContext();
    
	/// Create an image object from the context
	CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
	UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:self.scale orientation:self.imageOrientation];
    
	/// Cleanup
	CGImageRelease(scaledImageRef);
	CGContextRelease(bmContext);
    
	return scaled;
#endif
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)imageByResizing:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

- (UIImage *)imageToFitSize:(CGSize)newSize {
	/// Keep aspect ratio
	size_t destWidth, destHeight;
	if (self.size.width > self.size.height) {
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}else {
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	if (destWidth > newSize.width) {
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	if (destHeight > newSize.height) {
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	return [self imageByResizing:CGSizeMake(destWidth, destHeight)];
}

- (UIImage *)imageToFillSize:(CGSize)newSize
{
	size_t destWidth, destHeight;
	CGFloat widthRatio = newSize.width / self.size.width;
	CGFloat heightRatio = newSize.height / self.size.height;
	/// Keep aspect ratio
	if (heightRatio > widthRatio) {
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}else {
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	return [self imageByResizing:CGSizeMake(destWidth, destHeight)];
}

- (void)print:(NSString *)prefix {
#ifdef DEBUG
    if (0 == prefix.length) {
        prefix = @"UIImage";
    }
    NSString *orientationString = @"";
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            orientationString = @"UIImageOrientationUp";
            break;
        case UIImageOrientationDown:
            orientationString = @"UIImageOrientationDown";
            break;
        case UIImageOrientationLeft:
            orientationString = @"UIImageOrientationLeft";
            break;
        case UIImageOrientationRight:
            orientationString = @"UIImageOrientationRight";
            break;
        case UIImageOrientationUpMirrored:
            orientationString = @"UIImageOrientationUpMirrored";
            break;
        case UIImageOrientationDownMirrored:
            orientationString = @"UIImageOrientationDownMirrored";
            break;
        case UIImageOrientationLeftMirrored:
            orientationString = @"UIImageOrientationLeftMirrored";
            break;
        case UIImageOrientationRightMirrored:
            orientationString = @"UIImageOrientationRightMirrored";
            break;
        default:
            break;
    }
    orientationString = [orientationString stringByAppendingFormat:@" (%d) ", self.imageOrientation];
//    NSData *imageData = UIImageJPEGRepresentation(self, 1);
//    NSLog(@"%@: imageData.length %u size %@ orientation %@ scale %f", prefix, imageData.length, NSStringFromCGSize(self.size), orientationString, self.scale);
#endif
}

#pragma mark - private

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
		    
        default:
            break;
    }
    
    return transform;
}

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale));;
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
#if 1
    static CGColorSpaceRef rgbColorSpace = NULL;
    if (!rgbColorSpace) {
        rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8/*Bits per component*/,
                                                newRect.size.width * 4,
                                                rgbColorSpace,
                                                kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
#else
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
#endif
//    if (NULL == bitmap) {
//        imageRef = [[self normalize] CGImage];
//        bitmap = CGBitmapContextCreate(NULL,
//                                       newRect.size.width,
//                                       newRect.size.height,
//                                       CGImageGetBitsPerComponent(imageRef),
//                                       0,
//                                       CGImageGetColorSpace(imageRef),
//                                       CGImageGetBitmapInfo(imageRef));
//    }
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    
    //image orientation has been handled before, so now it's always assumed UIImageOrientationUp
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end
