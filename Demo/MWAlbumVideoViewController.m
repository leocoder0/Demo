//
//  MWAlbumVideoViewController.m
//  Demo
//
//  Created by caifeng on 16/9/10.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWAlbumVideoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWAlbumVideo.h"
#import "MWPlayerViewController.h"
#import "UIView+Extension.h"
#import "MWVideoCollectionViewItem.h"


@interface MWAlbumVideoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation MWAlbumVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"网上视频" style:UIBarButtonItemStylePlain target:self action:@selector(playApacheVideo)];
    
    
    // 获取相册视频
    [self obtainAlbumVideos];
    
    [self.view addSubview:self.collectionView];
    
    
    
    
}

- (void)playApacheVideo {

    MWPlayerViewController *playerVC = [[MWPlayerViewController alloc] init];
    
    playerVC.urlStr = @"http://192.168.188.2/resouce/videos/15-POST上传JSON数据.MP4";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.navigationController pushViewController:playerVC animated:YES];
    
}



- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
   
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.videos.count == 0 ? 0 : self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MWVideoCollectionViewItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = kRandomColor;
    
    cell.video = self.videos[indexPath.item];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MWPlayerViewController *playerVC = [[MWPlayerViewController alloc] init];
    playerVC.video = self.videos[indexPath.item];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.navigationController pushViewController:playerVC animated:YES];

}


#pragma mark - Helper Methods
/**
 *  获取视频
 */
- (void)obtainAlbumVideos {

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
//        NSLog(@"%@", group);
        
        if (group) {
            
            // 设置资源类型
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            
            // 遍历资源
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
               
//                NSLog(@"%@", result);
                if (result) {
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                      
//                        NSLog(@"photo");
                        
                    } else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                     
//                        NSLog(@"%@", result);
                        
                        MWAlbumVideo *video = [[MWAlbumVideo alloc] init];
                        video.name = result.defaultRepresentation.filename;
                        video.size = result.defaultRepresentation.size;
                        video.duration = [result valueForProperty:ALAssetPropertyDuration];
                        video.format = [result.defaultRepresentation.filename pathExtension];
//                        video.thumbnail = [UIImage imageWithCGImage:result.thumbnail];
                        video.thumbnail = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];// 更清晰一些

                        video.videoUrl = [result valueForProperty:ALAssetPropertyAssetURL];
                        
                        [self.videos addObject:video];
                        
                    }
                    
                }

                [self.collectionView reloadData];
                
            }];
        }
        
    } failureBlock:^(NSError *error) {
        
    
    }];
    
    
}


#pragma mark - 横屏控制
- (BOOL)shouldAutorotate {

    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return UIInterfaceOrientationPortrait;
}



#pragma mark - Lazy Methods

- (UICollectionView *)collectionView {

    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(160, 120);
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 15;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MWVideoCollectionViewItem" bundle:nil] forCellWithReuseIdentifier:@"item"];
        
    }
    
    return _collectionView;
}

- (NSMutableArray *)videos {

    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (NSMutableArray *)photos {
    
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}



- (void)dealloc {

    NSLog(@"%s", __func__);
}

@end
