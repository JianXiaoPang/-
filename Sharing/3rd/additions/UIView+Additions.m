//
//  UIView+Additions.m
//  pxvid
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Additions.h"
#import "NSObject+Additions.h"

@implementation UIView (Additions)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)centerOfBounds {
    return CGPointMake(self.width / 2, self.height / 2);
}

- (void)resizeWithMaxWidth:(CGFloat)maxWidth {
    if (self.width <= maxWidth) {
        return;
    }
    float scale = maxWidth / self.width;
    self.size = CGSizeMake(maxWidth, self.height * scale);
}

- (void)setHeightWithoutChangingBottom:(CGFloat)height {
    CGRect frame = self.frame;
    frame.origin.y += frame.size.height - height;
    frame.size.height = height;
    self.frame = frame;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)autoRemoveAfterSeconds:(NSTimeInterval)seconds animated:(BOOL)animated completion:(DDBlockVoid)completion {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeFromSuperviewAnimated:animated completion:completion];
    });
}

- (void)autoRemoveAfterSeconds:(NSTimeInterval)seconds {
    [self autoRemoveAfterSeconds:seconds animated:YES completion:NULL];
}

- (void)removeFromSuperviewAnimated:(BOOL)animated completion:(DDBlockVoid)completion {
    if (animated) {
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             if (completion) {
                                 completion();
                             }
                         }];
    }else {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }
}

- (UIView *)subviewWithClass:(Class)viewClass {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewClass]) {
            return view;
        }
    }
    return nil;
}

- (void)removeSubviewsByClass:(Class)viewClass {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewClass]) {
            [view removeFromSuperview];
        }
    }
}

- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)disableScrollsToTopPropertyOnAllSubviews {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).scrollsToTop = NO;
        }
        [subview disableScrollsToTopPropertyOnAllSubviews];
    }
}

+ (void)layoutSubviewsHorizontally:(NSArray *)subviews insets:(UIEdgeInsets)insets verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment inFrame:(CGRect)frame {
    NSMutableArray *visibleSubviews = [NSMutableArray arrayWithArray:subviews];
    NSIndexSet *indexes = [visibleSubviews indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isHidden];
    }];
    [visibleSubviews removeObjectsAtIndexes:indexes];
    
    NSUInteger subviewsCount = visibleSubviews.count;
    if (0 == subviewsCount) {
        return;
    }
    
    if (1 == subviewsCount) {
        UIView *subview = [visibleSubviews objectAtIndex:0];
        if (0 == insets.left && 0 == insets.right) {
            subview.centerX = CGRectGetMidX(frame);
        }else if (insets.left) {
            subview.left = CGRectGetMinX(frame) + insets.left;
        }else {
            subview.right = CGRectGetMaxX(frame) - insets.right;
        }
        if (insets.top) {
            subview.top = CGRectGetMinY(frame) + insets.top;
        }else if (insets.bottom) {
            subview.bottom = CGRectGetMaxY(frame) - insets.bottom;
        }else {
            //没有设置insets的top或者bottom，使用verticalAlignment
            if (UIControlContentVerticalAlignmentTop == verticalAlignment) {
                subview.top = CGRectGetMinY(frame);
            }else if (UIControlContentVerticalAlignmentBottom == verticalAlignment) {
                subview.bottom = CGRectGetMaxY(frame);
            }else {
                subview.centerY = CGRectGetMidY(frame);
            }
        }
    }else {
        CGFloat totalSubviewsWidth = 0;
        for (UIView *subview in visibleSubviews) {
            totalSubviewsWidth += subview.width;
        }
        
        CGFloat spacing = (CGRectGetWidth(frame) - insets.left - insets.right - totalSubviewsWidth) / (subviewsCount - 1);
        CGFloat x = CGRectGetMinX(frame) + insets.left;
        CGFloat y;
        
        for (UIView *subview in visibleSubviews) {
            if (insets.top) {
                y = CGRectGetMinY(frame) + insets.top;
            }else if (insets.bottom) {
                y = CGRectGetMaxY(frame) - insets.bottom - subview.height;
            }else {
                //没有设置insets的top或者bottom，使用verticalAlignment
                if (UIControlContentVerticalAlignmentTop == verticalAlignment) {
                    y = CGRectGetMinY(frame);
                }else if (UIControlContentVerticalAlignmentBottom == verticalAlignment) {
                    y = CGRectGetMaxY(frame) - subview.height;
                }else {
                    y = CGRectGetMidY(frame) - subview.height / 2;
                }
            }
            subview.origin = CGPointMake(x, y);
            x += subview.width + spacing;
        }
    }
}

- (void)layoutSubviewsHorizontallyWithInsets:(UIEdgeInsets)insets verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment inFrame:(CGRect)frame {
    [UIView layoutSubviewsHorizontally:self.subviews insets:insets verticalAlignment:verticalAlignment inFrame:frame];
}

- (void)layoutSubviewsHorizontallyWithInsets:(UIEdgeInsets)insets verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment {
    [self layoutSubviewsHorizontallyWithInsets:insets verticalAlignment:verticalAlignment inFrame:self.bounds];
}

