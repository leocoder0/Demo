//
//  MWMoviePlayerViewController2.m
//  Demo
//
//  Created by caifeng on 16/9/4.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWMoviePlayerViewController2.h"
#import <AVFoundation/AVFoundation.h>

@interface MWMoviePlayerViewController2 ()<AVPlayerViewControllerDelegate>

@end

@implementation MWMoviePlayerViewController2

- (void)viewDidLoad {

    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"promo_full.mp4" withExtension:nil];
   
    self.player = [AVPlayer playerWithURL:url];
    [self.player play];
    
    
    // 实现画中画？？待解决
//    AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] init];
//    playerLayer.player = self.player;
//    playerLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:playerLayer];

    
    self.allowsPictureInPicturePlayback = YES;
    
//    self.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.delegate = self;

    // 监听播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
}


- (void)exit {

    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController {

    NSLog(@"%s",__func__);
}

- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%s",__func__);

}


- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"%s",__func__);

}

@end
