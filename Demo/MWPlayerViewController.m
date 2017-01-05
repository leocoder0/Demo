//
//  MWPlayerViewController.m
//  Demo
//
//  Created by caifeng on 16/9/10.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MJExtension.h"
#import "UIView+Extension.h"
#import "MWPlayerToolBar.h"
#import "NSString+Time.h"
#import <MediaPlayer/MediaPlayer.h>


@interface MWPlayerViewController ()<MWPlayerToolBarDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) MWPlayerToolBar *toolBar;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UISlider *systemVolumeSlider;

@end

@implementation MWPlayerViewController


#pragma mark - Life Circle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 64, self.view.width, 200);
    self.playerLayer.backgroundColor = kColorRGBA(1, 0, 0, 0.2).CGColor;

    [self.view.layer addSublayer:self.playerLayer];
    
    [self.playerLayer addSublayer:self.progressView.layer];
    
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.player play];
    
    [self addNotification];
    
    
 
    
    
}





- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

}





#pragma mark - MWPlayerToolBarDelegate

- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar stepValueChanged:(UIStepper *)stepper {

    self.toolBar.rateLabel.text = [NSString stringWithFormat:@"速度:%.1f", stepper.value];

    self.player.rate = stepper.value;
}

- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar playAndPauseBtnType:(MWPlayAndPauseBtnType)btnType {

    if (btnType == MWPlayAndPauseBtnTypePlay) {
        
        [self.player play];
    }
    
    
    if (btnType == MWPlayAndPauseBtnTypePause) {
        
        [self.player pause];
        
    }
    self.toolBar.rateLabel.text = [NSString stringWithFormat:@"速度:%.1f", self.player.rate];
}


- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar progressSliderValueChanged:(UISlider *)progressSlider {

    CMTime seekTime = CMTimeMake((int)progressSlider.value * 1000 , 1000);

    [self.player pause];
    
    [self.view removeGestureRecognizer:self.tap];

    
    [self.player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimePositiveInfinity completionHandler:^(BOOL finished) {
        
    }];
    
    
}

- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar progressSliderTouchUpInside:(UISlider *)progressSlider {

    [self addTapGesture];
    if (self.toolBar.isPlaying) {
        
        [self.player play];
        self.player.rate = self.toolBar.stepper.value;
    }
}


#pragma mark - Helper Methods

#pragma mark ---- screenOrientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    /*
     UIInterfaceOrientationUnknown            = UIDeviceOrientationUnknown,
     UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
     UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
     UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
     UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
     */
    
    if (toInterfaceOrientation == UIInterfaceOrientationUnknown) {
        
        NSLog(@"UIInterfaceOrientationUnknown");
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
      
        NSLog(@"UIInterfaceOrientationPortrait");

        [self hideStatusbarAndNavigationBarWithStatus:NO];
        
        self.progressView.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.progressView.hidden = NO;

        });
        
        self.playerLayer.frame = CGRectMake(0, 64, self.view.bounds.size.width, 200);
        
        [self.view removeGestureRecognizer:self.tap];
        [self.toolBar removeFromSuperview];

    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        NSLog(@"UIInterfaceOrientationPortraitUpsideDown");

    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
       
        NSLog(@"UIInterfaceOrientationLandscapeLeft");
        
        [self hideStatusbarAndNavigationBarWithStatus:YES];
        
//        self.progressView.hidden = YES;
        NSLog(@"%@", self.navigationController.navigationBar.subviews);

        
        self.playerLayer.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        // plist配置之后 通过下面方法来显示隐藏状态栏
        
        [self addTapGesture];
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
       
        NSLog(@"UIInterfaceOrientationLandscapeRight");

        [self hideStatusbarAndNavigationBarWithStatus:YES];
        
//        self.progressView.hidden = YES;
        

        
        self.playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        [self addTapGesture];

    }
    
    self.progressView.frame = CGRectMake(0, self.playerLayer.bounds.size.height-1, self.playerLayer.bounds.size.width, 5);
}



#pragma mark ---- Gesture
- (void)addTapGesture {

    //tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerTap)];
    _tap = tap;
    
    //pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {

    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    
    CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
    CGFloat totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (ABS(point.x) > 30 && ABS(point.y) < 30) {
            
            [self.player pause];
            
            CGFloat changeTime = point.x / 20;
            currentTime = currentTime + changeTime;
            
            //        NSLog(@"%f", currentTime);
            [self.player seekToTime:CMTimeMake(currentTime * 1000, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimePositiveInfinity completionHandler:^(BOOL finished) {
                
              
            }];
            
            return;
        }
        
        if (ABS(point.x) < 30 && ABS(point.y) > 30) {
    
            if (location.x > 0.5 * kScreenWidth) {
                
                // 音量调节
                MPVolumeView *volumeView = [[MPVolumeView alloc] init];
                UISlider *volumeSlider = nil;
                for (UIView *view in volumeView.subviews) {
                    if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                        
                        volumeSlider = (UISlider *)view;
                    }
                }
                
                CGFloat currentVolume = volumeSlider.value;
                CGFloat changedVolue = point.y / 100;
                currentVolume = currentVolume - changedVolue;
                [volumeSlider setValue:currentVolume animated:YES];
                self.systemVolumeSlider = volumeSlider;
                
                NSLog(@"%f--%f--%f", self.player.volume, point.y, currentVolume);
                
                
            } else {
            
                // 亮度
                CGFloat currentbrightness = [UIScreen mainScreen].brightness;
                CGFloat changedbrightness = point.y / 100;
                currentbrightness = currentbrightness - changedbrightness;
                [UIScreen mainScreen].brightness = currentbrightness;
            }
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
      
        [self.player play];
        self.player.rate = self.toolBar.stepper.value;
        self.toolBar.rateLabel.text = [NSString stringWithFormat:@"速度:%.1f", self.player.rate];
    }
    
    
    
}