+ (void)layoutSubviewsVertically:(NSArray *)subviews insets:(UIEdgeInsets)insets horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment inFrame:(CGRect)frame {
    NSMutableArray *visibleSubviews = [NSMutableArray arrayWithArray:subviews];
    NSIndexSet *indexes = [visibleSubviews indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isHidden];
    }];
    [visibleSubviews removeObjectsAtIndexes:indexes];
    
    NSUInteger subviewsCount = visibleSubviews.count;
    if (0 == subviewsCount) {
        return;
    }
    
    if (1 == subviewsCount) {
        UIView *subview = [visibleSubviews objectAtIndex:0];
        if (0 == insets.top && 0 == insets.bottom) {
            subview.centerY = CGRectGetMidY(frame);
        }else if (insets.top) {
            subview.top = CGRectGetMinY(frame);
        }else {
            subview.bottom = CGRectGetMaxY(frame) - insets.bottom;
        }
        if (insets.left) {
            subview.left = CGRectGetMinX(frame) + insets.left;
        }else if (insets.right) {
            subview.right = CGRectGetMaxX(frame) - insets.right;
        }else {
            //没有设置insets的left或者right，使用horizontalAlignment
            if (UIControlContentHorizontalAlignmentLeft == horizontalAlignment) {
                subview.left = CGRectGetMinX(frame);
            }else if (UIControlContentHorizontalAlignmentRight == horizontalAlignment) {
                subview.right = CGRectGetMaxX(frame);
            }else {
                subview.centerX = CGRectGetMidX(frame);
            }
        }
    }else {
        CGFloat totalSubviewsHeight = 0;
        for (UIView *subview in visibleSubviews) {
            totalSubviewsHeight += subview.height;
        }
        
        CGFloat spacing = (CGRectGetHeight(frame) - insets.top - insets.bottom - totalSubviewsHeight) / (subviewsCount - 1);
        CGFloat y = CGRectGetMinY(frame) + insets.top;
        CGFloat x;
        
        for (UIView *subview in visibleSubviews) {
            if (insets.left) {
                x = CGRectGetMinX(frame) + insets.left;
            }else if (insets.right) {
                x = CGRectGetMaxX(frame) - insets.right - subview.width;
            }else {
                //没有设置insets的left或者right，使用horizontalAlignment
                if (UIControlContentHorizontalAlignmentLeft == horizontalAlignment) {
                    x = CGRectGetMinX(frame);
                }else if (UIControlContentHorizontalAlignmentRight == horizontalAlignment) {
                    x = CGRectGetMaxX(frame) - subview.width;
                }else {
                    x = CGRectGetMidX(frame) - subview.width / 2;
                }
            }
            subview.origin = CGPointMake(x, y);
            y += subview.height + spacing;
        }
    }
}
- (void)layoutSubviewsVerticallyWithInsets:(UIEdgeInsets)insets horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment inFrame:(CGRect)frame {
    [UIView layoutSubviewsVertically:self.subviews insets:insets horizontalAlignment:horizontalAlignment inFrame:frame];
}

- (void)layoutSubviewsVerticallyWithInsets:(UIEdgeInsets)insets horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment {
    [self layoutSubviewsVerticallyWithInsets:insets horizontalAlignment:horizontalAlignment inFrame:self.bounds];
}

+ (void)layoutSubviewsGriddly:(NSArray *)subviews columns:(NSUInteger)columns gridSize:(CGSize)gridSize inFrame:(CGRect)frame {
    if (columns <= 1 ) {
        [self layoutSubviewsVertically:subviews insets:UIEdgeInsetsZero horizontalAlignment:0 inFrame:frame];
        return;
    }
    
    NSMutableArray *visibleSubviews = [NSMutableArray arrayWithArray:subviews];
    NSIndexSet *indexes = [visibleSubviews indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isHidden];
    }];
    [visibleSubviews removeObjectsAtIndexes:indexes];
    
    NSUInteger rows = (visibleSubviews.count + columns - 1) / columns;
    
    CGFloat vspacing = rows <= 1? 0: (CGRectGetHeight(frame) - rows * gridSize.height) / (rows - 1);
    CGFloat hspacing = (CGRectGetWidth(frame) - columns * gridSize.width) / (columns - 1);
    
    CGFloat x = CGRectGetMinX(frame);
    CGFloat y = CGRectGetMinY(frame);
    
    NSUInteger index = 0;
    for (UIView* subview in visibleSubviews) {
        if (index > 0 && 0 == index % columns) {
            //换行
            x = CGRectGetMinX(frame);
            y += gridSize.height + vspacing;
        }
        subview.origin = CGPointMake(x, y);
        x += gridSize.width + hspacing;
        index++;
    }
}

- (void)layoutSubviewsGriddlyWithColumns:(NSUInteger)columns gridSize:(CGSize)gridSize insets:(UIEdgeInsets)insets {
    CGRect frame = self.bounds;
    frame.origin.x += insets.left;
    frame.origin.y += insets.top;
    frame.size.width -= insets.left + insets.right;
    frame.size.height -= insets.top + insets.bottom;
    return [UIView layoutSubviewsGriddly:self.subviews columns:columns gridSize:gridSize inFrame:frame];
}

- (void)layoutSubviewsGriddlyWithColumns:(NSUInteger)columns gridSize:(CGSize)gridSize {
    return [self layoutSubviewsGriddlyWithColumns:columns gridSize:gridSize insets:UIEdgeInsetsZero];
}

- (void)saveState {
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{
                                 @"frame": [NSValue valueWithCGRect:self.frame],
                                  }];
    if (self.superview) {
        mdic[@"superview"] = self.superview;
    }
    self.associatedObject = [mdic copy];
}

- (void)restoreState {
    NSDictionary *dic = self.associatedObject;
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    UIView *superview = dic[@"superview"];
    if (superview) {
        [superview addSubview:self];
    }
    
    CGRect frame = [dic[@"frame"] CGRectValue];
    self.frame = frame;
    
    self.associatedObject = nil;
}

- (UIImage *)renderedImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
