//
//  ViewController.m
//  Demo
//
//  Created by caifeng on 16/6/7.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#import "BaseCollectionCell.h"
#import "BaseViewController.h"
#import "ScrollHiddenViewController.h"
#import "ScrollAnimationViewController.h"
#import "EditStringViewController.h"
#import "CapturePhotoAndVideoViewController.h"
#import "ShortAudioViewController.h"
#import "MusicPlayViewController.h"
#import "ListenBookTableViewController.h"
#import "RecordViewController.h"
#import "MWMusicPlayerViewController.h"
#import "MWMoviePlayerViewController.h"
#import "MWMoviePlayerViewController2.h"
#import "MWHareWareInfoViewController.h"
#import "MWAddressBookViewController.h"
#import "MWAddressBookViewController1.h"
#import "MWNSOperationViewController.h"
#import "MWAlbumVideoViewController.h"
#import "MWDynamicViewController.h"
#import "MW3DTransformViewController.h"
#import "FlowView.h"


#define kCustomCell @"Custom_CollectionCell"
#define kCustomReusableView @"Custom_ReusableView"

static NSString *scrollHidden = @"滑动隐藏", *scrollAnimation = @"scroll旋转动画", *editString = @"编辑字符串", *photoAndVideo = @"拍照和录制", *shortAudio = @"短音频", *musicPaly = @"播放音乐", *musicPlayer = @"音乐播放器", *listenBook = @"听书", *record = @"录音", *moviePlayer = @"视频播放", *hardWareInfo = @"硬件信息获取", *addressBook = @"通讯录有界面", *addressBook1 = @"通讯录无界面", *nsoperation = @"NSOperation", *albumvideo = @"相册视频" , *dynamic = @"物理仿真行为", *threedTransform = @"3D动画";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo List";
    _dataSource = @[scrollHidden, scrollAnimation,
                    editString, photoAndVideo,
                    shortAudio, musicPaly,musicPlayer,
                    listenBook, record,
                    moviePlayer, hardWareInfo,
                    addressBook, addressBook1, nsoperation, albumvideo, dynamic, threedTransform];
    
    
    [self setUpCollectionView];
    
    
    
}





#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource == nil ? 0 : self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
    cell.backgroundColor = kRandomColor;
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomReusableView forIndexPath:indexPath];
        headView.frame = CGRectMake(0, 0, self.view.width, 100);
        headView.backgroundColor = [UIColor blueColor];
        headView.alpha = 0.5;
        
        FlowView *flowView = [[FlowView alloc] initWithFrame:CGRectMake(0, 100 - 10, self.view.width, 9)];
        [headView addSubview:flowView];
        
        return headView;
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *text = self.dataSource[indexPath.row];
    BaseViewController *targetVC;
    if ([text isEqualToString:scrollHidden]) {
        
       targetVC = [[ScrollHiddenViewController alloc] init];
    } else if ([text isEqualToString:scrollAnimation]) {
    
       targetVC = [[ScrollAnimationViewController alloc] init];
    } else if ([text isEqualToString:editString]) {
        targetVC = [[EditStringViewController alloc] init];
    } else if ([text isEqualToString:photoAndVideo]) {
        targetVC = [[CapturePhotoAndVideoViewController alloc] init];
    } else if ([text isEqualToString:shortAudio]) {
        targetVC = [[ShortAudioViewController alloc] init];
    } else if ([text isEqualToString:musicPaly]) {
        targetVC = [[MusicPlayViewController alloc] init];
    } else if ([text isEqualToString:listenBook]) {
        ListenBookTableViewController *targetVC1 = [[ListenBookTableViewController alloc] init];
        [self.navigationController pushViewController:targetVC1 animated:YES];
        return;
    } else if ([text isEqualToString:record]){
        targetVC = [[RecordViewController alloc] init];
    } else if ([text isEqualToString:musicPlayer]) {
        targetVC = [[MWMusicPlayerViewController alloc] init];
    } else if ([text isEqualToString:moviePlayer]) {
//        targetVC = [[MWMoviePlayerViewController alloc] init];
       MWMoviePlayerViewController2 * targetVC = [[MWMoviePlayerViewController2 alloc] init];
        [self presentViewController:targetVC animated:YES completion:nil];
        return;
    } else if ([text isEqualToString:hardWareInfo]) {
        targetVC = [[MWHareWareInfoViewController alloc] init];
    } else if ([text isEqualToString:addressBook]) {
        targetVC = [[MWAddressBookViewController alloc] init];
    } else if ([text isEqualToString:addressBook1]) {
        targetVC = [[MWAddressBookViewController1 alloc] init];
    } else if ([text isEqualToString:nsoperation]) {
        targetVC = [[MWNSOperationViewController alloc] init];
    } else if ([text isEqualToString:albumvideo]) {
        targetVC = [[MWAlbumVideoViewController alloc] init];
    } else if ([text isEqualToString:dynamic]) {
        targetVC = [[MWDynamicViewController alloc] init];
    } else if ([text isEqualToString:threedTransform]) {
        targetVC = [[MW3DTransformViewController alloc] init];
    }
    
    
    targetVC.navTitle = text;
    [self.navigationController pushViewController:targetVC animated:YES];
}



#pragma mark - Helper method

- (void)setUpCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    layout.itemSize = CGSizeMake(80, 50);
    layout.headerReferenceSize = CGSizeMake(self.view.width, 100);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[BaseCollectionCell class] forCellWithReuseIdentifier:kCustomCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomReusableView];
    
    [self.view addSubview:self.collectionView];
}






@end
