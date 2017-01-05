//
//  SoundPlayTool.h
//  Demo
//
//  Created by caifeng on 16/9/1.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundPlayTool : NSObject
singleton_interface(SoundPlayTool)

/**
 *  根据声音名字播放声音
 *
 */
- (void)palySoundWithName:(NSString *)soundName;

@end
