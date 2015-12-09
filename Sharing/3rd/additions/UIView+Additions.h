//
//  UIView+Additions.h
//  pxvid
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDType.h"

@interface UIView (Additions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

- (CGPoint)centerOfBounds;
- (void)resizeWithMaxWidth:(CGFloat)maxWidth;
- (void)setHeightWithoutChangingBottom:(CGFloat)height;
- (UIViewController*)viewController;
- (void)autoRemoveAfterSeconds:(NSTimeInterval)seconds animated:(BOOL)animated completion:(DDBlockVoid)completion;
- (void)autoRemoveAfterSeconds:(NSTimeInterval)seconds;
- (void)removeFromSuperviewAnimated:(BOOL)animated completion:(DDBlockVoid)completion;
- (UIView *)subviewWithClass:(Class)viewClass;
- (void)removeSubviewsByClass:(Class)viewClass;
- (void)removeAllSubviews;
- (void)disableScrollsToTopPropertyOnAllSubviews;
+ (void)layoutSubviewsHorizontally:(NSArray *)subviews insets:(UIEdgeInsets)insets verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment inFrame:(CGRect)frame;
- (void)layoutSubviewsHorizontallyWithInsets:(UIEdgeInsets)insets verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment inFrame:(CGRect)frame;
- (void)layoutSubviewsHorizontallyWithInsets:(UIEdgeInsets)insets verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment;
+ (void)layoutSubviewsVertically:(NSArray *)subviews insets:(UIEdgeInsets)insets horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment inFrame:(CGRect)frame;
- (void)layoutSubviewsVerticallyWithInsets:(UIEdgeInsets)insets horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment inFrame:(CGRect)frame;
- (void)layoutSubviewsVerticallyWithInsets:(UIEdgeInsets)insets horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment;
+ (void)layoutSubviewsGriddly:(NSArray *)subviews columns:(NSUInteger)columns gridSize:(CGSize)gridSize inFrame:(CGRect)frame;
- (void)layoutSubviewsGriddlyWithColumns:(NSUInteger)columns gridSize:(CGSize)gridSize insets:(UIEdgeInsets)insets;
- (void)layoutSubviewsGriddlyWithColumns:(NSUInteger)columns gridSize:(CGSize)gridSize;
- (void)saveState;
- (void)restoreState;
- (UIImage *)renderedImage;
@end
