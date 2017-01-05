//
//  ShortAudioViewController.m
//  Demo
//
//  Created by caifeng on 16/9/1.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "ShortAudioViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SoundPlayTool.h"

@interface ShortAudioViewController ()

@end

@implementation ShortAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    [self test];
    
    
    [[SoundPlayTool sharedSoundPlayTool] palySoundWithName:@"enemy3_down.mp3"];
}

// 播放一次短音频
- (void)test {

    NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:@"/sound.bundle/game_over.mp3" withExtension:nil];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlayAlertSound(soundID); // 震动
//    AudioServicesPlaySystemSound(soundID); // 不震动
    
}


@end
