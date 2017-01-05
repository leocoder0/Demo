//
//  SoundPlayTool.m
//  Demo
//
//  Created by caifeng on 16/9/1.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "SoundPlayTool.h"

@implementation SoundPlayTool

static NSDictionary *soundIDDic; /**<存储加载到内存中所有的soundID*/
singleton_implementation(SoundPlayTool)

+ (void)initialize {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"sound.bundle" ofType:nil];
    NSError *error = nil;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:soundPath error:&error];
    NSLog(@"==%@", contents);
    
    NSMutableDictionary *soundIDDicM = [NSMutableDictionary dictionary];
    for (NSString *soundName in contents) {
        
        NSString *urlStr = [soundPath stringByAppendingPathComponent:soundName];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) url, &soundID);
        
        soundIDDicM[soundName] = @(soundID);
    }
    soundIDDic = soundIDDicM;
    NSLog(@"====%@", soundIDDic);
}


- (void)palySoundWithName:(NSString *)soundName {

    SystemSoundID soundID = [soundIDDic[soundName] unsignedIntValue];
    AudioServicesPlayAlertSound(soundID);
}


@end
