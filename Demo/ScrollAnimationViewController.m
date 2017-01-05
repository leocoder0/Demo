//
//  ScrollAnimationViewController.m
//  Demo
//
//  Created by caifeng on 16/6/12.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "ScrollAnimationViewController.h"

#import "UIView+Extension.h"

@interface ScrollAnimationViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *leftView;

@end

@implementation ScrollAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.height - 200, self.view.width, 100)];
    self.scrollView.contentSize = CGSizeMake(8 * 100 + 7 * 3, 100);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    
    [self setupSubViews];
    
}

- (void)setupSubViews {

    
    for (int i = 0;  i < 8; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((100 + 3) * i, 0, 100, 100)];
        imageView.backgroundColor = kRandomColor;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
    }
    
   
}


- (void)tap:(UITapGestureRecognizer *)tap {

    NSLog(@"%@", tap.view);
    NSLog(@"%@", self.scrollView);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", self.scrollView.contentOffset.x);

    if (scrollView.contentOffset.x <= 0 && scrollView.contentOffset.x > -100) {
//        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.view addSubview:self.leftView];
        
//        self.leftView.transform = CGAffineTransformMakeTranslation(-scrollView.contentOffset.x, 0);
        
    } else if (scrollView.contentOffset.x <= -100) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        self.leftView.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
    }
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {

//    NSLog(@"%f", velocity.x);
    if (ABS(velocity.x) > 0.5 && self.scrollView.contentOffset.x > 0) {
    
        NSArray *imageViews = self.scrollView.subviews;
        
        for (UIImageView *imageView in imageViews) {
            [UIView animateWithDuration:0.3 animations:^{
                
                imageView.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
            } completion:nil];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSArray *imageViews = self.scrollView.subviews;

    for (UIImageView *imageView in imageViews) {
        [UIView animateWithDuration:0.3 animations:^{
            
            imageView.layer.transform = CATransform3DIdentity;
            if (scrollView.contentOffset.x > 0) {
                
                imageView.transform = CGAffineTransformMakeScale(1.1, 1);
            }
        } completion:^(BOOL finished) {
            imageView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    if (self.scrollView.contentOffset.x == 0) {
    
        [self.view addSubview:self.leftView];
    }
}



- (UIView *)leftView {

    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(- self.view.width, 0, self.view.width, CGRectGetMaxY(self.scrollView.frame))];
        _leftView.backgroundColor = kColorRGBA(0, 0, 1, 0.2);
      
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_leftView.width - 50, _leftView.height - 100, 100, 100)];
        view.backgroundColor = [UIColor blueColor];
        view.alpha = 0.4;
        view.layer.cornerRadius = 50;
        [_leftView addSubview:view];
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, _leftView.height - 100, _leftView.width, 100)];
        tempView.backgroundColor = [UIColor blueColor];
        [_leftView addSubview:tempView];
    }
    return _leftView;
}

@end
