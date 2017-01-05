//
//  MusicPlayViewController.m
//  Demo
//
//  Created by caifeng on 16/9/1.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MusicPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicPlayViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;/**<播放进度*/
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;/**<音量滑块*/

@property (nonatomic, strong) AVAudioSession *session;/**<音频会话*/

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"bbquna.mp3" ofType:nil];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSError *error = nil;
    if (!_audioPlayer) {
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }
    [_audioPlayer prepareToPlay];

    // 设置可以改变播放速度
    _audioPlayer.enableRate = YES;
    
    _audioPlayer.numberOfLoops = 1; // 0 代表播放一次  1代表播放两次
    
    _audioPlayer.delegate = self;
    
    // 设置进度时间
    _timeSlider.maximumValue = _audioPlayer.duration;
    
    
    // 通过通知监听播放被电话打断
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInteruption:) name:AVAudioSessionInterruptionNotification object:session];
    
    // 拔出耳机后暂停或播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:session];
    
    // 监听系统音量调节
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    // 通过音频会话设置应用的音量
    NSLog(@"-----%f", session.outputVolume);
    _volumeSlider.value = session.outputVolume;
    
    
    // 设置后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
  
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}


- (void)volumeChange:(NSNotification *)noti {

    NSLog(@"==========%@", noti.userInfo);
    _volumeSlider.value = [noti.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
}



/**
 *  播放方式改变   耳机／手机
 *
 *  @param noti <#noti description#>
 */
- (void)handleRouteChange:(NSNotification *)noti {

    NSLog(@"%@", noti.userInfo);
    
    if ([noti.userInfo[AVAudioSessionRouteChangeReasonKey] intValue] == 2) { // 拔出耳机暂停
        [_audioPlayer pause];
    } else {
    
        [_audioPlayer play];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


/**
 *  响应远程控制
 *
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {

    NSLog(@"%ld--%ld", event.type, event.subtype);
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            
            case UIEventSubtypeRemoteControlPause:
                
                [_audioPlayer pause];
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                
                [_audioPlayer play];
                break;
                
            case UIEventSubtypeRemoteControlStop:
                
                [_audioPlayer stop];
                break;
                
            default:
                break;
        }
    }
    
}



/**
 *  更新进度
 */
- (void)updateProgress {

    _timeSlider.value = _audioPlayer.currentTime;
}


/**
 *   处理电话中断
 *
 */
- (void)handleInteruption:(NSNotification *)noti {

    NSLog(@"%@---%@", noti.userInfo, [noti.userInfo objectForKey:AVAudioSessionInterruptionTypeKey]);
    
    if ([[noti.userInfo objectForKey:AVAudioSessionInterruptionTypeKey] intValue] == 0) {
        [_audioPlayer play];
        NSLog(@"中断结束");
    }
}


- (IBAction)stop:(id)sender {
    [_audioPlayer stop];
    _audioPlayer.currentTime = 0;
}

- (IBAction)play:(id)sender {
    
        [_audioPlayer play];
}

- (IBAction)pause:(id)sender {
    [_audioPlayer pause];
}

/**
 *  播放进度改变
 *
 */
- (IBAction)timeSliderChange:(UISlider *)sender {
    
    _audioPlayer.currentTime = sender.value;
    
}


/**
 *  播放速度改变
 *
 */
- (IBAction)rateSliderChange:(UISlider *)sender {
    _audioPlayer.rate = sender.value;
}

/**
 *  音量改变
 *
 */
- (IBAction)volumeSliderChange:(UISlider *)sender {
    
    _audioPlayer.volume = sender.value;
    
    // 改变系统音量
//    MPMusicPlayerController *musicPlayerVc = [MPMusicPlayerController applicationMusicPlayer];
//    musicPlayerVc.volume = sender.value; // ios7.0 已过期
    
    
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        NSLog(@"%@", volumeView.subviews);
        [self.view addSubview:volumeView];
        UISlider *volumeSlider = nil;
        for (UIView *view in volumeView.subviews) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
    
                volumeSlider = (UISlider *)view;
                NSLog(@"xxxx%f", volumeSlider.value);
                break;
            }
        }
    //通过系统的音量视图设置系统音量
    [volumeSlider setValue:sender.value animated:YES];
}


#pragma  mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    // 播放完成调用
    NSLog(@"%s", __func__);
}


- (void)dealloc {

    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
