//
//  HeaderView.m
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "HeaderView.h"
#import "FlowView.h"


@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    
    self.backgroundColor = [UIColor colorWithRed:136/255.0 green:223/255.0 blue:51/255.0 alpha:1.0];
    FlowView *flowView = [[FlowView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 5, SCREEN_WIDTH, 5)];
    [self addSubview:flowView];
}



@end
