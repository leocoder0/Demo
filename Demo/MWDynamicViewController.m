//
//  MWDynamicViewController.m
//  Demo
//
//  Created by caifeng on 16/9/14.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWDynamicViewController.h"
#import "UIView+Extension.h"

@interface MWDynamicViewController ()

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;

@property (nonatomic, strong) UIDynamicAnimator *animator;/**<物理仿真器*/

@end

@implementation MWDynamicViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    /**
     *  UIPushBehavior
     *  UIFieldBehavior
     */
    
    
//    // 移除已有的行为
//    [self.animator removeAllBehaviors];
//    
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    // 创建捕获仿真
//    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.blueView snapToPoint:point];
//    
//    // 阻力
//    snap.damping = 2.0;
//    
//    [self.animator addBehavior:snap];
//    
    
    
    [self gravityAndCollision];
}


/**
 *  重力和碰撞仿真
 */
- (void)gravityAndCollision {

    NSArray *items = @[self.redView];
    
    // 创建重力仿真行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:items];
    
    // 设置重力向量
//    gravity.gravityDirection = CGVectorMake(-2.0, 1.0);
    
    // 创建碰撞仿真行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:items];
    
    // 设置碰撞边界
    // 1.仿真范围边缘
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 2.自定义路线
        [collision addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(0, 350) toPoint:CGPointMake(self.view.width, 350)];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 375, 375)];
//    [collision addBoundaryWithIdentifier:@"bezierPath" forPath:bezierPath];
    
    
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}


- (UIDynamicAnimator *)animator {

    if (!_animator) {
        
        // ReferenceView 仿真范围
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}


@end
