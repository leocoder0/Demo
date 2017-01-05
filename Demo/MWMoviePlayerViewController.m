//
//  MWMoviePlayerViewController.m
//  Demo
//
//  Created by caifeng on 16/9/4.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MWMoviePlayerViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation MWMoviePlayerViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    NSURL *movieUrl = [[NSBundle mainBundle] URLForResource:@"promo_full.mp4" withExtension:nil];
    
     _moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    
    _moviePlayerController.view.frame = self.view.bounds;
    
    // 设置旋转屏膜适配
    _moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_moviePlayerController.view];
    
    [_moviePlayerController prepareToPlay];
    
    [_moviePlayerController play];
    
    
    // 监听完成按钮点击
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(exit) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    // 监听播放完成
    [center addObserver:self selector:@selector(exit) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    
    
    // 监听截屏
    [_moviePlayerController requestThumbnailImagesAtTimes:@[@(3.0)] timeOption:MPMovieTimeOptionNearestKeyFrame];
    [center addObserver:self selector:@selector(captureImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
}


- (void)captureImage:(NSNotification *)noti {
    NSLog(@"%@", noti.userInfo);
    
}

- (void)exit {

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
