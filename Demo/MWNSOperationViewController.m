//
//  MWNSOperationViewController.m
//  Demo
//
//  Created by caifeng on 16/9/6.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWNSOperationViewController.h"
#import "MJExtension.h"
#import "MWApp.h"

#import "Reachability.h"

@interface MWNSOperationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *appList;

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *imageCache;

@property (nonatomic, strong) NSMutableDictionary *operationCache;

@property (nonatomic, strong) Reachability *reach;

@end

@implementation MWNSOperationViewController

- (NSArray *)appList {

    if (!_appList) {
        _appList = [MWApp objectArrayWithFilename:@"apps.plist"];
    }
    return _appList;
}

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (NSOperationQueue *)queue {

    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}


- (NSMutableDictionary *)imageCache {

    if (!_imageCache) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}

- (NSMutableDictionary *)operationCache {

    if (!_operationCache) {
        _operationCache = [NSMutableDictionary dictionary];
    }
    return _operationCache;
}


- (Reachability *)reach {

    if (!_reach) {
        _reach = [Reachability reachabilityWithHostName:@"baidu.com"];
    }
    return _reach;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 120;
    
    
    // 网络监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachStatusChanged) name:kReachabilityChangedNotification object:nil];
    
    [self.reach startNotifier];
}


- (void)reachStatusChanged {

    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
            
            NSLog(@"无连接");
            break;
        
        case ReachableViaWiFi:
            
            NSLog(@"wifi");
            break;
            
        case ReachableViaWWAN:
            
            NSLog(@"3g/4g");
            break;
            
        default:
            break;
    }
}









- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.appList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reuseId = @"appcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    
    MWApp *app = self.appList[indexPath.row];
    
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.download;
    
    if ([self.imageCache objectForKey:app.icon]) {//内存有数据
        
        cell.imageView.image = self.imageCache[app.icon];
    } else {
    
        UIImage *image = [UIImage imageWithContentsOfFile:[self cachePathWithUrlStr:app.icon]];
        if (image) { // 沙盒有图片
            
            NSLog(@"从沙盒取图片。。。。");
            cell.imageView.image = image;
            [self.imageCache setValue:image forKey:app.icon];
        } else {
        
            NSLog(@"从网上下载图片");
            cell.imageView.image = [UIImage imageNamed:@"user_default.png"];
            [self loadImageWithIndexPath:indexPath];
        }
        
    }

    
    return cell;
}



- (void)loadImageWithIndexPath:(NSIndexPath *)indexPath {
    MWApp *app = self.appList[indexPath.row];
    
    if ([self.operationCache objectForKey:app.icon]) {
        NSLog(@"正在玩命下载中....");
        return;
    }

    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"添加操作");

        [NSThread sleepForTimeInterval:2.0];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
        UIImage *iconImage = [UIImage imageWithData:imageData];
        
        if (iconImage) {
            [self.imageCache setValue:iconImage forKey:app.icon];
            
            // 将图片存入沙盒
            [imageData writeToFile:[self cachePathWithUrlStr:app.icon] atomically:YES];

            // 完成一个操作久删除
            [self.operationCache removeObjectForKey:app.icon];
        }
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }];
    
    [self.queue addOperation:op];
    
    [self.operationCache setValue:op forKey:app.icon];
    
    NSLog(@"------%ld", self.queue.operationCount);
    
}



- (NSString *)cachePathWithUrlStr:(NSString *)urlStr {

    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"===%@", cachePath);
    return  [cachePath stringByAppendingPathComponent:urlStr.lastPathComponent];

}



- (void)didReceiveMemoryWarning {

    // 清楚图片缓存
    [self.imageCache removeAllObjects];
    
    // 清除操作缓存
    [self.operationCache removeAllObjects];
    
    
    // 队列删除操作
    [self.queue cancelAllOperations];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%@", self.operationCache);
}


- (void)dealloc {

    NSLog(@"%s", __func__);
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reach stopNotifier];
}





#pragma mark -


@end
