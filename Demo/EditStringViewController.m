//
//  EditStringViewController.m
//  Demo
//
//  Created by caifeng on 16/6/24.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "EditStringViewController.h"
#import "UIView+Extension.h"

@interface EditStringViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation EditStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 30)];
    label.text = @"你好,中国";
    [self.view addSubview:label];
    _label = label;
    
    
    // 画虚线
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.lineWidth = 1.0;
    shape.lineDashPattern = @[@3, @3];
    [label.layer addSublayer:shape];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, label.height)];
    [path addLineToPoint:CGPointMake(label.width, label.height)];
    shape.path = path.CGPath;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.label.text];
    NSRange range = [self.label.text rangeOfString:@"你好"];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],
                                  NSFontAttributeName : [UIFont systemFontOfSize:50],
                                  NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)} range:range];
    
    self.label.attributedText = attributeStr;
    
}



@end
