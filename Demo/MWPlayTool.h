//
//  MWPlayTool.h
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <AVFoundation/AVFoundation.h>

@class MWMusic;

@interface MWPlayTool : NSObject
singleton_interface(MWPlayTool)

@property (nonatomic, strong) AVAudioPlayer *player;


/**
 *  准备播放
 *
 */
- (void)prepareToPlayWith:(MWMusic *)music;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

@end
