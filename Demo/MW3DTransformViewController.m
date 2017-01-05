//
//  ViewController.m
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "MW3DTransformViewController.h"
#import "CustomCell.h"
#import "HeaderView.h"
#import "NavView.h"


@interface MW3DTransformViewController () <UITableViewDelegate ,UITableViewDataSource ,UIScrollViewDelegate>

@property (nonatomic ,strong) NavView *navView; //导航栏视图
@property (nonatomic ,strong) UITableView *myTableView;
@property (nonatomic ,strong) HeaderView  *headerView;

@end

@implementation MW3DTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self creatTab];
}

- (void)creatTab{
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 30)];
    tipLabel.text = @"版权归大家所有";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor grayColor];
    [self.view addSubview:tipLabel];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myTableView];
    
    self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    self.myTableView.tableHeaderView = self.headerView;
    
    self.navView = [[NavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:self.navView];

}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)indexPath.row +1]];
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 100 && offsetY > 0) {
        
        self.navView.backgroundColor = [UIColor colorWithRed:73/255.0 green:210/255.0 blue:254/255.0 alpha:offsetY / 100.0];
    }else if(offsetY > 100){
        self.navView.backgroundColor = [UIColor colorWithRed:73/255.0 green:210/255.0 blue:254/255.0 alpha:1.0];
    }else{
        self.navView.backgroundColor = [UIColor clearColor];
    }
    NSLog(@"%f",scrollView.contentOffset.y);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
