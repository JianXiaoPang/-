//
//  DDProgressView.m
//  dd
//
//  Created by darkdong on 13-11-28.
//  Copyright (c) 2013年 PixShow. All rights reserved.
//

#import "DDProgressView.h"
#import "DDGlobal.h"
#import "UIView+Additions.h"

@interface DDProgressView ()

@property(nonatomic) UIBezierPath *piePath;
@property(nonatomic) UIBezierPath *circlePath;

@end

@implementation DDProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        self.pieColor = self.backgroundColor;
        self.circleColor = RGBACOLOR(255, 255, 255, 0.2);
        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        [circlePath addArcWithCenter:CGPointMake(self.width / 2, self.height / 2) radius:self.width * 0.3 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        self.circlePath = circlePath;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.circleColor.CGColor);
    [self.circlePath fill];
    
    CGContextSetFillColorWithColor(context, self.pieColor.CGColor);
    [self.piePath fill];
}

- (void)setProgress:(float)progress {
    float radians = 2 * M_PI * progress;
    CGPoint center = CGPointMake(self.width / 2, self.height / 2);
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    
    [piePath moveToPoint:center];
    [piePath addArcWithCenter:center radius:self.width / 4 startAngle:-M_PI_2 + radians endAngle:M_PI_2 + M_PI clockwise:YES];
    self.piePath = piePath;
    
    [self setNeedsDisplay];
}

@end
