//
//  NavView.m
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "NavView.h"

@implementation NavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 -100, 20, 200, 44)];
    navLabel.text = @"我是标题";
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.textColor = [UIColor whiteColor];
    [self addSubview:navLabel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
