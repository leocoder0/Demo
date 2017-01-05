//
//  ListenBookTableViewController.m
//  Demo
//
//  Created by caifeng on 16/9/2.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "ListenBookTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MJExtension.h"
#import "MWWord.h"

@interface ListenBookTableViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *words;/**<所有诗词的模型数组*/
@property (nonatomic, strong) CADisplayLink * link; /**<定时器*/
@property (nonatomic, strong) AVAudioPlayer *bgMusicPlayer; /**<背景音乐播放器*/
@property (nonatomic, strong) AVAudioPlayer *wordMusicPlayer; /**<诗词播放器*/

@end

@implementation ListenBookTableViewController

#pragma mark - Lazy Method
- (NSArray *)words {

    if (!_words) {
        _words = [MWWord objectArrayWithFilename:@"一东.plist"];
    }
    return _words;
}

- (CADisplayLink *)link {

    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    return _link;
}


- (AVAudioPlayer *)bgMusicPlayer {

    if (!_bgMusicPlayer) {
        NSURL *bgMusicUrl = [[NSBundle mainBundle] URLForResource:@"Background.caf" withExtension:nil];
        _bgMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgMusicUrl error:nil];
        _bgMusicPlayer.numberOfLoops = -1;
        [_bgMusicPlayer prepareToPlay];
    }
    return _bgMusicPlayer;
}

- (AVAudioPlayer *)wordMusicPlayer {

    if (!_wordMusicPlayer) {
        NSURL * wordMusicUrl = [[NSBundle mainBundle] URLForResource:@"一东.mp3" withExtension:nil];
        _wordMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:wordMusicUrl error:nil];
        [_wordMusicPlayer prepareToPlay];
        _wordMusicPlayer.delegate = self;
    }
    return _wordMusicPlayer;
}



#pragma  mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"word"];
    
    // 启动定时器
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // 播放
    [self.bgMusicPlayer play];
    [self.wordMusicPlayer play];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
//    [self.bgMusicPlayer stop];
//    [self.wordMusicPlayer stop];
    /**
     *  界面消失时移除定时器并将定时器置空 否则会因为定时器的强引用问题（displayLinkWithTarget：） 不会掉用delloc方法
     */
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.link = nil;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"word" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.words[indexPath.row] text];
    return cell;
}


#pragma mark - AVAudioPlayerDelegte

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {

    [self.bgMusicPlayer stop];
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}



#pragma mark - helper method

- (void)update {
    
    double currentTime = self.wordMusicPlayer.currentTime;
    
    NSInteger maxIndex = self.words.count - 1;
    
    // 倒序遍历words
    for (NSInteger i = maxIndex; i >= 0; i--) {
        
        MWWord *word = (MWWord *)self.words[i];
        if (currentTime >= word.time) {
          
            // 选择dangq阅读的一行
            [self selectRowAtIndex:i];
            break;
        }
        
    }
}


- (void)selectRowAtIndex:(NSInteger)index {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
}


- (void)dealloc {

    [self.bgMusicPlayer stop];
    [self.wordMusicPlayer stop];

}

@end
