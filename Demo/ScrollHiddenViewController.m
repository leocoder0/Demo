//
//  ScrollHiddenViewController.m
//  Demo
//
//  Created by caifeng on 16/6/7.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "ScrollHiddenViewController.h"
#import "UIView+Extension.h"

@interface ScrollHiddenViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScrollHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    topView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:topView];
    _topView = topView;
    
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), self.view.width, 40)];
    midView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:midView];
    _midView = midView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(midView.frame), self.view.width, self.view.height - topView.height - midView.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    _tableView.backgroundColor = [UIColor redColor];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSLog(@"%f", scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y > 200) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _topView.transform = CGAffineTransformMakeTranslation(0, -100);
            _midView.transform = CGAffineTransformMakeTranslation(0, -100);
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(_midView.frame), self.view.width, self.view.height - _midView.height);
        }];
    } else {
    
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_midView.frame), self.view.width, self.view.height - _topView.height - _midView.height);
        [UIView animateWithDuration:0.5 animations:^{
            
            _topView.transform = CGAffineTransformIdentity;
            _midView.transform = CGAffineTransformIdentity;
        }];
    }
}



@end
