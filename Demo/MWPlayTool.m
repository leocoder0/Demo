//
//  MWPlayTool.m
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWPlayTool.h"
#import "MWMusic.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MWPlayTool ()


@end

@implementation MWPlayTool
singleton_implementation(MWPlayTool)

- (void)prepareToPlayWith:(MWMusic *)music {

    NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:music.filename withExtension:nil];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
    [_player prepareToPlay];
    
    
    //设置锁屏音乐信息 （最好在进入后台的时候设置）
    NSMutableDictionary *musicInfo = [NSMutableDictionary dictionary];
    
    // 专辑
    musicInfo[MPMediaItemPropertyAlbumTitle] = @"十大金曲";
    // 歌曲
    musicInfo[MPMediaItemPropertyTitle] = music.name;
    // 歌手
    musicInfo[MPMediaItemPropertyArtist] = music.singer;
    // 图片
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:music.icon]];
    musicInfo[MPMediaItemPropertyArtwork] = artwork;
    // 时间
    musicInfo[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = musicInfo;
}


- (void)play {

    [_player play];
}

- (void)pause {

    [_player pause];
}

@end
