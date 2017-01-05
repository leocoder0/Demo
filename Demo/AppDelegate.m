//
//  AppDelegate.m
//  Demo
//
//  Created by caifeng on 16/6/7.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    
    // 设置音乐会话为后台播放
    AVAudioSession *session =  [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    // 开启接受远程通知
    [application beginReceivingRemoteControlEvents];
    
    return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    //开启后台播放
    [application beginBackgroundTaskWithExpirationHandler:nil];
}

// 远程通知

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {

    if (_playerRemoteEvent) {
        _playerRemoteEvent(event);
    }
}


@end
