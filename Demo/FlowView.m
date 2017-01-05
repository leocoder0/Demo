//
//  FlowView.m
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "FlowView.h"

@implementation FlowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    
    self.shapLayer = [[CAShapeLayer alloc] init];
    self.shapLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:self.shapLayer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLikAction)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.speed = 2.0;
    self.offset = 0;
}

- (void)displayLikAction{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGMutablePathRef mutablePathRef = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePathRef, NULL, 0, 0);
    
    self.offset -= 6.0;
    CGFloat y;
    for (CGFloat x = 0.0; x < width; x ++) {
        
        y = height * sin(0.01 *(self.speed * x + self.offset));
        CGPathAddLineToPoint(mutablePathRef, NULL, x, y);
    }
    
    CGPathAddLineToPoint(mutablePathRef, NULL, width, height);
    CGPathAddLineToPoint(mutablePathRef, NULL, 0, height);

    CGPathCloseSubpath(mutablePathRef);
    self.shapLayer.path = mutablePathRef;
    CGPathRelease(mutablePathRef);
}



@end