- (void)playerTap {

    [self hideStatusbarAndNavigationBarWithStatus:!self.navigationController.navigationBar.hidden];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self hideStatusbarAndNavigationBarWithStatus:YES];
//    });
//    

}


#pragma mark ---- toolBar&&NavBar control
- (void)hideStatusbarAndNavigationBarWithStatus:(BOOL)status {

    [[UIApplication sharedApplication] setStatusBarHidden:status withAnimation:UIStatusBarAnimationFade];
    self.navigationController.navigationBar.hidden = status;
//    self.navigationController.navigationBar.backgroundColor = kColorRGBA(1, 1, 1, 0.4);
    
    if (status) {
        
        [self.toolBar removeFromSuperview];
        
        self.progressView.hidden = NO;
        
    } else {
        
        self.progressView.hidden = YES;
        
        self.toolBar = [MWPlayerToolBar sharedMWPlayerToolBar];
        
        // 为toolBar赋值
        self.toolBar.delegate = self;
        self.toolBar.rateLabel.text = [NSString stringWithFormat:@"速度:%.1f", self.player.rate];
        self.toolBar.progressSlider.maximumValue = [self.video.duration floatValue];
        CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
        self.toolBar.currentTimeLabel.text = [NSString getMinuteSecondWithSecond:currentTime];
        self.toolBar.totalTimeLabel.text = [NSString getMinuteSecondWithSecond:[self.video.duration floatValue]];
        
        self.toolBar.layer.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
        [self.view addSubview:self.toolBar];
    }
}



#pragma mark - Notification && KVO

#pragma mark ---- playFinishedNotification
- (void)playFinished:(NSNotification *)noti {
    
    NSLog(@"playFinished");
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)appEnterBackGroud:(NSNotification *)noti {


    NSLog(@"appEnterBackGroud");

    [self.player pause];
    self.toolBar.rateLabel.text = [NSString stringWithFormat:@"速度:%.1f", self.player.rate];

}

- (void)appBecomeActive:(NSNotification *)noti {

    NSLog(@"BecomeActive--%ld",(long)[UIDevice currentDevice].orientation);
  
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        
        [self hideStatusbarAndNavigationBarWithStatus:NO];
    }
    
    [self.toolBar.playAndPauseBtn setNBg:@"playbar_playbtn_nomal.png" hBg:@"playbar_playbtn_click.png"];
}


- (void)systemVolumeChanged:(NSNotification *)noti {

    [self.systemVolumeSlider setValue:[noti.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue] animated:YES];
}

- (void)addNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackGroud:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:) name:@"AVSystemController_AudioVolumeNotificationParameter" object:nil];
}

- (void)removeNotification {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark ---- progress
- (void)addProgressObserver {

    AVPlayerItem *playerItem = self.player.currentItem;
    
    __weak typeof(self) weakSelf = self;
    CMTime interval = CMTimeMakeWithSeconds(0.1, NSEC_PER_USEC);
    [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float currentTime = CMTimeGetSeconds(time);
        float totalTime = CMTimeGetSeconds(playerItem.duration);

        if (currentTime) {
            
            if (weakSelf.toolBar) {
                
                [weakSelf.toolBar.progressSlider setValue:currentTime animated:YES];
                weakSelf.toolBar.currentTimeLabel.text = [NSString getMinuteSecondWithSecond:currentTime];
            }
            
            if (weakSelf.progressView) {
                
                [weakSelf.progressView setProgress:currentTime / totalTime animated:YES];
            }
            
            
        }
    }];
    
}


#pragma mark ---- status && loadRange KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
    
        NSLog(@"%@", change);
    } else if ( [keyPath isEqualToString:@"loadedTimeRanges"]) {
    
        NSArray *arr = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [arr.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f---%.2f---%.2f---progress:%.2f",startSeconds, durationSeconds, CMTimeGetSeconds(playerItem.duration), durationSeconds / CMTimeGetSeconds(playerItem.duration));
    }
}


- (void)addObservertoPlayerItem:(AVPlayerItem *)playerItem {

    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {

    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}


#pragma mark - Lazy Methods

- (AVPlayer *)player {

    if (!_player) {
        
        NSURL *url;
        if (_video) {
            
            url = _video.videoUrl;
        } else {
        
            NSString *urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [NSURL URLWithString:urlStr];
        }
        
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        [self addObservertoPlayerItem:playerItem];
        [self addProgressObserver];
        
    }
    return _player;
}


- (UIProgressView *)progressView {

    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.playerLayer.bounds.size.height-1, self.playerLayer.bounds.size.width, 5)];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}


- (void)dealloc {

    NSLog(@"%s", __func__);

    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}


@end
