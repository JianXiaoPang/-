//
//  DDImageView.m
//  dd
//
//  Created by darkdong on 13-11-28.
//  Copyright (c) 2013年 PixShow. All rights reserved.
//

#import "DDImageView.h"
#import "DDPreprocessMacro.h"
//#import "DDGlobal.h"
#import "UIView+Additions.h"

@interface DDImageView ()
@end

@implementation DDImageView

- (void)commonInit {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.touchEventEnabled = YES;
    self.cancelTrackingWhenDraggingInside = YES;
}

- (id)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self  = [super initWithImage:image];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self  = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - private

- (void)cancelTracking {
    [self.button cancelTrackingWithEvent:nil];
}

#pragma mark - public

- (void)setCancelTrackingWhenDraggingInside:(BOOL)cancelTrackingWhenDraggingInside {
    if (cancelTrackingWhenDraggingInside) {
        [self.button addTarget:self action:@selector(cancelTracking) forControlEvents:UIControlEventTouchDragInside];
    }else {
        [self.button removeTarget:self action:@selector(cancelTracking) forControlEvents:UIControlEventTouchDragInside];
    }
}

- (void)setTouchEventEnabled:(BOOL)enabled {
    self.userInteractionEnabled = enabled;
    
    if (enabled) {
        if (!_button) {
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.size = self.size;
            _button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview:_button];
        }
    }else {
        if (_button) {
            [_button removeFromSuperview];
            _button = nil;
        }
    }
}

@end
