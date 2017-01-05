//
//  UIView+Extension.h
//  Demo
//
//  Created by caifeng on 16/6/7.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <UIKit/UIKit.h>


// 颜色

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define kRandomColor kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface UIView (Extension)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat x, y, width, height;
@property (nonatomic, assign) CGFloat left, right, top, bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, readonly) CGPoint boundsCenter;

@end
