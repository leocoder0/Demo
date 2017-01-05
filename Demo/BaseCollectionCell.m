//
//  BaseCollectionCell.m
//  Demo
//
//  Created by caifeng on 16/6/7.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "UIView+Extension.h"


@implementation BaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        
    }
    return  self;
}

@end
