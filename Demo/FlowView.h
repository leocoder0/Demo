//
//  FlowView.h
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowView : UIView

@property (nonatomic ,strong) CAShapeLayer *shapLayer;

@property (nonatomic ,strong) CADisplayLink *displayLink; //定时器，刷新频率同步与手机

@property (nonatomic ,assign) CGFloat speed;//移动速度

@property (nonatomic ,assign) CGFloat offset;//偏移量
@end
