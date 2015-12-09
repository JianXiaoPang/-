//
//  UIView+LXAnimation.m
//  hfwzone
//
//  Created by hfhouse on 14/11/28.
//  Copyright (c) 2014年 hfw.xianli. All rights reserved.
//

#import "UIView+LXAnimation.h"

static AnimationFinishedBlockType popOutAnimationblock;
static AnimationFinishedBlockType rotationAnimationblock;

#define kPopOutAnimation                @"PopOut"
#define kRotation180Animation           @"Rotation180"

@implementation UIView (LXAnimation)

- (void)startPopOutAnimation:(AnimationFinishedBlockType)block
{
    if (popOutAnimationblock)
    {
        return;
    }
    popOutAnimationblock = block;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1.0),@(1.4),@(1.6),@(1.4),@(1.0)];
    animation.keyTimes = @[@(0.0),@(0.2),@(0.5),@(0.8),@(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    
    [self.layer addAnimation:animation forKey:kPopOutAnimation];
}

- (void)startRotation180Animation:(NSTimeInterval)duration complete:(AnimationFinishedBlockType)block
{
    if (rotationAnimationblock)
    {
        return;
    }
    rotationAnimationblock = block;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D rotation1 = CATransform3DMakeRotation(-30 * M_PI/180, 0, 0, -1);
    CATransform3D rotation2 = CATransform3DMakeRotation(-60 * M_PI/180, 0, 0, -1);
    CATransform3D rotation3 = CATransform3DMakeRotation(-90 * M_PI/180, 0, 0, -1);
    CATransform3D rotation4 = CATransform3DMakeRotation(-120 * M_PI/180, 0, 0, -1);
    CATransform3D rotation5 = CATransform3DMakeRotation(-150 * M_PI/180, 0, 0, -1);
    CATransform3D rotation6 = CATransform3DMakeRotation(-180 * M_PI/180, 0, 0, -1);
    
    [animation setValues:@[[NSValue valueWithCATransform3D:rotation1],
                         [NSValue valueWithCATransform3D:rotation2],
                         [NSValue valueWithCATransform3D:rotation3],
                         [NSValue valueWithCATransform3D:rotation4],
                         [NSValue valueWithCATransform3D:rotation5],
                         [NSValue valueWithCATransform3D:rotation6]]];
    
    [animation setKeyTimes:@[@0.0, @0.2f, @0.4f, @0.6f, @0.8f, @1.0f]];
    [animation setDuration:duration];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    [animation setDelegate:self];
    
    [self.layer addAnimation:animation forKey:kRotation180Animation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.layer animationForKey:kPopOutAnimation])
    {
        [self.layer removeAnimationForKey:kPopOutAnimation];
        
        if (popOutAnimationblock)
        {
            popOutAnimationblock(flag);
            popOutAnimationblock = nil;
        }
    }
    else if (anim == [self.layer animationForKey:kRotation180Animation])
    {
        [self.layer removeAnimationForKey:kRotation180Animation];
        
        if (rotationAnimationblock)
        {
            rotationAnimationblock(flag);
            rotationAnimationblock = nil;
        }
    }
}

@end
